
package scuts.core;


#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end


class Enums {

	/**
		Unapplies (deconstructs) an EnumValue in it's constituent parts. The parts are then combined with zipExpr and returned.
		The caseExpr must be exhaustive, otherwise you will get a compiler error.
		Examples:
			
			* using Enums;

			enum MyEnum {
				M1(d:Date);
				M2(d:Date);
			}
			var d = Date.now();
			var e = M1(d);
			e.unapply(M1(d) | M2(d), d); // returns the date d

			* using Enums;

			enum MyEnum {
				M1(a:Float, s:String);
				M2(s:String, a:Int);
			}
			
			var e = M1(1.1, "foo");
			e.unapply(M1(_, s) | M2(s, _), s); // returns "foo"

			* using Enums;

			enum Tup2<A,B> {
				Tup2(a:A, b:B);
			}
			var e = Tup2(1,"foo");
			e.unapply(Tup2(x,_), x); // returns 1
			e.unapply(Tup2(_,y), y); // returns "foo"
	**/
	macro public static function unapply (x:ExprOf<EnumValue>, caseExpr:Expr, ?zipExpr:Expr)
	{
		switch (caseExpr.expr) {
			case EBinop(OpArrow, e1,e2):
				zipExpr = e2;
				caseExpr = e1;
			case _ : 
		}
		return macro @:pos(x.pos) switch ($x) {
			case $caseExpr : $zipExpr;
		}
	}


	/**
		Unapplies (deconstructs) an EnumValue in it's constituent parts. The parts are then combined with zipExpr and wrapped
		in an Option. This is useful if the match is only partial (not exhaustive).

		Examples:
			
			* using Enums;

			enum MyEnum {
				M1(d:String);
				M2(t:Int);
			}
			
			M1("foo").unapplyOption(M1(s), s); // returns Some("foo")
			M2(1).unapplyOption(M1(s), s); // returns None

	**/
	macro public static function unapplyOption (x:ExprOf<EnumValue>, caseExpr:Expr, zipExpr:Expr, ?guard:Expr) 
	{
		return if (guard == null) {
			macro @:pos(x.pos) switch ($x) {
				case $caseExpr : haxe.ds.Option.Some($zipExpr);
				case _ : haxe.ds.Option.None;
			}
		} else {
			macro @:pos(x.pos) switch ($x) {
				case $caseExpr if ($guard): haxe.ds.Option.Some($zipExpr);
				case _ : haxe.ds.Option.None;
			}
		}
		
	}

	
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