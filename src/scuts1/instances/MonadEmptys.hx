
package scuts1.instances;

import scuts1.classes.MonadEmpty;
import scuts.core.Option;
import scuts.core.Promise;
import scuts.ds.ImList;
import scuts.ds.LazyList;
import scuts1.core.In;

import scuts1.instances.Monads.*;
import scuts1.instances.Emptys.*;



typedef ME = scuts1.syntax.MonadEmptys;



class MonadEmptys {
  @:implicit @:noUsing public static var arrayMonadEmpty         (default, null):MonadEmpty<Array<In>> = ME.createFromMonadAndEmpty(arrayMonad, arrayEmpty);
  @:implicit @:noUsing public static var promiseMonadEmpty         (default, null):MonadEmpty<Promise<In>> = ME.createFromMonadAndEmpty(promiseMonad, promiseEmpty);
  @:implicit @:noUsing public static var lazyListMonadEmpty         (default, null):MonadEmpty<LazyList<In>> = ME.createFromMonadAndEmpty(lazyListMonad, lazyListEmpty);
  @:implicit @:noUsing public static var imListMonadEmpty         (default, null):MonadEmpty<ImList<In>> = ME.createFromMonadAndEmpty(imListMonad, imListEmpty);
  @:implicit @:noUsing public static var optionMonadEmpty         (default, null):MonadEmpty<Option<In>> = ME.createFromMonadAndEmpty(optionMonad, optionEmpty);
}