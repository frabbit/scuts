
package scuts.ht.instances;

import scuts.core.Ios;
import scuts.core.Lazy;
import scuts.core.States;
import scuts.ht.classes.Apply;
import scuts.ht.classes.Functor;
import scuts.ht.classes.Semigroup;
import scuts.ht.instances.std.ArrayApply;
import scuts.ht.instances.std.ArrayTApply;
import scuts.ht.instances.std.ImListApply;
import scuts.ht.instances.std.IoApply;
import scuts.ht.instances.std.LazyApply;
import scuts.ht.instances.std.LazyListApply;
import scuts.ht.instances.std.OptionApply;
import scuts.ht.instances.std.OptionTApply;
import scuts.ht.instances.std.PromiseApply;
import scuts.ht.instances.std.PromiseTApply;
import scuts.ht.instances.std.StateApply;
import scuts.ht.instances.std.ValidationApply;
import scuts.ht.instances.std.ValidationTApply;
import scuts.core.Conts;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.Tuples;
import scuts.core.Validations;
import scuts.ds.ImLists;
import scuts.ds.LazyLists;

import scuts.ht.instances.std.LazyT;

import scuts.ht.instances.std.PromiseT;
import scuts.ht.instances.std.ArrayT;
import scuts.ht.instances.std.OptionT;
import scuts.ht.instances.std.ValidationT;

import scuts.ht.instances.Binds.*;
import scuts.ht.instances.Functors.*;

private typedef A = scuts.ht.syntax.ApplyBuilder;

class Applys {
  @:implicit @:noUsing public static var promiseApply         (default, null):Apply<PromiseD<In>> = new PromiseApply(promiseFunctor);
  @:implicit @:noUsing public static var optionApply          (default, null):Apply<Option<In>> = new OptionApply(optionFunctor);
  @:implicit @:noUsing public static var arrayApply           (default, null):Apply<Array<In>> = new ArrayApply(arrayFunctor);
  @:implicit @:noUsing public static var ioApply           (default, null):Apply<Io<In>> = new IoApply(ioFunctor);
  @:implicit @:noUsing public static var lazyListApply        (default, null):Apply<LazyList<In>> = new LazyListApply(lazyListFunctor);
  @:implicit @:noUsing public static var imListApply          (default, null):Apply<ImList<In>> = new ImListApply(imListFunctor);
  @:implicit @:noUsing public static var lazyApply          (default, null):Apply<Lazy<In>> = new LazyApply(lazyFunctor);

  @:implicit @:noUsing public static function contApply            <R>():Apply<Cont<R,In>> return A.createFromFunctorAndBind(contFunctor(), contBind());

  @:implicit @:noUsing public static function validationApply <F>(failureSemi:Semigroup<F>):Apply<Validation<F,In>> return new ValidationApply(failureSemi, validationFunctor());

  @:implicit @:noUsing public static function stateApply <S>():Apply<State<S, In>> return new StateApply(stateFunctor());

  @:implicit @:noUsing public static function promiseTApply        <M>(appM:Apply<M>, funcM:Functor<M>):Apply<PromiseT<M,In>> return new PromiseTApply(appM, funcM, promiseTFunctor(funcM));
  @:implicit @:noUsing public static function arrayTApply        <M>(appM:Apply<M>, funcM:Functor<M>):Apply<ArrayT<M,In>> return new ArrayTApply(appM, funcM, arrayTFunctor(funcM));
  @:implicit @:noUsing public static function optionTApply       <M>(appM:Apply<M>, funcM:Functor<M>):Apply<OptionT<M,In>> return new OptionTApply(appM, funcM, optionTFunctor(funcM));
  @:implicit @:noUsing public static function validationTApply   <M,F>(funcM:Functor<M>, appM:Apply<M>):Apply<ValidationT<M,F, In>> return new ValidationTApply(funcM, appM, validationTFunctor(funcM));
}