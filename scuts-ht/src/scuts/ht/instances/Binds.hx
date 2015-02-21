
package scuts.ht.instances;




import scuts.core.Ios;
import scuts.ht.classes.Bind;
import scuts.ht.classes.Monad;

import scuts.ht.instances.std.*;
import scuts.core.Conts;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.Tuples;
import scuts.core.States;
import scuts.core.Validations;

import scuts.ht.instances.std.IoBind;
import scuts.ht.instances.std.ArrayT;
import scuts.ht.instances.std.OptionT;
import scuts.ht.instances.std.PromiseT;
import scuts.ht.instances.std.ValidationT;
import scuts.ht.syntax.Shows;


import scuts.ds.ImLists;
import scuts.ds.LazyLists;



class Binds {
  @:implicit @:noUsing public static function contBind            <R>():Bind<Cont<R,_>> return new ContBind();
  @:implicit @:noUsing public static var promiseBind         (default, null):Bind<PromiseD<_>> = new PromiseBind();
  @:implicit @:noUsing public static var optionBind          (default, null):Bind<Option<_>> = new OptionBind();
  @:implicit @:noUsing public static var arrayBind           (default, null):Bind<Array<_>> = new ArrayBind();
  @:implicit @:noUsing public static var ioBind           (default, null):Bind<Io<_>> = new IoBind();
  @:implicit @:noUsing public static var lazyListBind        (default, null):Bind<LazyList<_>> = new LazyListBind();
  @:implicit @:noUsing public static var imListBind          (default, null):Bind<ImList<_>> = new ImListBind();
  @:implicit @:noUsing public static function validationBind <F>():Bind<Validation<F,_>> return new ValidationBind();

  @:implicit @:noUsing public static function stateBind <S>():Bind<State<S,_>> return new StateBind();


  @:implicit @:noUsing public static function promiseTBind        <M>(base:Monad<M>):Bind<PromiseT<M,_>> return new PromiseTBind(base);
  @:implicit @:noUsing public static function arrayTBind        <M>(base:Monad<M>):Bind<ArrayT<M,_>> return new ArrayTBind(base);
  @:implicit @:noUsing public static function optionTBind       <M>(base:Monad<M>):Bind<OptionT<M,_>> return new OptionTBind(base);
  @:implicit @:noUsing public static function validationTBind   <M,F>(base:Monad<M>):Bind<ValidationT<M,F,_>> return new ValidationTBind(base);
}