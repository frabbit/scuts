
package scuts.ht.instances;

import scuts.core.Ios;
import scuts.ht.classes.Monad;
import scuts.ht.classes.Semigroup;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.States;
import scuts.core.Validations;
import scuts.ds.ImLists;
import scuts.ds.LazyLists;

import scuts.ht.instances.Binds.*;
import scuts.ht.instances.Applicatives.*;

import scuts.ht.instances.std.*;


private typedef MB = scuts.ht.syntax.MonadBuilder;



class Monads
{
  @:implicit @:noUsing public static var arrayMonad                (default, null):Monad<Array<In>> = MB.createFromApplicativeAndBind(arrayApplicative, arrayBind);
  @:implicit @:noUsing public static var ioMonad                   (default, null):Monad<Io<In>> = MB.createFromApplicativeAndBind(ioApplicative, ioBind);
  @:implicit @:noUsing public static var optionMonad               (default, null):Monad<Option<In>> = MB.createFromApplicativeAndBind(optionApplicative, optionBind);
  @:implicit @:noUsing public static var promiseMonad              (default, null):Monad<PromiseD<In>> = MB.createFromApplicativeAndBind(promiseApplicative, promiseBind);
  @:implicit @:noUsing public static var lazyListMonad             (default, null):Monad<LazyList<In>> = MB.createFromApplicativeAndBind(lazyListApplicative, lazyListBind);
  @:implicit @:noUsing public static var imListMonad               (default, null):Monad<ImList<In>> = MB.createFromApplicativeAndBind(imListApplicative, imListBind);

  @:implicit @:noUsing public static function stateMonad           <S>():Monad<State<S,In>> return MB.createFromApplicativeAndBind(stateApplicative(), stateBind());

  @:implicit @:noUsing public static function validationMonad  <F>(semiFailure:Semigroup<F>):Monad<Validation<F,In>>
    return MB.createFromApplicativeAndBind(validationApplicative(semiFailure), validationBind());

  @:implicit @:noUsing public static function arrayTMonad      <M>(base:Monad<M>):Monad<ArrayT<M, In>>
    return MB.createFromApplicativeAndBind(arrayTApplicative(base), arrayTBind(base));

  // @:implicit @:noUsing public static function lazyTMonad      <M>(base:Monad<M>):Monad<Void->Of<M,In>>
  //   return MB.createFromApplicativeAndBind(lazyTApplicative(base), lazyTBind(base));

  @:implicit @:noUsing public static function promiseTMonad      <M>(base:Monad<M>):Monad<PromiseT<M, In>>
    return MB.createFromApplicativeAndBind(promiseTApplicative(base), promiseTBind(base));

  @:implicit @:noUsing public static function optionTMonad     <M>(base:Monad<M>):Monad<OptionT<M, In>>
    return MB.createFromApplicativeAndBind(optionTApplicative(base), optionTBind(base));

  @:implicit @:noUsing public static function validationTMonad <M,F>(base:Monad<M>):Monad<ValidationT<M, F, In>>
    return MB.createFromApplicativeAndBind(validationTApplicative(base), validationTBind(base));
}