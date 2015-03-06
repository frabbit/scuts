
package scuts.macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;

class ImplicitSupportImpl {

	public static function apply ():Array<Field>
	{
		var allFields = Context.getBuildFields();

		allFields.map(convertField);

		return allFields;


	}

	static function convertField (x:Field) {

		return switch (x.kind) {
			case FieldType.FFun(f):
				f.expr = convertExpr(f.expr);
				//trace(ExprTools.toString(f.expr));
				x;
			case _: x;
		}

	}

	static function convertExpr (e:Expr) {

		return switch (e.expr) {
			case EConst(CIdent(s)) if (s != "$type" && s.charAt(0) == "$" && s.length > 1):
				var e = macro $i{s.substr(1)};
				macro scuts.ht.core.Ht.implicit($e);



			case ECall({expr:EField(e1, n)}, params) if (n == "_"):

				var args = [convertExpr(e1)].concat(params.map(convertExpr));
				macro scuts.ht.core.Ht.resolve($a{args});

			case ECall(e1 = {expr:EField(e2, "bind")}, params):

				var newParams = params.filter(function (e) return switch (e.expr) {
					case EConst(CIdent("__")): false;
					case _ : true;
				});
				if (newParams.length != params.length) {
					var args = [convertExpr(e2)].concat(newParams.map(convertExpr));
					macro scuts.ht.core.Ht.resolve($a{args});
				} else {
					ExprTools.map(e, convertExpr);
				}
			case ECall(e1, params):
				var newParams = params.filter(function (e) return switch (e.expr) {
					case EConst(CIdent("_")): false;
					case _ : true;
				});
				if (newParams.length != params.length) {
					var args = [convertExpr(e1)].concat(newParams.map(convertExpr));
					macro scuts.ht.core.Ht.resolve($a{args});
				} else {
					ExprTools.map(e, convertExpr);
				}

			case _:
				ExprTools.map(e, convertExpr);
		}





	}


}