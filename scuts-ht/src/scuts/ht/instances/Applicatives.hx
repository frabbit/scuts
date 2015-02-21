package scuts.ht.instances;

import scuts.core.Ios;
import scuts.core.Lazy;
import scuts.ht.classes.Applicative;
import scuts.ht.classes.Apply;
import scuts.ht.classes.Functor;
import scuts.ht.classes.Pure;
import scuts.ht.classes.Semigroup;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.States;
import scuts.core.Validations;
import scuts.ds.ImLists;
import scuts.ds.LazyLists;

import scuts.ht.instances.std.*;

import scuts.ht.instances.Pures.*;
import scuts.ht.instances.Functors.*;
import scuts.ht.instances.Applys.*;

private typedef AB = scuts.ht.syntax.ApplicativeBuilder;

class Applicatives
{
  @:implicit @:noUsing public static var arrayApplicative            (default, null):Applicative<Array<_>> = AB.create(arrayPure, arrayApply, arrayFunctor);
  @:implicit @:noUsing public static var ioApplicative            (default, null):Applicative<Io<_>> = AB.create(ioPure, ioApply, ioFunctor);
  @:implicit @:noUsing public static var promiseApplicative          (default, null):Applicative<PromiseD<_>> = AB.create(promisePure, promiseApply, promiseFunctor);
  @:implicit @:noUsing public static var optionApplicative           (default, null):Applicative<Option<_>> = AB.create(optionPure, optionApply, optionFunctor);
  @:implicit @:noUsing public static var lazyListApplicative         (default, null):Applicative<LazyList<_>> = AB.create(lazyListPure, lazyListApply, lazyListFunctor);
  @:implicit @:noUsing public static var imListApplicative           (default, null):Applicative<ImList<_>> = AB.create(imListPure, imListApply, imListFunctor);
  @:implicit @:noUsing public static var lazyApplicative           (default, null):Applicative<Lazy<_>> = AB.create(lazyPure, lazyApply, lazyFunctor);

  @:implicit @:noUsing public static function stateApplicative           <S>():Applicative<State<S,_>>
    return AB.create(statePure(), stateApply(), stateFunctor());

  @:implicit @:noUsing public static function validationApplicative <F>(semiFailure:Semigroup<F>):Applicative<Validation<F,_>>
    return AB.create(validationPure(), validationApply(semiFailure), validationFunctor());


  @:implicit @:noUsing public static function arrayTApplicative  <M>(base:Applicative<M>):Applicative<ArrayT<M,_>>
    return AB.create(arrayTPure(base), arrayTApply(base, base), arrayTFunctor(base));

  @:implicit @:noUsing public static function promiseTApplicative  <M>(base:Applicative<M>):Applicative<PromiseT<M,_>>
    return AB.create(promiseTPure(base), promiseTApply(base, base), promiseTFunctor(base));

  // @:implicit @:noUsing public static function lazyTApplicative  <M>(base:Applicative<M>):Applicative<Void->M<_>>
  //   return AB.create(lazyTPure(base), lazyTApply(base, base), lazyTFunctor(base));


  @:implicit @:noUsing public static function optionTApplicative <M>(base:Applicative<M>):Applicative<OptionT<M,_>>
    return AB.create(optionTPure(base), optionTApply(base, base), optionTFunctor(base));


  @:implicit @:noUsing public static function validationTApplicative <M,F>(base:Applicative<M>):Applicative<ValidationT<M,F,_>>
    return AB.create(validationTPure(base), validationTApply(base, base), validationTFunctor(base));
}
