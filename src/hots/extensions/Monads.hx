package hots.extensions;


import hots.classes.MonadZero;

import hots.Of;
import scuts.core.extensions.Arrays;
import hots.classes.Monad;

typedef MonadExtApplicativeExt = hots.extensions.Applicatives;

class Monads 
{
  public static inline function flatMap <M,A,B> (x:Of<M, A>, f:A->Of<M, B>, m:Monad<M>):Of<M,B> return m.flatMap(x, f)
  
  public static inline function flatten <M,A> (x:Of<M, Of<M,A>>, m:Monad<M>):Of<M,A> return m.flatten(x)
  
  
  // Some Helper functions for working with monads
  
  public static function lift2 <M, A1, A2, R>(f:A1->A2->R, m:Monad<M>):Of<M, A1>->Of<M, A2>->Of<M, R>
  {
    return function (v1:Of<M, A1>, v2:Of<M, A2>) {
      return m.flatMap(v1, function (x1) 
        return m.flatMap(v2, function (x2) 
          return m.pure(f(x1,x2))
        )
      );
    }
  }
  
  public static function ap<M,A,B>(f:Of<M, A->B>, m:Monad<M>):Of<M, A>->Of<M,B> 
  {
    return function (v:Of<M,A>) {
      return m.flatMap(f, function (f1:A->B) 
        return m.map(v,function (a2:A) return f1(a2))
      );
    }
  }
  
  public static function sequence <M,B>(arr:Array<Of<M, B>>, m:Monad<M>):Of<M,Array<B>>
  {
    var k = function (m1:Of<M,B>,m2:Of<M,Array<B>>) {
      return m.flatMap(m1, function (x:B) 
         return m.flatMap(m2, function (xs:Array<B>) 
          return m.pure([x].concat(xs))
          )
      );
    }
    return Arrays.foldRight(arr, m.pure([]), k);
  }
  
  public static inline function mapM <M,A,B>(a:Array<A>, f:A->Of<M,B>, m:Monad<M>):Of<M,Array<B>>
  {
    return sequence(Arrays.map(a,f), m);
  }
}