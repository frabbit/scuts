
package scuts.ds;

import scuts.core.Ints;

using scuts.ds.LazyLists;

import scuts.ht.instances.Ords.*;

using scuts.ht.Context;

class LazyListTest {

	public function new () {}

	public function testQuicksort () 
	{
		{
			var l = LazyLists.fromArray([1,4,3,2]);
			var res = l.quicksort(intOrd).toArray();
			utest.Assert.same([1,2,3,4], res);
		}

		{
			var l = LazyLists.fromArray([4]);
			var res = l.quicksort(intOrd).toArray();
			utest.Assert.same([4], res);
		}

		{
			var l = LazyLists.fromArray([]);
			var res = l.quicksort(intOrd).toArray();
			utest.Assert.same([], res);
		}

		{
			var l = LazyLists.fromArray([4,1]);
			var res = l.quicksort(intOrd).toArray();
			utest.Assert.same([1,4], res);
		}

	}

	public function testGroupBy () {
		var l = LazyLists.fromArray([1,2,3,1,1,2,2]);

		{

			var res = l.groupBy(Ints.eq).toArray();

			trace(l.groupBy(Ints.eq).show_());

			utest.Assert.same([1], res[0].toArray());
			utest.Assert.same([2], res[1].toArray());
			utest.Assert.same([3], res[2].toArray());
			utest.Assert.same([1,1], res[3].toArray());
			utest.Assert.same([2,2], res[4].toArray());
			
		}

	}

}