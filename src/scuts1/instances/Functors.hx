
package scuts1.instances;

import scuts1.classes.Functor;
import scuts1.instances.std.ArrayFunctor;
import scuts1.instances.std.ArrayTFunctor;
import scuts1.instances.std.ContFunctor;
import scuts1.instances.std.ImListFunctor;
import scuts1.instances.std.LazyListFunctor;
import scuts1.instances.std.LazyTFunctor;
import scuts1.instances.std.OptionFunctor;
import scuts1.instances.std.OptionTFunctor;
import scuts1.instances.std.PromiseFunctor;
import scuts1.instances.std.PromiseTFunctor;
import scuts1.instances.std.StateFunctor;
import scuts1.instances.std.ValidationFunctor;
import scuts1.instances.std.ValidationTFunctor;
import scuts.core.Cont;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.Tuples;
import scuts.core.Validations;
import scuts.ds.ImLists;
import scuts.ds.LazyLists;

import scuts1.core.In;
import scuts1.core.Of;


class Functors {
  @:implicit @:noUsing public static var optionFunctor          (default, null):Functor<Option<In>> = new OptionFunctor();
  
  @:implicit @:noUsing public static function stateFunctor          <S>():Functor<S->Tup2<S,In>> return new StateFunctor();
  
  @:implicit @:noUsing public static function contFunctor         <R>():Functor<Cont<In,R>> return new ContFunctor();
  @:implicit @:noUsing public static var promiseFunctor          (default, null):Functor<Promise<In>> = new PromiseFunctor();
  @:implicit @:noUsing public static var arrayFunctor           (default, null):Functor<Array<In>> = new ArrayFunctor();
  @:implicit @:noUsing public static var lazyListFunctor           (default, null):Functor<LazyList<In>> = new LazyListFunctor();
  @:implicit @:noUsing public static var imListFunctor           (default, null):Functor<ImList<In>> = new ImListFunctor();
  @:implicit @:noUsing public static function validationFunctor  <F>():Functor<Validation<F,In>> return new ValidationFunctor();
  
  @:implicit @:noUsing public static function lazyTFunctor          <M>(f:Functor<M>):Functor<Of<M, Void->In>> return new LazyTFunctor(f);
  
  @:implicit @:noUsing public static function promiseTFunctor     <M>(base:Functor<M>):Functor<Of<M, Promise<In>>> return new PromiseTFunctor(base);
  @:implicit @:noUsing public static function arrayTFunctor     <M>(base:Functor<M>):Functor<Of<M, Array<In>>> return new ArrayTFunctor(base);
  @:implicit @:noUsing public static function optionTFunctor    <M>(base:Functor<M>):Functor<Of<M, Option<In>>> return new OptionTFunctor(base);
  @:implicit @:noUsing public static function validationTFunctor    <M, F>(base:Functor<M>):Functor<Of<M, Validation<F, In>>> return new ValidationTFunctor(base);
}