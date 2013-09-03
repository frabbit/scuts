
package scuts.ds;

import scuts.core.Ints;
import scuts.core.Options;

using scuts.ds.ImLists;
using scuts.core.Functions;

using scuts.ht.Context;

class ImListTest {
	public function new () {}

	public function testSpan () {
		var l = ImLists.fromArray([1,2,3,1,2,3]);

		{
			var res = l.span(function (x) return x < 3);

			utest.Assert.same([1,2], res._1.toArray());
			utest.Assert.same([3,1,2,3], res._2.toArray());
		}

		{
			var res = l.span(function (x) return x < 1);	

			utest.Assert.same([], res._1.toArray());
			utest.Assert.same([1,2, 3,1,2,3], res._2.toArray());	
		}

		{
			var res = l.span(function (x) return x < 10);	

			utest.Assert.same([1,2, 3,1,2,3], res._1.toArray());
			utest.Assert.same([], res._2.toArray());	
		}
	}

	public function testGroupBy () {
		var l = ImLists.fromArray([1,2,3,1,1,2,2]);

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

	public function testQuicksort () {
		
		{
			var l = ImLists.fromArray([1,4,3,2]);
			var res = l.quicksort(scuts.ht.instances.Ords.intOrd).toArray();
			utest.Assert.same([1,2,3,4], res);
			
		}

		{
			var l = ImLists.fromArray([4]);
			var res = l.quicksort(scuts.ht.instances.Ords.intOrd).toArray();
			utest.Assert.same([4], res);
			
		}

		{
			var l = ImLists.fromArray([]);
			var res = l.quicksort(scuts.ht.instances.Ords.intOrd).toArray();
			utest.Assert.same([], res);
			
		}

		{
			var l = ImLists.fromArray([4,1]);
			var res = l.quicksort(scuts.ht.instances.Ords.intOrd).toArray();
			utest.Assert.same([1,4], res);
			
		}

	}
	

}