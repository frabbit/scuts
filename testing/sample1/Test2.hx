


	package ;

	import scuts.ht.Context;
	using StringTools;
	#if macro
	import haxe.macro.Context;
	#end

	class Helper {
		macro public static function test (type:String, def:haxe.macro.Expr):haxe.macro.Expr {

			var ct = macro : String;
			
	    	// String to ComplexType
			var e = Context.parse(" { var e : " + type + " = null; e; } ", Context.currentPos());
	    	var ct = switch (e.expr) {
		      case EBlock([{expr:EVars(v)},_]): v[0].type;
		      case _ : throw "cannot type " + type; null;
		    }
			return macro { var x : $ct = $def; x; };
		}
		
	}



	#if !macro

	class Test2 {

		public static function main () {
			
			scuts.core.Arrays;
			scuts.core.Options;
			scuts.core.Iterables;


			
			
			
			

		}

	}
	#end