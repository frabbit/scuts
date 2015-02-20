package scuts.ht.syntax;


using scuts.ds.LazyLists;
import scuts.ht.classes.MonadEmpty;

import scuts.core.Arrays;
import scuts.ht.classes.Monad;

import scuts.ht.classes.Applicative;
import scuts.ht.classes.Bind;

import scuts.Scuts;




class Monads
{

  //public static inline function flatMap <M,A,B> (x:M<A>, f:A->M<B>, m:Monad<M>):M<B> return m.flatMap(x, f);

  public static inline function flatten <M,A> (x:M<M<A>>, m:Monad<M>):M<A> return m.flatten(x);


  // Some Helper functions for working with monads
  /*
  public static function lift2 <M, A1, A2, R>(f:A1->A2->R, m:Monad<M>):M<A1>->M<A2>->M<R>
  {
    return function (v1:M<A1>, v2:M<A2>)
    {
      return m.flatMap(v1, function (x1)
        return m.flatMap(v2, function (x2)
          return m.pure(f(x1,x2))
        )
      );
    }
  }
  */

  public static function ap<M,A,B>(f:M<A->B>, m:Monad<M>):M<A>->M<B>
  {
    return function (v:M<A>) {
      return m.flatMap(f, function (f1:A->B)
        return m.map(v,function (a2:A) return f1(a2))
      );
    }
  }



  public static function sequence <M,B>(arr:Array<M<B>>, m:Monad<M>):M<Array<B>>
  {
    var k = function (m1:M<B>,m2:M<Array<B>>) {
      return m.flatMap(m1, function (x:B)
         return m.flatMap(m2, function (xs:Array<B>)
          return m.pure([x].concat(xs))
          )
      );
    }
    return Arrays.foldRight(arr, m.pure([]), k);
  }

  public static function sequenceLazy <M,B>(arr:LazyList<M<B>>, m:Monad<M>):M<LazyList<B>>
  {
    var k = function (m1:M<B>,m2:M<LazyList<B>>) {
      return m.flatMap(m1, function (x:B)
         return m.flatMap(m2, function (xs:LazyList<B>)
          return m.pure(LazyLists.mkOne(x).concat(xs))
          )
      );
    }
    return LazyLists.foldRight(arr, m.pure(LazyLists.mkEmpty()), k);
  }

  public static inline function mapM <M,A,B>(a:Array<A>, f:A->M<B>, m:Monad<M>):M<Array<B>>
  {
    return sequence(Arrays.map(a,f), m);
  }

}



