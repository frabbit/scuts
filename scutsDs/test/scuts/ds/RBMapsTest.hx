
package scuts.ds;

import scuts.ht.instances.Eqs;
import scuts.ht.instances.Ords;
import utest.Assert;

using scuts.ds.RBMaps;

class RBMapsTest {

	public function new () {}

	public function testEq () {
		var o = Ords.intOrd;
		var map1 = RBMaps.empty().insert(1, "one", o).insert(2, "two", o).remove(2, o).insert(3, "three", o).insert(0, "zero", o);

		var map2 = RBMaps.empty().insert(1, "one", o).insert(3, "three", o).insert(0, "zero", o);

		

		Assert.isTrue(map1.eq(map2, Eqs.intEq, Eqs.stringEq));
	}

}