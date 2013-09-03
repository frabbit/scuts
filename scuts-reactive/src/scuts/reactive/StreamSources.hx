
package scuts.reactive;

using scuts.reactive.Streams;

class StreamSource<T> {

	public var stream(default, null): Stream<T>;

	public function new (stream:Stream<T>) {
		this.stream = stream;
	}

}


class StreamSources {

	public static function create <T>():StreamSource<T> 
	{
		return new StreamSource(Streams.identity());
	}

	public static function send <T>(s:StreamSource<T>, event:T):StreamSource<T>
	{
		s.stream.send(event);
		return s;
	}

	
	

}