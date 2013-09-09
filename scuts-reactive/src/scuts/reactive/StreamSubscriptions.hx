
package scuts.reactive;

using scuts.reactive.Subscriptions;

using scuts.reactive.Streams;

using scuts.core.Promises;


using scuts.core.Functions;

@:allow(scuts.reactive.StreamSubscriptions)
class StreamSubscription<T> {

	var base : Stream<T>;
	var own : Stream<T>;
	
	var subscription:Subscription;

	public function new (base:Stream<T>, own:Stream<T>) {
		this.base = base;
		this.own = own;


		function connect1 () {
			base.attachListener(own);
		}
		function release1 () {
			base.removeListener(own);
		}

		subscription = Subscriptions.create(connect1, release1);
	}

	public function connect () {
		subscription.connect();
		return this;
	}

	public function release () {
		subscription.release();
		return this;
	}

}

