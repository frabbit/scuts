package scuts.ht.instances;

import scuts.ht.classes.Eq;
import scuts.ht.classes.Monad;

import scuts.ht.core.In;

import scuts.ht.core.Of;
import scuts.ht.instances.std.ArrayOf;
import scuts.ht.instances.std.ArrayTOf;
import scuts.ht.instances.std.OptionTOf;
import scuts.ht.instances.std.ValidationOf;
import scuts.ht.instances.std.ValidationTOf;
import scuts.ht.core.OfOf;
import scuts.ds.LazyLists;

import scuts.core.Validations;
import scuts.Assert;
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
  
  /*
   * Monadic Laws
   (return x) >>= f == f x
    m >>= return == m
   (m >>= f) >>= g == m >>= (\x -> f x >>= g) 
  */
   
   //this currently fails because m.pure(3) gets inlined and accesses a private field (m.applicative.pure), 
   //see MonadAbstract and this causes the known inlining problem
  function assertLaws <M>(mon:Monad<M>, eq:Eq<Of<M,Int>>) 
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
  
  @Test
  public function testLawsForInstances () 
  {
    function mkEq <M,X> (f:Of<M,Int>->X, eqX:Eq<X>):Eq<Of<M, Int>> return EqBuilder.create(function (a:Of<M,Int>, b:Of<M,Int>) return eqX.eq(f(a), f(b)));
    
    
    Hots.implicit(EqBuilder.create(function (p1:Promise<Int>, p2:Promise<Int>) {
      return (p1.isDone() == p2.isDone()) && p1.valueOption().eq_(p2.valueOption());
    }));
    
    
 
    assertLaws(arrayMonad, mkEq._(function (a:Of<Array<In>, Int>):Array<Int> return a));
    assertLaws(optionMonad, mkEq._(function (a:Of<Option<In>, Int>):Option<Int> return a));
    assertLaws(promiseMonad, mkEq._(function (a:Of<Promise<In>, Int>):Promise<Int> return a));
    
    
    function valUnbox <S>(x:ValidationOf<Int, S>):Validation<Int, S> return x;

    function valUnboxT<S, M> (x:ValidationTOf<M, Int, S>):Of<M, Validation<Int, S>> return x.runT();
    
    function arrayUnbox <X>(x:ArrayOf<X>):Array<X> return x;

    function arrayTUnbox <M>(x:ArrayTOf<M, Int>):Of<M, Array<Int>> return x.runT();
    
    function optionTUnbox <M>(x:OptionTOf<M, Int>):Of<M, Option<Int>> return x.runT();
    
    arrayUnbox.compose;
    
    $type(validationMonad(intSumSemigroup));
    $type(valUnbox);
    var eq = mkEq._(valUnbox);
    var mon = validationMonad(intSumSemigroup);
    $type(mon);
    assertLaws(mon, eq);
    assertLaws(optionTMonad(arrayMonad), mkEq._(arrayUnbox.compose(optionTUnbox)));
    assertLaws(arrayTMonad(arrayMonad), mkEq._(arrayUnbox.compose(arrayTUnbox)));
    assertLaws(validationTMonad(arrayMonad), mkEq._(arrayUnbox.compose(valUnboxT)));
  }
   
}