
package scuts.ht.instances;




import scuts.core.Ios;
import scuts.ht.classes.Bind;
import scuts.ht.classes.Monad;
import scuts.ht.core.In;

import scuts.ht.instances.std.*;
import scuts.core.Conts;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.Tuples;
import scuts.core.Validations;

import scuts.ht.instances.std.IoBind;
import scuts.ht.syntax.Shows;

import scuts.ht.core.Of;
import scuts.ds.ImLists;
import scuts.ds.LazyLists;


class Binds {
  @:implicit @:noUsing public static function contBind            <R>():Bind<Cont<In,R>> return new ContBind();
  @:implicit @:noUsing public static var promiseBind         (default, null):Bind<PromiseD<In>> = new PromiseBind();
  @:implicit @:noUsing public static var optionBind          (default, null):Bind<Option<In>> = new OptionBind();
  @:implicit @:noUsing public static var arrayBind           (default, null):Bind<Array<In>> = new ArrayBind();
  @:implicit @:noUsing public static var ioBind           (default, null):Bind<Io<In>> = new IoBind();
  @:implicit @:noUsing public static var lazyListBind        (default, null):Bind<LazyList<In>> = new LazyListBind();
  @:implicit @:noUsing public static var imListBind          (default, null):Bind<ImList<In>> = new ImListBind();
  @:implicit @:noUsing public static function validationBind <F>():Bind<Validation<F,In>> return new ValidationBind();
  
  @:implicit @:noUsing public static function stateBind <S>():Bind<S->Tup2<S,In>> return new StateBind();
  

  @:implicit @:noUsing public static function promiseTBind        <M>(base:Monad<M>):Bind<Of<M, PromiseD<In>>> return new PromiseTBind(base);
  @:implicit @:noUsing public static function arrayTBind        <M>(base:Monad<M>):Bind<Of<M, Array<In>>> return new ArrayTBind(base);
  @:implicit @:noUsing public static function optionTBind       <M>(base:Monad<M>):Bind<Of<M, Option<In>>> return new OptionTBind(base);
  @:implicit @:noUsing public static function validationTBind   <M,F>(base:Monad<M>):Bind<Of<M, Validation<F,In>>> return new ValidationTBind(base);
}