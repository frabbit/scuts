
package iteratee;

import scuts.core.Arrays;
import scuts.ds.LazyLists;
import scuts.ht.syntax.Functors;
import scuts.ht.syntax.Monads;

using scuts.core.Functions;

using iteratee.Iteratees;

using scuts.core.Options;

using scuts.ht.core.Ht;

using scuts.ht.Context;

class IterateesTest {

	static public function main()
	{
		function drop1keep1 <E,A>(): IterV<E,Option<E>>
			return Iteratees.drop(1).flatMap(function (_) return Iteratees.head());

		function alternates <E,A>(): IterV<E,LazyList<E>>
		{
			var z = drop1keep1().toOf();
			var z1 = LazyLists.replicate(5, z);
			var z2 = Monads.sequenceLazy._(z1);
			return Iteratees.map(z2.fromOf(), LazyLists.catOptions);
		}

		var alts = Iteratees.enumerate(alternates(), LazyLists.fromIterator(1...11));
		trace(Iteratees.run(alts).show_());
	}

}