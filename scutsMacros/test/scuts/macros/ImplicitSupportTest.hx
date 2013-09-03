
package scuts.macros;

#if !macro

import haxe.ds.Option.Some;
import scuts.ht.syntax.Functors;
import scuts.ht.syntax.Monads;
import scuts.macros.ImplicitSupport;
import utest.Assert;


using scuts.ht.Context;

using scuts.macros.ImplicitSupportTest.Helper;




class Helper {
	private static function test () {
		return "hey";
	}

	public static inline function supi (a:String) {
		return test() + a;
	}

}

class ImplicitSupportTest implements ImplicitSupport {

	public function new () {}

 

	public function test () {
		

		var x = 5;
		var y = "hey";

		scuts.ht.core.Ht.implicit(x);
		scuts.ht.core.Ht.implicit(y);

		function f (a:Int, b:Int) return a+b;


		function f1 (a:Int, b:Int) return Std.string(a+b);


		

		Helper.supi._().supi._();


		var x = Helper.supi._();

		// x.supi2._();


		trace(f1._(1));
		/*
		




		//trace(Functors.map([1], function (a) return a+1, _));

		//$type(Functors.map([1], function (a) return a+1, _));
		//$type(Functors.map.bind([1], function (a) return a+1, __));
		//Functors.map.bind([1],_,__);

		trace(f._(1));

		Assert.equals(f._(1), 1+x);
		*/
	}
	

}

#end