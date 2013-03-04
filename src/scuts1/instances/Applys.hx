
package scuts1.instances;

import scuts1.classes.Apply;
import scuts1.classes.Functor;
import scuts1.classes.Semigroup;
import scuts1.instances.std.ArrayApply;
import scuts1.instances.std.ArrayTApply;
import scuts1.instances.std.ImListApply;
import scuts1.instances.std.LazyListApply;
import scuts1.instances.std.OptionApply;
import scuts1.instances.std.OptionTApply;
import scuts1.instances.std.PromiseApply;
import scuts1.instances.std.PromiseTApply;
import scuts1.instances.std.StateApply;
import scuts1.instances.std.ValidationApply;
import scuts1.instances.std.ValidationTApply;
import scuts.core.Cont;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.Tuples;
import scuts.core.Validations;
import scuts.ds.ImLists;
import scuts.ds.LazyLists;

import scuts1.core.In;
import scuts1.core.Of;


import scuts1.instances.Binds.*;
import scuts1.instances.Functors.*;

private typedef A = scuts1.syntax.ApplyBuilder;

class Applys {
  @:implicit @:noUsing public static var promiseApply         (default, null):Apply<Promise<In>> = new PromiseApply();
  @:implicit @:noUsing public static var optionApply          (default, null):Apply<Option<In>> = new OptionApply();
  @:implicit @:noUsing public static var arrayApply           (default, null):Apply<Array<In>> = new ArrayApply();
  @:implicit @:noUsing public static var lazyListApply        (default, null):Apply<LazyList<In>> = new LazyListApply();
  @:implicit @:noUsing public static var imListApply          (default, null):Apply<ImList<In>> = new ImListApply();
  
  @:implicit @:noUsing public static function contApply            <R>():Apply<Cont<In,R>> return A.createFromFunctorAndBind(contFunctor(), contBind());
  
  @:implicit @:noUsing public static function validationApply <F>(failureSemi:Semigroup<F>):Apply<Validation<F,In>> return new ValidationApply(failureSemi);
  
  @:implicit @:noUsing public static function stateApply <S>():Apply<S->Tup2<S,In>> return new StateApply();
  
  @:implicit @:noUsing public static function promiseTApply        <M>(appM:Apply<M>, funcM:Functor<M>):Apply<Of<M, Promise<In>>> return new PromiseTApply(appM, funcM);
  @:implicit @:noUsing public static function arrayTApply        <M>(appM:Apply<M>, funcM:Functor<M>):Apply<Of<M, Array<In>>> return new ArrayTApply(appM, funcM);
  @:implicit @:noUsing public static function optionTApply       <M>(appM:Apply<M>, funcM:Functor<M>):Apply<Of<M, Option<In>>> return new OptionTApply(appM, funcM);
  @:implicit @:noUsing public static function validationTApply   <M,F>(funcM:Functor<M>, appM:Apply<M>):Apply<Of<M, Validation<F,In>>> return new ValidationTApply(funcM, appM);
}