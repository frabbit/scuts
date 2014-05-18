
package scuts.core.transform;

import scuts.core.Promises;
import scuts.core.Tuples;
import scuts.core.Tuples.*;


using scuts.core.Validations;

using scuts.core.Promises;

using scuts.core.Options;

using scuts.core.Functions;



class CallbackToPromise {}

abstract PromiseWithResult<A,B,C>({ promise : PromiseG<A,B>, result : C}) from { promise : PromiseG<A,B>, result : C} {
  
  public function new (promise:PromiseG<A,B>, res:C) this = { promise : promise, result : res };

  @:to public function toPromise ():PromiseG<A,B> return this.promise;
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
    //return CallbackToPromise3o3.toPromiseWithResultBy(f,m);
  }
}


class CallbackToPromise3Void
{
  

  public static function toPromiseBy <A,B,C,E>(f:(A->B->C->Void)->Void, m : A->B->C->Validation<Dynamic, E>):PromiseD<E>
  {
    return toPromiseWithResultBy(f,m);
  }

  public static function toPromise <A,B,C,D>(f:(A->B->C->Void)->Void):PromiseD<Tup3<A,B,C>>
  {
    return toPromiseBy(f, function (a,b,c) return Success(tup3(a,b,c)));
  }
  
  public static function toPromiseWithResultBy <A,B,C,D,E>(f:(A->B->C->Void)->D, m : A->B->C->Validation<Dynamic, E>):PromiseWithResult<Dynamic, E,D>
  {
    var p = Promises.deferred();
    var res = f(function (a,b,c) {
      p.complete(m(a,b,c));
    });
    return { promise : p.promise(), result : res };
  }

  public static function toPromiseWithResult <A,B,C,D>(f:(A->B->C->Void)->D):PromiseWithResult<Dynamic, Tup3<A,B,C>, D>
  {
    return toPromiseWithResultBy(f, function (a,b,c) return Success(tup3(a,b,c)));
  }

}


class CallbackToPromise2
{
  public static function toPromiseBy <A,B,E>(f:(A->B->Void)->Void, m : A->B->Validation<Dynamic, E>):PromiseD<E>
  {
    return toPromiseWithResultBy(f,m);
  }

  public static function toPromise <A,B,D>(f:(A->B->Void)->D):PromiseD<Tup2<A,B>>
  {
    return toPromiseBy(f, function (a,b) return Success(tup2(a,b)));
  }

  public static function toPromiseWithResultBy <A,B,D,E>(f:(A->B->Void)->D, m : A->B->Validation<Dynamic, E>):PromiseWithResult<Dynamic, E,D>
  {
    var p = Promises.deferred();
    var res = f(function (a,b) {
      p.complete(m(a,b));
    });

    return { promise : p.promise(), result : res };
  }

  public static function toPromiseWithResult <A,B,D>(f:(A->B->Void)->D):PromiseWithResult<Dynamic, Tup2<A,B>,D>
  {
    return toPromiseWithResultBy(f, function (a,b) return Success(tup2(a,b)));
  }
}



class CallbackToPromise1
{
  public static function toPromiseBy <A,E>(f:(A->Void)->Void, m : A->Validation<Dynamic, E>):PromiseD<E>
  {
    return toPromiseWithResultBy(f,m);
  }

  public static function toPromise <A,D>(f:(A->Void)->D):PromiseD<A>
  {
    return toPromiseWithResultBy(f, Success);
  }

  public static function toPromiseWithResultBy <A,D,E>(f:(A->Void)->D, m : A->Validation<Dynamic, E>):PromiseWithResult<Dynamic, E,D>
  {
    var p = Promises.deferred();
    var res = f(function (a) {
      p.complete(m(a));
    });
    return { promise : p.promise(), result : res };
  }

  public static function toPromiseWithResult <A,D>(f:(A->Void)->D):PromiseWithResult<Dynamic, A, D>
  {
    return toPromiseWithResultBy(f, Success);
  }
}