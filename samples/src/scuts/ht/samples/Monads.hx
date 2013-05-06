
package scuts.ht.samples;

using scuts.core.Promises;
using scuts.ht.Context;

class Monads {

	public static function main () {

		{
			var x = [1,2].flatMap_(function (x) return [x + 1]);
			
			trace(Std.string(x));
		}

		{
			var x = [1,2].map_(function (x) return x + 1);
			trace(Std.string(x));
		}

		{
			var x = Do.run(
		 		a <= [1,2],
		 		b <= [3,4],
		 		pure(a+b)
			);
			trace(Std.string(x));
		}


		{
			var x = Do.run(
				a <= [1,2],
				filter(a > 1),
				b <= [3,4],
				pure(a+b)
			);
			trace(Std.string(x));
		}
			
		{
			var x = Do.run(
				a <= [1,2],
				filter(a > 1),
				b <= [3,4],
				filter(b > 3),
				pure(a+b)
			);
			trace(Std.string(x));
		}

		// use runWith to set a named monad instance, in this case monad
		{
			var x = Do.runWith(monad,
				a <= [1,2],
				filter(a > 1),
				b <= monad.pure(17),
				filter(b > 3),
				monad.pure(a+b)
			);
			trace(Std.string(x));
		}


		// use Do's as subexpressions
		{
			var x = Do.run(
				a <= [1,2],
				filter(a > 1),
				b <= Do.run(
					x <= [1,2],
					y <= [2,3],
					pure(x+y)),
				filter(b > 3),
				pure(a+b)
			);
			
			trace(Std.string(x));
		}

		{
			var x = Do.run(
				a <= Promises.pure(1),
				b <= Promises.pure(2),
				pure(a+b)
			).onComplete(function (x) trace(x));
			
		}



	}
	

}
