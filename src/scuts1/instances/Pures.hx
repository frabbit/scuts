
package scuts1.instances;

import scuts1.classes.Pure;
import scuts1.instances.std.ArrayPure;
import scuts1.instances.std.ArrayTPure;
import scuts1.instances.std.ImListPure;
import scuts1.instances.std.LazyListPure;
import scuts1.instances.std.OptionPure;
import scuts1.instances.std.OptionTPure;
import scuts1.instances.std.PromisePure;
import scuts1.instances.std.PromiseTPure;
import scuts1.instances.std.StatePure;
import scuts1.instances.std.ValidationPure;
import scuts1.instances.std.ValidationTPure;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.Tuples;
import scuts.core.Validations;
import scuts.ds.ImLists;
import scuts.ds.LazyLists;

import scuts1.core.In;
import scuts1.core.Of;

class Pures {
  @:implicit @:noUsing public static var promisePure         (default, null):Pure<Promise<In>> = new PromisePure();
  @:implicit @:noUsing public static var optionPure          (default, null):Pure<Option<In>> = new OptionPure();
  @:implicit @:noUsing public static var arrayPure           (default, null):Pure<Array<In>> = new ArrayPure();
  @:implicit @:noUsing public static var lazyListPure        (default, null):Pure<LazyList<In>> = new LazyListPure();
  @:implicit @:noUsing public static var imListPure          (default, null):Pure<ImList<In>> = new ImListPure();
  @:implicit @:noUsing public static function validationPure <F>():Pure<Validation<F,In>> return new ValidationPure();
  
  @:implicit @:noUsing public static function statePure <S>():Pure<S->Tup2<S,In>> return new StatePure();
  

  //@:implicit @:noUsing public static function lazyTPure        <M>(base:Pure<M>):Pure<Void->Of<M,In>> return new LazyTPure(base);
  @:implicit @:noUsing public static function promiseTPure        <M>(base:Pure<M>):Pure<Of<M, Promise<In>>> return new PromiseTPure(base);
  @:implicit @:noUsing public static function arrayTPure        <M>(base:Pure<M>):Pure<Of<M, Array<In>>> return new ArrayTPure(base);
  @:implicit @:noUsing public static function optionTPure       <M>(base:Pure<M>):Pure<Of<M, Option<In>>> return new OptionTPure(base);
  @:implicit @:noUsing public static function validationTPure   <M,F>(base:Pure<M>):Pure<Of<M, Validation<F,In>>> return new ValidationTPure(base);
}