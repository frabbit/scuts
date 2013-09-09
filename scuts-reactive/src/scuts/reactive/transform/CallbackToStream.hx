
package scuts.reactive.transform;

import scuts.core.Tuples;
import scuts.core.Tuples.*;

using scuts.reactive.Streams;

using scuts.reactive.Streams;

using scuts.core.Functions;


abstract StreamWithResult<X, R>({ stream:StreamSource<X>, result: R}) from { stream:StreamSource<X>, result: R} {
  
  public function new (x:{ stream:StreamSource<X>, result: R}) this = x;

  public var result(get, never):R;
  function get_result():R return this.result;


  @:to function toStreamSource () return this.stream;

}


class CallbackToStream {}


class CallbackToStream3Void
{
  public static function callbackToStreamTransformed <A,B,C,E>(f:(A->B->C->Void)->Void, transform : A->B->C->E):StreamSource<E>
  {

    return CallbackToStream3.callbackToStreamTransformed(f,transform);
  }

  public static function callbackToStream <A,B,C,D>(f:(A->B->C->Void)->D):StreamSource<Tup3<A,B,C>>
  {
    return callbackToStreamTransformed(f, tup3);
  }
}

class CallbackToStream3
{
  public static function callbackToStreamTransformed <A,B,C,D,E>(f:(A->B->C->Void)->D, transform : A->B->C->E):StreamWithResult<E,D>
  {
    var streamSource = Streams.source();
    var res = f(function (a,b,c) {
    	streamSource.send(transform(a,b,c));
    });
    return { stream : streamSource, result : res };
  }

  public static function callbackToStream <A,B,C,D>(f:(A->B->C->Void)->D):StreamWithResult<Tup3<A,B,C>,D>
  {
    return callbackToStreamTransformed(f, tup3);
  }
}

class CallbackToStream2Void
{
  public static function callbackToStreamTransformed <A,B,E>(f:(A->B->Void)->Void, transform : A->B->E):StreamSource<E>
  {
    return CallbackToStream2.callbackToStreamTransformed(f,transform);
  }

  public static function callbackToStream <A,B,D>(f:(A->B->Void)->D):StreamSource<Tup2<A,B>>
  {
    return callbackToStreamTransformed(f, tup2);
  }
}

class CallbackToStream2
{
  public static function callbackToStreamTransformed <A,B,D,E>(f:(A->B->Void)->D, transform : A->B->E):StreamWithResult<E,D>
  {
    var streamSource = Streams.source();
    var res = f(function (a,b) {
      streamSource.send(transform(a,b));
    });
    return { stream : streamSource, result : res };
  }

  public static function callbackToStream <A,B,D>(f:(A->B->Void)->D):StreamWithResult<Tup2<A,B>,D>
  {
    return callbackToStreamTransformed(f, tup2);
  }
}

class CallbackToStream1Void
{
  public static function callbackToStreamTransformed <A,E>(f:(A->Void)->Void, transform : A->E):StreamSource<E>
  {
    return CallbackToStream1.callbackToStreamTransformed(f,transform);
  }

  public static function callbackToStream <A,D>(f:(A->Void)->D):StreamSource<A>
  {
    return callbackToStreamTransformed(f, function (x) return x);
  }
}

class CallbackToStream1
{
  public static function callbackToStreamTransformed <A,D,E>(f:(A->Void)->D, transform : A->E):StreamWithResult<E,D>
  {
    var streamSource = Streams.source();
    var res = f(function (a) {
      streamSource.send(transform(a));
    });
    return { stream : streamSource, result : res };
  }

  public static function callbackToStream <A,D>(f:(A->Void)->D):StreamWithResult<A,D>
  {
    return callbackToStreamTransformed(f, function (x) return x);
  }
}