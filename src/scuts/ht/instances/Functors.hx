
package scuts.ht.instances;

import scuts.core.Ios;
import scuts.core.Lazy;
import scuts.ht.classes.Functor;
import scuts.ht.instances.std.ArrayFunctor;
import scuts.ht.instances.std.ArrayTFunctor;
import scuts.ht.instances.std.ContFunctor;
import scuts.ht.instances.std.ImListFunctor;
import scuts.ht.instances.std.IoFunctor;
import scuts.ht.instances.std.LazyFunctor;
import scuts.ht.instances.std.LazyListFunctor;
import scuts.ht.instances.std.LazyTFunctor;
import scuts.ht.instances.std.OptionFunctor;
import scuts.ht.instances.std.OptionTFunctor;
import scuts.ht.instances.std.PromiseFunctor;
import scuts.ht.instances.std.PromiseTFunctor;
import scuts.ht.instances.std.StateFunctor;
import scuts.ht.instances.std.ValidationFunctor;
import scuts.ht.instances.std.ValidationTFunctor;
import scuts.core.Conts;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.Tuples;
import scuts.core.Validations;
import scuts.ds.ImLists;
import scuts.ds.LazyLists;

import scuts.ht.core.In;
import scuts.ht.core.Of;


class Functors {
  @:implicit @:noUsing public static var optionFunctor          (default, null):Functor<Option<In>> = new OptionFunctor();
  @:implicit @:noUsing public static var ioFunctor          (default, null):Functor<Io<In>> = new IoFunctor();
  
  @:implicit @:noUsing public static function stateFunctor          <S>():Functor<S->Tup2<S,In>> return new StateFunctor();
  
  @:implicit @:noUsing public static function contFunctor         <R>():Functor<Cont<In,R>> return new ContFunctor();
  @:implicit @:noUsing public static var promiseFunctor          (default, null):Functor<Promise<In>> = new PromiseFunctor();
  @:implicit @:noUsing public static var arrayFunctor           (default, null):Functor<Array<In>> = new ArrayFunctor();
  @:implicit @:noUsing public static var lazyListFunctor           (default, null):Functor<LazyList<In>> = new LazyListFunctor();
  @:implicit @:noUsing public static var imListFunctor           (default, null):Functor<ImList<In>> = new ImListFunctor();
  @:implicit @:noUsing public static var lazyFunctor           (default, null):Functor<Lazy<In>> = new LazyFunctor();
  @:implicit @:noUsing public static function validationFunctor  <F>():Functor<Validation<F,In>> return new ValidationFunctor();
  
  @:implicit @:noUsing public static function lazyTFunctor          <M>(f:Functor<M>):Functor<Of<M, Void->In>> return new LazyTFunctor(f);
  
  @:implicit @:noUsing public static function promiseTFunctor     <M>(base:Functor<M>):Functor<Of<M, Promise<In>>> return new PromiseTFunctor(base);
  @:implicit @:noUsing public static function arrayTFunctor     <M>(base:Functor<M>):Functor<Of<M, Array<In>>> return new ArrayTFunctor(base);
  @:implicit @:noUsing public static function optionTFunctor    <M>(base:Functor<M>):Functor<Of<M, Option<In>>> return new OptionTFunctor(base);
  @:implicit @:noUsing public static function validationTFunctor    <M, F>(base:Functor<M>):Functor<Of<M, Validation<F, In>>> return new ValidationTFunctor(base);
}