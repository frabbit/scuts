
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
  @:implicit @:noUsing public static var promisePure         (default, null):Pure<PromiseD<In>> = new PromisePure();
  @:implicit @:noUsing public static var optionPure          (default, null):Pure<Option<In>> = new OptionPure();
  @:implicit @:noUsing public static var arrayPure           (default, null):Pure<Array<In>> = new ArrayPure();
  @:implicit @:noUsing public static var ioPure           (default, null):Pure<Io<In>> = new IoPure();
  @:implicit @:noUsing public static var lazyListPure        (default, null):Pure<LazyList<In>> = new LazyListPure();
  @:implicit @:noUsing public static var imListPure          (default, null):Pure<ImList<In>> = new ImListPure();
  @:implicit @:noUsing public static var lazyPure          (default, null):Pure<Lazy<In>> = new LazyPure();
  @:implicit @:noUsing public static function validationPure <F>():Pure<Validation<F,In>> return new ValidationPure();

  @:implicit @:noUsing public static function statePure <S>():Pure<State<S,In>> return new StatePure();


  //@:implicit @:noUsing public static function lazyTPure        <M>(base:Pure<M>):Pure<Void->M<In>> return new LazyTPure(base);
  @:implicit @:noUsing public static function promiseTPure        <M>(base:Pure<M>):Pure<PromiseT<M,In>> return new PromiseTPure(base);
  @:implicit @:noUsing public static function arrayTPure        <M>(base:Pure<M>):Pure<ArrayT<M,In>> return new ArrayTPure(base);
  @:implicit @:noUsing public static function optionTPure       <M>(base:Pure<M>):Pure<OptionT<M,In>> return new OptionTPure(base);
  @:implicit @:noUsing public static function validationTPure   <M,F>(base:Pure<M>):Pure<ValidationT<M,F,In>> return new ValidationTPure(base);
}