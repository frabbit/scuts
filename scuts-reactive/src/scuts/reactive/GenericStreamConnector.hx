
package scuts.reactive;

import scuts.reactive.Subscriptions.Subscription;

import scuts.reactive.Streams;

private typedef GenericStreamConnectorData<T, X:Subscription> = {
	source : StreamSource<T>, 
	subscription:X
}

abstract GenericStreamConnector<T, X:Subscription>(GenericStreamConnectorData<T, X>) 
{
	public inline function new (d:GenericStreamConnectorData<T, X>) this = d;

	@:to function toStreamSource ():StreamSource<T> return this.source;
	@:to function toStream ():Stream<T> return this.source;

	public var subscription(get, never):X;
	inline function get_subscription () return this.subscription;


	

}