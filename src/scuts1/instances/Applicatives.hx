
package scuts1.instances;

import scuts1.classes.Applicative;
import scuts1.classes.Apply;
import scuts1.classes.Functor;
import scuts1.classes.Pure;
import scuts1.classes.Semigroup;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.States;
import scuts.core.Validations;
import scuts.ds.ImLists;
import scuts.ds.LazyLists;

import scuts1.core.In;
import scuts1.core.Of;


import scuts1.instances.Pures.*;
import scuts1.instances.Functors.*;
import scuts1.instances.Applys.*;

private typedef AB = scuts1.syntax.ApplicativeBuilder;

class Applicatives 
{
  @:implicit @:noUsing public static var arrayApplicative            (default, null):Applicative<Array<In>> = AB.create(arrayPure, arrayApply, arrayFunctor);
  @:implicit @:noUsing public static var promiseApplicative          (default, null):Applicative<Promise<In>> = AB.create(promisePure, promiseApply, promiseFunctor);
  @:implicit @:noUsing public static var optionApplicative           (default, null):Applicative<Option<In>> = AB.create(optionPure, optionApply, optionFunctor);
  @:implicit @:noUsing public static var lazyListApplicative         (default, null):Applicative<LazyList<In>> = AB.create(lazyListPure, lazyListApply, lazyListFunctor);
  @:implicit @:noUsing public static var imListApplicative           (default, null):Applicative<ImList<In>> = AB.create(imListPure, imListApply, imListFunctor);
  
  @:implicit @:noUsing public static function stateApplicative           <S>():Applicative<State<S,In>> 
    return AB.create(statePure(), stateApply(), stateFunctor());
  
  @:implicit @:noUsing public static function validationApplicative <F>(semiFailure:Semigroup<F>):Applicative<Validation<F,In>> 
    return AB.create(validationPure(), validationApply(semiFailure), validationFunctor());

  
  @:implicit @:noUsing public static function arrayTApplicative  <M>(base:Applicative<M>):Applicative<Of<M,Array<In>>>  
    return AB.create(arrayTPure(base), arrayTApply(base, base), arrayTFunctor(base));

  @:implicit @:noUsing public static function promiseTApplicative  <M>(base:Applicative<M>):Applicative<Of<M,Promise<In>>>  
    return AB.create(promiseTPure(base), promiseTApply(base, base), promiseTFunctor(base));
    
  // @:implicit @:noUsing public static function lazyTApplicative  <M>(base:Applicative<M>):Applicative<Void->Of<M,In>>  
  //   return AB.create(lazyTPure(base), lazyTApply(base, base), lazyTFunctor(base));
  

  @:implicit @:noUsing public static function optionTApplicative <M>(base:Applicative<M>):Applicative<Of<M,Option<In>>>
    return AB.create(optionTPure(base), optionTApply(base, base), optionTFunctor(base));
    
    
  @:implicit @:noUsing public static function validationTApplicative <M,F>(base:Applicative<M>):Applicative<Of<M,Validation<F,In>>>
    return AB.create(validationTPure(base), validationTApply(base, base), validationTFunctor(base));
}
