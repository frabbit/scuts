
package scuts.core;

import utest.Assert;

using scuts.core.Tuples;

import scuts.core.Tuples.*;

using scuts.core.Writers;

class WritersTest {

	public function new () {}

	public function testMap () {
		var w = Writers.writer(function (x:Int) return tup2(1, x+1));


		var w2 = w.map(function (x) return x+1);

		Assert.equals(tup2(1,2), w.run()(1));
		Assert.equals(tup2(1,3), w2.run()(1));


	}

}