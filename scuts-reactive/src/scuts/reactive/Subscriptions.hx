
package scuts.reactive;

using scuts.core.Promises;
using scuts.core.Functions;
typedef Subscription = {
	function release ():Subscription;
	function connect ():Subscription;
}

class GenericSubscription 
{
	@:isVar public var connected(default, null):Bool;

	var connect1 : Void->Void;
	var release1 : Void->Void;

	public function new (connect1:Void->Void, release1:Void->Void) 
	{
		this.connect1 = connect1;
		this.release1 = release1;
		connected = false;

		this.connect();
	}

	public function connect () 
	{
		if (!connected) {
			connect1();
			connected = true;
		}
		return this;
	}

	public function release () 
	{
		
		if (connected) {
			release1();
			connected = false;
		}
		return this;
	}
}

class Subscriptions 
{

	public static function create (connect:Void->Void, release:Void->Void):Subscription 
	{
		return new GenericSubscription(connect, release);
	}

	public static function pauseUntil (s:Subscription, p:PromiseD<Dynamic>):Subscription
	{
		s.release();
		p.onComplete(s.connect.promote());
		return s;
	}
}