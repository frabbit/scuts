
package scuts.ds;

import scuts.core.Iterables;
import scuts.core.Iterators;
import scuts.ht.instances.Eqs;
import scuts.ht.instances.Ords;
import utest.Assert;

using scuts.ds.RBSets;

class RBSetsTest {

	public function new () {}

	public function testEq () 
	{
		var o = Ords.intOrd;
		var set1 = RBSets.empty().insert(1, o).insert(2, o).remove(2, o).insert(3, o).insert(0, o);

		var set2 = RBSets.empty().insert(1, o).insert(3, o).insert(0, o);

		

		Assert.isTrue(set1.eq(set2, Eqs.intEq));
	}

	public function testUnion () 
	{
		var o = Ords.intOrd;
		var set1 = RBSets.empty().insert(1, o).insert(2, o);

		var set2 = RBSets.empty().insert(3, o).insert(4, o).insert(2, o);


		var union = set1.union(set2, o);

		var set3 = RBSets.empty().insert(1, o).insert(2, o).insert(3, o).insert(4, o);
		

		Assert.isTrue(set3.eq(union, Eqs.intEq));
	}

	public function testIntersection () 
	{
		var o = Ords.intOrd;
		var set1 = RBSets.empty().insert(1, o).insert(2, o);

		var set2 = RBSets.empty().insert(3, o).insert(4, o).insert(2, o);


		var intersect = set1.intersection(set2, o);

		var set3 = RBSets.empty().insert(2, o);
		

		Assert.isTrue(set3.eq(intersect, Eqs.intEq));
	}

	public function testDifference () 
	{
		var o = Ords.intOrd;
		var set1 = RBSets.empty().insert(1, o).insert(2, o);

		var set2 = RBSets.empty().insert(3, o).insert(4, o).insert(2, o);


		var diff = set1.difference(set2, o);

		var set3 = RBSets.empty().insert(1, o);
		
		Assert.isTrue(set3.eq(diff, Eqs.intEq));
	}

	

}