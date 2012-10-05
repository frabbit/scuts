package hots.instances;
import hots.box.ArrayBox;
import hots.box.OptionBox;
import hots.box.PromiseBox;
import hots.box.ValidationBox;
import hots.classes.Eq;
import hots.classes.Monad;
import hots.extensions.Eqs;
import hots.extensions.Semigroups;
import hots.Hots;
import hots.In;

import hots.Of;
import hots.of.ValidationOf;
import hots.of.ValidationTOf;
import hots.OfOf;
import scuts.core.extensions.LazyLists;
import scuts.core.types.Promise;
import scuts.core.types.Validation;
import utest.Assert;

using hots.Identity;
using hots.ImplicitCasts;
using hots.ImplicitInstances;
using hots.Hots;
using scuts.core.extensions.Functions;

import hots.ImplicitInstances.InstMonad.*;
import hots.ImplicitInstances.InstSemigroup.*;

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
  
  public function testLawsForInstances () 
  {
    function mkEq <M,X> (f:Of<M,Int>->X, eqX:Eq<X>) return Eqs.create(function (a:Of<M,Int>, b:Of<M,Int>) return eqX.eq(f(a), f(b)));
    
    
    Hots.implicit(Eqs.create._(function (p1:Promise<Int>, p2:Promise<Int>) {
      return (p1.isDone() == p2.isDone()) && p1.valueOption().eq(p2.valueOption());
    }));
    
    
 
    assertLaws(arrayMonad, mkEq._(ArrayBox.unbox));
    assertLaws(optionMonad, mkEq._(OptionBox.unbox));
    assertLaws(promiseMonad, mkEq._(PromiseBox.unbox));
    
    
    function valUnbox<X> (x:ValidationOf<Int, X>):Validation<Int, X> return ValidationBox.unbox(x);
    function valUnboxT<X, M> (x:ValidationTOf<M, Int, X>):Of<M, Validation<Int, X>> return ValidationBox.unboxT(x);
    

    
    assertLaws(validationMonad(intSumSemigroup), mkEq._(valUnbox));
    assertLaws(optionTMonad(arrayMonad), mkEq._(ArrayBox.unbox.compose(OptionBox.unboxT)));
    assertLaws(arrayTMonad(arrayMonad), mkEq._(ArrayBox.unbox.compose(ArrayBox.unboxT)));
    assertLaws(validationTMonad(arrayMonad), mkEq._(ArrayBox.unbox.compose(valUnboxT)));
  }
   
}