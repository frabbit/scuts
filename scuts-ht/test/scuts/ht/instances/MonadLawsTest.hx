package scuts.ht.instances;

#if !macro

import scuts.ht.classes.Eq;
import scuts.ht.classes.Monad;

import scuts.ht.core.In;


import scuts.ht.instances.std.ArrayT;
import scuts.ht.instances.std.OptionT;
import scuts.ht.instances.std.ValidationT;
import scuts.ht.core.OfOf;
import scuts.ds.LazyLists;

import scuts.core.Validations;
import utest.Assert;
import scuts.ht.syntax.EqBuilder;

using scuts.core.Promises;
using scuts.core.Options;

using scuts.ht.Context;

using scuts.core.Functions;

import scuts.ht.instances.Monads.*;
import scuts.ht.instances.Semigroups.*;

class MonadLawsTest
{

  public function new()
  {

  }
  #if !excludeHtTests
  /*
   * Monadic Laws
   (return x) >>= f == f x
    m >>= return == m
   (m >>= f) >>= g == m >>= (\x -> f x >>= g)
  */

   //this currently fails because m.pure(3) gets inlined and accesses a private field (m.applicative.pure),
   //see MonadAbstract and this causes the known inlining problem
  function assertLaws <M>(mon:Monad<M>, eq:Eq<M<Int>>)
  {
    var m = mon.pure(3);
    var f = function (x) return mon.pure(x + 1);
    var g = function (x) return mon.pure(x + 2);

    var x = 3;


    // (return x) >>= f == f x
    Assert.isTrue(eq.eq(f(x),  mon.flatMap._(mon.pure(x), f)));

    //  m >>= return == m
    Assert.isTrue(eq.eq(mon.flatMap._(m, mon.pure),  m));

    // (m >>= f) >>= g == m >>= (\x -> f x >>= g)
    Assert.isTrue(eq.eq(mon.flatMap._(mon.flatMap._(m, f), g), mon.flatMap._(m, function (y) return mon.flatMap._(f(y), g))));


  }


  public function testLawsForInstances ()
  {
    function mkEq <M,X> (f:M<Int>->X, eqX:Eq<X>):Eq<M<Int>> return EqBuilder.create(function (a:M<Int>, b:M<Int>) return eqX.eq(f(a), f(b)));


    Ht.implicit(EqBuilder.create(function (p1:PromiseD<Int>, p2:PromiseD<Int>) {
      return (p1.isComplete() == p2.isComplete()) && p1.valueOption().extract().eq._(p2.valueOption().extract());
    }));



    assertLaws(arrayMonad, mkEq._(function (a:Array<Int>):Array<Int> return a));
    assertLaws(optionMonad, mkEq._(function (a:Option<Int>):Option<Int> return a));
    assertLaws(promiseMonad, mkEq._(function (a:PromiseD<Int>):PromiseD<Int> return a));


    function valUnbox <S>(x:ValidationOf<Int, S>):Validation<Int, S> return x;

    function valUnboxT<S, M> (x:ValidationTOf<M, Int, S>):M<Validation<Int, S>> return x.runT();

    function arrayUnbox <X>(x:ArrayOf<X>):Array<X> return x;

    function arrayTUnbox <M>(x:ArrayTOf<M, Int>):M<Array<Int>> return x.runT();

    function optionTUnbox <M>(x:OptionTOf<M, Int>):M<Option<Int>> return x.runT();

    arrayUnbox.compose;



    var eq = mkEq._(valUnbox);
    var mon = validationMonad(intSumSemigroup);

    assertLaws(mon, eq);
    assertLaws(optionTMonad(arrayMonad), mkEq._(arrayUnbox.compose(optionTUnbox)));
    assertLaws(arrayTMonad(arrayMonad), mkEq._(arrayUnbox.compose(arrayTUnbox)));
    assertLaws(validationTMonad(arrayMonad), mkEq._(arrayUnbox.compose(valUnboxT)));
  }
  #end
}


#end