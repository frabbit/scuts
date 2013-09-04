
package scuts.reactive.transform;

import scuts.core.Tuples;
import scuts.core.Tuples.*;

using scuts.reactive.Streams;

using scuts.reactive.StreamSources;

using scuts.core.Functions;



class CallbackToStream {}


class CallbackToStream3Void
{
  public static function callbackToStreamWith <A,B,C,E>(f:(A->B->C->Void)->Void, m : A->B->C->E):Stream<E>
  {

    return CallbackToStream3.callbackToStreamWith(f,m).stream;
  }

  public static function callbackToStream <A,B,C,D>(f:(A->B->C->Void)->D):Stream<Tup3<A,B,C>>
  {
    return callbackToStreamWith(f, tup3);
  }
}

class CallbackToStream3
{
  public static function callbackToStreamWith <A,B,C,D,E>(f:(A->B->C->Void)->D, m : A->B->C->E):{ stream: Stream<E>, result:D }
  {
    var streamSource = StreamSources.create();
    var res = f(function (a,b,c) {
    	streamSource.send(m(a,b,c));
    });
    return { stream : streamSource.stream, result : res };
  }

  public static function callbackToStream <A,B,C,D>(f:(A->B->C->Void)->D):{ stream: Stream<Tup3<A,B,C>>, result:D }
  {
    return callbackToStreamWith(f, tup3);
  }
}

class CallbackToStream2Void
{
  public static function callbackToStreamWith <A,B,E>(f:(A->B->Void)->Void, m : A->B->E):Stream<E>
  {
    return CallbackToStream2.callbackToStreamWith(f,m).stream;
  }

  public static function callbackToStream <A,B,D>(f:(A->B->Void)->D):Stream<Tup2<A,B>>
  {
    return callbackToStreamWith(f, tup2);
  }
}

class CallbackToStream2
{
  public static function callbackToStreamWith <A,B,D,E>(f:(A->B->Void)->D, m : A->B->E):{ stream: Stream<E>, result:D }
  {
    var streamSource = StreamSources.create();
    var res = f(function (a,b) {
      streamSource.send(m(a,b));
    });
    return { stream : streamSource.stream, result : res };
  }

  public static function callbackToStream <A,B,D>(f:(A->B->Void)->D):{ stream: Stream<Tup2<A,B>>, result:D }
  {
    return callbackToStreamWith(f, tup2);
  }
}

class CallbackToStream1Void
{
  public static function callbackToStreamWith <A,E>(f:(A->Void)->Void, m : A->E):Stream<E>
  {
    return CallbackToStream1.callbackToStreamWith(f,m).stream;
  }

  public static function callbackToStream <A,D>(f:(A->Void)->D):Stream<A>
  {
    return callbackToStreamWith(f, function (x) return x);
  }
}

class CallbackToStream1
{
  public static function callbackToStreamWith <A,D,E>(f:(A->Void)->D, m : A->E):{ stream: Stream<E>, result:D }
  {
    var streamSource = StreamSources.create();
    var res = f(function (a) {
      streamSource.send(m(a));
    });
    return { stream : streamSource.stream, result : res };
  }

  public static function callbackToStream <A,D>(f:(A->Void)->D):{ stream: Stream<A>, result:D }
  {
    return callbackToStreamWith(f, function (x) return x);
  }
}