package scuts1.instances.std;
import scuts1.box.ArrayBox;
import scuts1.box.OptionBox;
import scuts1.box.PromiseBox;
import scuts1.box.ValidationBox;
import scuts1.classes.Eq;
import scuts1.classes.Monad;
import scuts1.syntax.Eqs;
import scuts1.syntax.Semigroups;
import scuts1.core.Hots;
import scuts1.core.In;

import scuts1.core.Of;
import scuts1.instances.std.ValidationOf;
import scuts1.instances.std.ValidationTOf;
import scuts1.core.OfOf;
import scuts.core.LazyLists;
import scuts.core.Promise;
import scuts.core.Validation;
import utest.Assert;

using scuts1.Identity;
using scuts1.ImplicitCasts;
using scuts1.ImplicitInstances;
using scuts1.core.Hots;
using scuts.core.Functions;

import scuts1.ImplicitInstances.InstMonad.*;
import scuts1.ImplicitInstances.InstSemigroup.*;

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