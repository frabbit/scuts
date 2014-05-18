
package scuts.ht.samples;

using scuts.core.Promises;
using scuts.ht.Context;

class MonadSample {

	public static function main () {



		trace(
			[1,2].flatMap_(function (x) return [x + 1])
		);

		trace(
			[1,2].map_(function (x) return x + 1)
		);

		trace(
			Do.run(
		 		a <= [1,2],
		 		b <= [3,4],
		 		pure(a+b)
			)
		);


		trace(
			Do.run(
				a <= [1,2],
				filter(a > 1),
				b <= [3,4],
				pure(a+b)
			)
		);
			
		trace(
			Do.run(
				a <= [1,2],
				filter(a > 1),
				b <= [3,4],
				filter(b > 3),
				pure(a+b)
			)
		);

		// use runWith to set a named monad instance, in this case monad
		trace(
			Do.runWith(monad,
				a <= [1,2],
				filter(a > 1),
				b <= monad.pure(17),
				filter(b > 3),
				monad.pure(a+b)
			)
		);


		// use Do's as subexpressions
		trace(
			Do.run(
				a <= [1,2],
				filter(a > 1),
				b <= Do.run(
					x <= [1,2],
					y <= [2,3],
					pure(x+y)),
				filter(b > 3),
				pure(a+b)
			)
		);

		
		Do.run(
			a <= Promises.pure(1),
			b <= Promises.pure(2),
			pure(a+b)
		).onComplete(function (x) trace(x));
			
		



	}
	

}
