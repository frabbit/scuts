
package scuts.ht.samples;

import scuts.ds.ImLists;
import scuts.ds.LazyLists;

using scuts.core.Options;

using scuts.ht.Context;

class FoldableSample {

	public static function main () {
		
		trace([1,2,3].foldLeft_(0, function (acc, cur) return acc + cur));
		trace(ImLists.fromArray([1,2,3]).foldLeft_(0, function (acc, cur) return acc + cur));
		trace(LazyLists.fromArray([1,2,3]).foldLeft_(0, function (acc, cur) return acc + cur));



		// or define a abstract function that uses a foldable and a semigroup to fold
		// over abstract collections/container and sums the elements up.

		function sum <M, A>(x:Of<M, A>, init:A, f:Foldable<M>, m:Semigroup<A>) {
			return f.foldLeft(x, init, m.append); 
		}

		// same call for all collections
		trace(sum._(LazyLists.fromArray([2,2,3]), 0));
		trace(sum._([2,2,3], 0));
		trace(sum._(ImLists.fromArray([2,2,3]), 0));

		// concat strings?

		trace(sum._(["a", "b", "c"], ""));

		// Options ?

		trace(sum._([Some(1), Some(2), Some(3)], Some(0)));


	}

}