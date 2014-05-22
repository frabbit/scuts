
package scuts.ht.macros;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.ExprTools;
using Lambda;

class ImplicitSyntaxImpl {

	macro public static function build (marker:Bool):Array<Field>
	{

		var cl = Context.getLocalClass();

		if (cl == null) throw "error";
		var meta = cl.get().meta;
		var fields = Context.getBuildFields();
		var interfaces = cl.get().interfaces;
		var doesExplicitImplement = interfaces.exists(function (i)
			return (i.t.get().name == "ImplicitSyntax" || i.t.get().name == "ExplicitSyntax") && switch (i.t.get().pack) {
				case ["scuts", "ht", "syntax"]: true;
				case _ : false;
			}
		);
		return if (!meta.has(MARKER) && doesExplicitImplement) {
			meta.add(MARKER,[], Context.currentPos());
			[for (f in fields) transformField(f, marker)];
		} else fields;
	}

	#if macro

	static var MARKER = ":scuts.ht.macros.ImplicitSyntaxImpl";
	public static function transformField (f:haxe.macro.Expr.Field, marker:Bool) {

		return {
			pos : f.pos,
			name : f.name,
			meta : f.meta,
			kind : tranformKind(f.kind, marker),
			doc : f.doc,
			access : f.access,
		}
	}

	public static function tranformKind (f:FieldType, marker:Bool) {
		return switch (f)
		{
			case FFun(f):
				FFun({
					args : f.args,
					expr : transformExpr(f.expr, marker),
					params : f.params,
					ret : f.ret
				});
			case x : x;
		}
	}

	public static function transformExpr (e:Expr, marker:Bool) {

		function iter (e:Expr) {
			switch (e) {
				case { expr : ESwitch(e,cases,edef) }:
					ExprTools.iter(e, iter);
					for (c in cases) {
						ExprTools.iter(c.expr, iter);
					}
					if (edef != null) {
						ExprTools.iter(edef, iter);
					}
				case macro $c($a{params}): {
					// map subexpressions
					ExprTools.iter(e, iter);

					if (marker) {
						if (params.length > 0) {
							var last = params[params.length-1];
							switch (last.expr) {
								case EConst(CIdent("$")):
									params.pop();
									params.unshift(c);
									var res = macro @:pos(e.pos) scuts.ht.core.Ht.resolve($a{params});
									e.expr = res.expr;
								case _:
							}
						}
					} else {
						params.unshift(c);
						var res = macro @:pos(e.pos) scuts.ht.core.Ht.resolveIfTypeable($a{params});
						e.expr = res.expr;
					}
				}
				case _ :
					ExprTools.iter(e, iter);


			}

		}
		ExprTools.iter(e, iter);
		return e;
	}
	#end

}