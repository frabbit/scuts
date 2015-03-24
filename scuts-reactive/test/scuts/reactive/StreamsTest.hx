
package scuts.reactive;


import utest.Assert;

using scuts.reactive.Streams;

using scuts.core.Promises;

using scuts.reactive.Streams;
using scuts.reactive.StreamSubscriptions;






class StreamsTest {

	public function new () {}
	public function testSubscription () {

		var x = 0;
		function listener (z) { x = z;}

		var s = StreamSources.create();
		var subscription = s.stream.listen(listener);
		Assert.equals(0, x);
		s.send(1);
		Assert.equals(1, x);

		subscription.pause();

		s.send(3);
		Assert.equals(1, x);

		subscription.resume();
		Assert.equals(1, x);
		s.send(4);
		Assert.equals(4, x);


		var p = Promises.deferred();

		subscription.pauseUntil(p);

		s.send(5);
		Assert.equals(4, x);

		p.success(10);

		s.send(11);

		Assert.equals(11, x);

	}


}