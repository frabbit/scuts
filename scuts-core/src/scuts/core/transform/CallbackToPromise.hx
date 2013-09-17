
package scuts.core.transform;

import scuts.core.Promises;
import scuts.core.Tuples;
import scuts.core.Tuples.*;


using scuts.core.Validations;

using scuts.core.Promises;

using scuts.core.Options;

using scuts.core.Functions;



class CallbackToPromise {}

abstract PromiseWithResult<A,B,C>({ promise : Promise<A,B>, result : C}) from { promise : Promise<A,B>, result : C} {
  
  public function new (promise:Promise<A,B>, res:C) this = { promise : promise, result : res };

  @:to public function asPromise ():Promise<A,B> return this.promise;
}



class CallbackWithoutOptionals3_1
{
  public static function withoutOptionals <A,B,C,E>(f:(A->B->?C->Void)->Void):(A->B->Option<C>->Void)->Void
  {
    return function (x) {
      f(function (a,b,?c) {
        if (c == null) x(a,b, None) else x(a,b, Some(c)); 
      });
    }
    //return CallbackToPromise3o3.callbackToPromiseWith(f,m);
  }

}


class CallbackToPromise3Void
{
  public static function callbackToPromiseWith <A,B,C,E>(f:(A->B->C->Void)->Void, m : A->B->C->Validation<Dynamic, E>):PromiseD<E>
  {
    return CallbackToPromise3.callbackToPromiseWith(f,m);
  }

  public static function callbackToSuccess <A,B,C,D>(f:(A->B->C->Void)->D):PromiseD<Tup3<A,B,C>>
  {
    return callbackToPromiseWith(f, function (a,b,c) return Success(tup3(a,b,c)));
  }
}

class CallbackToPromise3
{
  public static function callbackToPromiseWith <A,B,C,D,E>(f:(A->B->C->Void)->D, m : A->B->C->Validation<Dynamic, E>):PromiseWithResult<Dynamic, E,D>
  {
    var p = Promises.deferred();
    var res = f(function (a,b,c) {
    	p.complete(m(a,b,c));
    });
    return { promise : p.promise(), result : res };
  }

  public static function callbackToSuccess <A,B,C,D>(f:(A->B->C->Void)->D):PromiseWithResult<Dynamic, Tup3<A,B,C>, D>
  {
    return callbackToPromiseWith(f, function (a,b,c) return Success(tup3(a,b,c)));
  }
}

class CallbackToPromise2Void
{
  public static function callbackToPromiseWith <A,B,E>(f:(A->B->Void)->Void, m : A->B->Validation<Dynamic, E>):PromiseD<E>
  {
    return CallbackToPromise2.callbackToPromiseWith(f,m);
  }

  public static function callbackToSuccess <A,B,D>(f:(A->B->Void)->D):PromiseD<Tup2<A,B>>
  {
    return callbackToPromiseWith(f, function (a,b) return Success(tup2(a,b)));
  }
}

class CallbackToPromise2
{
  public static function callbackToPromiseWith <A,B,D,E>(f:(A->B->Void)->D, m : A->B->Validation<Dynamic, E>):PromiseWithResult<Dynamic, E,D>
  {
    var p = Promises.deferred();
    var res = f(function (a,b) {
      p.complete(m(a,b));
    });

    return { promise : p.promise(), result : res };
  }

  public static function callbackToSuccess <A,B,D>(f:(A->B->Void)->D):PromiseWithResult<Dynamic, Tup2<A,B>,D>
  {
    return callbackToPromiseWith(f, function (a,b) return Success(tup2(a,b)));
  }
  
}

class CallbackToPromise1Void
{
  public static function callbackToPromiseWith <A,E>(f:(A->Void)->Void, m : A->Validation<Dynamic, E>):PromiseD<E>
  {
    return CallbackToPromise1.callbackToPromiseWith(f,m);
  }

  public static function callbackToSuccess <A,D>(f:(A->Void)->D):PromiseD<A>
  {
    return callbackToPromiseWith(f, Success);
  }
}



class CallbackToPromise1
{
  public static function callbackToPromiseWith <A,D,E>(f:(A->Void)->D, m : A->Validation<Dynamic, E>):PromiseWithResult<Dynamic, E,D>
  {
    var p = Promises.deferred();
    var res = f(function (a) {
      p.complete(m(a));
    });
    return { promise : p.promise(), result : res };
  }

  public static function callbackToSuccess <A,D>(f:(A->Void)->D):PromiseWithResult<Dynamic, A, D>
  {
    return callbackToPromiseWith(f, Success);
  }
}