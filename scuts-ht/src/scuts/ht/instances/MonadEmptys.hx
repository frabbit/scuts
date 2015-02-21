
package scuts.ht.instances;

import scuts.ht.classes.MonadEmpty;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.ds.ImLists;
import scuts.ds.LazyLists;

import scuts.ht.instances.Monads.*;
import scuts.ht.instances.Emptys.*;



typedef MB = scuts.ht.syntax.MonadEmptyBuilder;



class MonadEmptys {
  @:implicit @:noUsing public static var arrayMonadEmpty         (default, null):MonadEmpty<Array<_>> = MB.createFromMonadAndEmpty(arrayMonad, arrayEmpty);
  @:implicit @:noUsing public static var promiseMonadEmpty         (default, null):MonadEmpty<PromiseD<_>> = MB.createFromMonadAndEmpty(promiseMonad, promiseEmpty);
  @:implicit @:noUsing public static var lazyListMonadEmpty         (default, null):MonadEmpty<LazyList<_>> = MB.createFromMonadAndEmpty(lazyListMonad, lazyListEmpty);
  @:implicit @:noUsing public static var imListMonadEmpty         (default, null):MonadEmpty<ImList<_>> = MB.createFromMonadAndEmpty(imListMonad, imListEmpty);
  @:implicit @:noUsing public static var optionMonadEmpty         (default, null):MonadEmpty<Option<_>> = MB.createFromMonadAndEmpty(optionMonad, optionEmpty);
}