
package scuts.reactive;

using scuts.reactive.Streams;

using scuts.core.Promises;


using scuts.core.Functions;

@:allow(scuts.reactive.StreamSubscriptions)
class StreamSubscription<T> {

	var base : Stream<T>;
	var own : Stream<T>;
	var paused : Bool = false;

	public function new (base:Stream<T>, own:Stream<T>) {
		this.base = base;
		this.own = own;
	}

}

private typedef SS<T> = StreamSubscription<T>;

class StreamSubscriptions 
{
	public static function cancel <T>(s:SS<T>):SS<T> 
	{
		s.base.removeListener(s.own);
		return s;
	}

	public static function pause <T>(s:SS<T>):SS<T>
	{
		if (!s.paused) 
		{
			s.paused = true;
			s.base.removeListener(s.own);
		}
		return s;
	}

	public static function pauseUntil <T>(s:SS<T>, p:PromiseD<Dynamic>):SS<T>
	{
		pause(s);
		p.onComplete(resume.bind(s).promote());
		return s;
	}

	public static function resume <T>(s:SS<T>):SS<T>
	{
		if (s.paused)
		{
			s.paused = false;
			s.base.attachListener(s.own);
		}
		return s;	
	}
}