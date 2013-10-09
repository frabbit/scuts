
package scuts.core;

import haxe.macro.Context;
import haxe.macro.Expr;


import haxe.Constraints;



class Enums {

	macro public static function extractAsVars (x:ExprOf<EnumValue>, m:ExprOf<EnumValue>, ?force:Bool = false) 
	{
		var args = switch (m.expr) {
			case ECall(_, args): args.filter(function (e) return !e.expr.match(EConst(CIdent("_"))));
			case _ : Context.error("vars must be a match expression constant array with idents", x.pos);
		}

		


		var size = args.length;

		var names = args.map(function (e) return switch (e.expr) { case EConst(CIdent(id)):id; case _ : throw "error";});

		var fields = names.map(function (n) {
			return { field : n, expr : macro $i{n} };
		});

		var objectDecl = { expr : EObjectDecl(fields), pos : x.pos };

		var vars = if (size > 0) {
			
			

			

			names.map(function (x) {
				return {
					name : x,
					type : null,
					expr : macro __zz.$x
				}
			});

		} else {
			throw "assert";
		}

		var first = { 
			name : "__zz", 
			type : null, 
			expr : if (force) macro switch ($x) { case $m : $objectDecl; case _ : throw "error"; } else macro switch ($x) { case $m : $objectDecl; }
		};

		vars.unshift(first);

		var res = { expr : EVars(vars), pos : x.pos };

		trace(haxe.macro.ExprTools.toString(res));
		return res;
	}

}