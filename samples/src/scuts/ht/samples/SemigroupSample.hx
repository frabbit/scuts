
package scuts.ht.samples;

using scuts.ht.Context;
import scuts.core.Options;
import scuts.core.Eithers;
import scuts.ht.syntax.SemigroupBuilder;

using scuts.core.Validations;
import scuts.core.Tuples.*;

class SemigroupSample {

	public static function main () {
		trace("hi".append_("hey"));
		trace(1.append_(2));
		trace([1].append_([2]));
		trace(["hi"].append_(["hey"]));


		// append on tuples
		trace(tup2("hi", 1).append_(tup2("hey", 5)));
		trace(tup2(["hi"], Some(1)).append_(tup2(["hey"], Some(5))));

		// append on validation
		trace(Success(7).append_(Success(3)));
		trace(Failure(7).append_(Failure(3)));

		trace(Some(Failure(7)).append_(Some(Failure(3))));

		// append on either
		trace(Left(Some(7)).append_(Left(Some(3))).append_(Left(Some(3))));


		// using type class resolution on an arbitrary object with the helper function r_

		trace(1.r_(append, 2));

		trace(Left(1).r_(append, Left(2)));


		// use intProductSemigroup for Int appending

		Ht.implicit(scuts.ht.instances.Semigroups.intProductSemigroup);

		trace(3.append_(2));
		trace(Some(3).append_(Some(2)));

		

		{
			// use your own appending function for ints (locally in this block)
			Ht.implicit(SemigroupBuilder.create(function (a,b) return a * 2 + b));

			trace(3.append_(2));
			trace(Some(3).append_(Some(2)));
		}

		// now intProductSemigroup is in scope again
		trace(3.append_(2));


	}

}