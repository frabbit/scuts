
package scuts.reactive;

using scuts.reactive.Subscriptions;



private typedef AddListener<EventType> = String->(EventType->Void)->Void;

private typedef RemoveListener<EventType> = AddListener<EventType>;

class GenericEventSubscription<DispatcherType, EventType> {

	public var dispatcher(default, null):DispatcherType;

	var sub : Subscription;

	var addListener : AddListener<EventType>;
	var removeListener : RemoveListener<EventType>;

	var events:Array<String>;
	var cb:EventType->Void;

	public static function fromEvents <DispatcherType, EventType>(jq:DispatcherType, events:Array<String>, cb:EventType->Void, addListener:AddListener<EventType>, removeListener:RemoveListener<EventType>)
		return new GenericEventSubscription(jq, events, cb, addListener, removeListener);

	public static function fromEvent <DispatcherType, EventType>(jq:DispatcherType, event:String, cb:EventType->Void, addListener:AddListener<EventType>, removeListener:RemoveListener<EventType>) return fromEvents(jq, [event], cb, addListener, removeListener);

	function new (dispatcher:DispatcherType, events:Array<String>, cb:EventType->Void, addListener:AddListener<EventType>, removeListener:RemoveListener<EventType>) 
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