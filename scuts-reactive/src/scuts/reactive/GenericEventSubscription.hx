
package scuts.reactive;

using scuts.reactive.Subscriptions;


import haxe.Constraints.Function;


private typedef AddListener<Callback:Function> = String->Callback->Void;

private typedef RemoveListener<Callback:Function> = AddListener<Callback>;

class GenericEventSubscription<DispatcherType, Callback:Function> {

	public var dispatcher(default, null):DispatcherType;

	var sub : Subscription;

	var addListener : AddListener<Callback>;
	var removeListener : RemoveListener<Callback>;

	var events:Array<String>;
	var cb:Callback;

	public static function fromEvents <DispatcherType, Callback:Function>(jq:DispatcherType, events:Array<String>, cb:Callback, addListener:AddListener<Callback>, removeListener:RemoveListener<Callback>)
		return new GenericEventSubscription(jq, events, cb, addListener, removeListener);

	public static function fromEvent <DispatcherType, Callback:Function>(jq:DispatcherType, event:String, cb:Callback, addListener:AddListener<Callback>, removeListener:RemoveListener<Callback>) return fromEvents(jq, [event], cb, addListener, removeListener);

	function new (dispatcher:DispatcherType, events:Array<String>, cb:Callback, addListener:AddListener<Callback>, removeListener:RemoveListener<Callback>) 
	{
		this.dispatcher = dispatcher;
		this.events = events;
		this.cb = cb;


		function conn() {
			for (e in events) 
				addListener(e, cb);
		}
		function rel () {
			for (e in events) 
				removeListener(e, cb);
		}
		sub = Subscriptions.create(conn, rel);
	}

	public function connect () 
	{
		sub.connect();
		return this;
	}

	public function release () 
	{
		sub.release();
		return this;
	}
}