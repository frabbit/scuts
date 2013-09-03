
package scuts.reactive;

using scuts.reactive.Streams;

using scuts.core.Promises;


using scuts.core.Functions;

@:allow(scuts.reactive.StreamSubscriptions)
class StreamSubscription<T> {

	var base : Stream<T>;
	var own : Stream<T>;
	var paused : Bool = false;
	var cancelled : Bool;

	public function new (base:Stream<T>, own:Stream<T>) {
		this.base = base;
		this.own = own;
		cancelled = false;
	}

}

private typedef SS<T> = StreamSubscription<T>;

class StreamSubscriptions 
{
	public static function cancel <T>(s:SS<T>):SS<T> 
	{
		if (!s.cancelled) 
		{
			s.paused = false;
			s.base.removeListener(s.own);
		}
		return s;
	}

	public static function pause <T>(s:SS<T>):SS<T>
	{
		if (!s.cancelled && !s.paused) 
		{
			s.paused = true;
			s.base.removeListener(s.own);
		}
		return s;
	}

	public static function pauseUntil <T>(s:SS<T>, p:PromiseD<Dynamic>):SS<T>
	{
		if (!s.cancelled) {
			pause(s);
			p.onComplete(resume.bind(s).promote());
		}
		return s;
	}

	public static function resume <T>(s:SS<T>):SS<T>
	{
		if (!s.cancelled && s.paused)
		{
			s.paused = false;
			s.base.attachListener(s.own);
		}
		return s;	
	}
}