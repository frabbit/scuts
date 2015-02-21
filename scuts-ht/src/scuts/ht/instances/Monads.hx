
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
  @:implicit @:noUsing public static var arrayMonad                (default, null):Monad<Array<_>> = MB.createFromApplicativeAndBind(arrayApplicative, arrayBind);
  @:implicit @:noUsing public static var ioMonad                   (default, null):Monad<Io<_>> = MB.createFromApplicativeAndBind(ioApplicative, ioBind);
  @:implicit @:noUsing public static var optionMonad               (default, null):Monad<Option<_>> = MB.createFromApplicativeAndBind(optionApplicative, optionBind);
  @:implicit @:noUsing public static var promiseMonad              (default, null):Monad<PromiseD<_>> = MB.createFromApplicativeAndBind(promiseApplicative, promiseBind);
  @:implicit @:noUsing public static var lazyListMonad             (default, null):Monad<LazyList<_>> = MB.createFromApplicativeAndBind(lazyListApplicative, lazyListBind);
  @:implicit @:noUsing public static var imListMonad               (default, null):Monad<ImList<_>> = MB.createFromApplicativeAndBind(imListApplicative, imListBind);

  @:implicit @:noUsing public static function stateMonad           <S>():Monad<State<S,_>> return MB.createFromApplicativeAndBind(stateApplicative(), stateBind());

  @:implicit @:noUsing public static function validationMonad  <F>(semiFailure:Semigroup<F>):Monad<Validation<F,_>>
    return MB.createFromApplicativeAndBind(validationApplicative(semiFailure), validationBind());

  @:implicit @:noUsing public static function arrayTMonad      <M>(base:Monad<M>):Monad<ArrayT<M, _>>
    return MB.createFromApplicativeAndBind(arrayTApplicative(base), arrayTBind(base));

  // @:implicit @:noUsing public static function lazyTMonad      <M>(base:Monad<M>):Monad<Void->M<_>>
  //   return MB.createFromApplicativeAndBind(lazyTApplicative(base), lazyTBind(base));

  @:implicit @:noUsing public static function promiseTMonad      <M>(base:Monad<M>):Monad<PromiseT<M, _>>
    return MB.createFromApplicativeAndBind(promiseTApplicative(base), promiseTBind(base));

  @:implicit @:noUsing public static function optionTMonad     <M>(base:Monad<M>):Monad<OptionT<M, _>>
    return MB.createFromApplicativeAndBind(optionTApplicative(base), optionTBind(base));

  @:implicit @:noUsing public static function validationTMonad <M,F>(base:Monad<M>):Monad<ValidationT<M, F, _>>
    return MB.createFromApplicativeAndBind(validationTApplicative(base), validationTBind(base));
}