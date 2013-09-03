
package scuts.core;

import utest.Assert;

using scuts.core.Readers;

class ReadersTest {

	public function new () {}

	public function testMap () {
		var r = Readers.reader(function (x:Int) return x+1);

		var r2 = r.map(function (x) return x+1);

		Assert.equals(2, r.run()(1));
		Assert.equals(3, r2.run()(1));


	}

}