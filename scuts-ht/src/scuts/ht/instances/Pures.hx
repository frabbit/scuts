
package scuts.ht.instances;

import scuts.core.Ios;
import scuts.core.Lazy;
import scuts.core.States;
import scuts.ht.classes.Pure;
import scuts.ht.instances.std.ArrayPure;
import scuts.ht.instances.std.ArrayTPure;
import scuts.ht.instances.std.ImListPure;
import scuts.ht.instances.std.IoPure;
import scuts.ht.instances.std.LazyListPure;
import scuts.ht.instances.std.LazyPure;
import scuts.ht.instances.std.OptionPure;
import scuts.ht.instances.std.OptionTPure;
import scuts.ht.instances.std.PromisePure;
import scuts.ht.instances.std.PromiseTPure;
import scuts.ht.instances.std.StatePure;
import scuts.ht.instances.std.ValidationPure;
import scuts.ht.instances.std.ValidationTPure;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.Tuples;
import scuts.core.Validations;
import scuts.ds.ImLists;
import scuts.ds.LazyLists;

import scuts.ht.instances.std.ValidationT;
import scuts.ht.instances.std.PromiseT;
import scuts.ht.instances.std.OptionT;
import scuts.ht.instances.std.ArrayT;



class Pures {
  @:implicit @:noUsing public static var promisePure         (default, null):Pure<PromiseD<_>> = new PromisePure();
  @:implicit @:noUsing public static var optionPure          (default, null):Pure<Option<_>> = new OptionPure();
  @:implicit @:noUsing public static var arrayPure           (default, null):Pure<Array<_>> = new ArrayPure();
  @:implicit @:noUsing public static var ioPure           (default, null):Pure<Io<_>> = new IoPure();
  @:implicit @:noUsing public static var lazyListPure        (default, null):Pure<LazyList<_>> = new LazyListPure();
  @:implicit @:noUsing public static var imListPure          (default, null):Pure<ImList<_>> = new ImListPure();
  @:implicit @:noUsing public static var lazyPure          (default, null):Pure<Lazy<_>> = new LazyPure();
  @:implicit @:noUsing public static function validationPure <F>():Pure<Validation<F,_>> return new ValidationPure();

  @:implicit @:noUsing public static function statePure <S>():Pure<State<S,_>> return new StatePure();


  //@:implicit @:noUsing public static function lazyTPure        <M>(base:Pure<M>):Pure<Void->M<_>> return new LazyTPure(base);
  @:implicit @:noUsing public static function promiseTPure        <M>(base:Pure<M>):Pure<PromiseT<M,_>> return new PromiseTPure(base);
  @:implicit @:noUsing public static function arrayTPure        <M>(base:Pure<M>):Pure<ArrayT<M,_>> return new ArrayTPure(base);
  @:implicit @:noUsing public static function optionTPure       <M>(base:Pure<M>):Pure<OptionT<M,_>> return new OptionTPure(base);
  @:implicit @:noUsing public static function validationTPure   <M,F>(base:Pure<M>):Pure<ValidationT<M,F,_>> return new ValidationTPure(base);
}