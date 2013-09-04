
package scuts.core.transform;

import scuts.core.Promises;
import scuts.core.Tuples;
import scuts.core.Tuples.*;


using scuts.core.Validations;

using scuts.core.Promises;



using scuts.core.Functions;



class CallbackToPromise {}


class CallbackToPromise3Void
{
  public static function callbackToPromiseWith <A,B,C,E>(f:(A->B->C->Void)->Void, m : A->B->C->Validation<Dynamic, E>):PromiseD<E>
  {
    return CallbackToPromise3.callbackToPromiseWith(f,m).promise;
  }

  public static function callbackToSuccess <A,B,C,D>(f:(A->B->C->Void)->D):PromiseD<Tup3<A,B,C>>
  {
    return callbackToPromiseWith(f, function (a,b,c) return Success(tup3(a,b,c)));
  }
}

class CallbackToPromise3
{
  public static function callbackToPromiseWith <A,B,C,D,E>(f:(A->B->C->Void)->D, m : A->B->C->Validation<Dynamic, E>):{ promise: PromiseD<E>, result:D }
  {
    var p = Promises.deferred();
    var res = f(function (a,b,c) {
    	p.complete(m(a,b,c));
    });
    return { promise : p.promise(), result : res };
  }

  public static function callbackToSuccess <A,B,C,D>(f:(A->B->C->Void)->D):{ promise: PromiseD<Tup3<A,B,C>>, result:D }
  {
    return callbackToPromiseWith(f, function (a,b,c) return Success(tup3(a,b,c)));
  }
}

class CallbackToPromise2Void
{
  public static function callbackToPromiseWith <A,B,E>(f:(A->B->Void)->Void, m : A->B->Validation<Dynamic, E>):PromiseD<E>
  {
    return CallbackToPromise2.callbackToPromiseWith(f,m).promise;
  }

  public static function callbackToSuccess <A,B,D>(f:(A->B->Void)->D):PromiseD<Tup2<A,B>>
  {
    return callbackToPromiseWith(f, function (a,b) return Success(tup2(a,b)));
  }
}

class CallbackToPromise2
{
  public static function callbackToPromiseWith <A,B,D,E>(f:(A->B->Void)->D, m : A->B->Validation<Dynamic, E>):{ promise: PromiseD<E>, result:D }
  {
    var p = Promises.deferred();
    var res = f(function (a,b) {
      p.complete(m(a,b));
    });

    return { promise : p.promise(), result : res };
  }

  public static function callbackToSuccess <A,B,D>(f:(A->B->Void)->D):{ promise: PromiseD<Tup2<A,B>>, result:D }
  {
    return callbackToPromiseWith(f, function (a,b) return Success(tup2(a,b)));
  }
  
}

class CallbackToPromise1Void
{
  public static function callbackToPromiseWith <A,E>(f:(A->Void)->Void, m : A->Validation<Dynamic, E>):PromiseD<E>
  {
    return CallbackToPromise1.callbackToPromiseWith(f,m).promise;
  }

  public static function callbackToSuccess <A,D>(f:(A->Void)->D):PromiseD<A>
  {
    return callbackToPromiseWith(f, Success);
  }
}

class CallbackToPromise1
{
  public static function callbackToPromiseWith <A,D,E>(f:(A->Void)->D, m : A->Validation<Dynamic, E>):{ promise: PromiseD<E>, result:D }
  {
    var p = Promises.deferred();
    var res = f(function (a) {
      p.complete(m(a));
    });
    return { promise : p.promise(), result : res };
  }

  public static function callbackToSuccess <A,D>(f:(A->Void)->D):{ promise: PromiseD<A>, result:D }
  {
    return callbackToPromiseWith(f, Success);
  }
}