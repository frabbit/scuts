
package scuts.ht.instances;

import scuts.ht.classes.Empty;
import scuts.ht.classes.Monoid;
import scuts.ht.classes.Pure;
import scuts.ht.instances.std.*;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.Validations;
import scuts.ds.ImLists;
import scuts.ds.LazyLists;

class Emptys
{
  @:implicit @:noUsing public static var promiseEmpty         (default, null):Empty<PromiseD<_>> = new PromiseEmpty();
  @:implicit @:noUsing public static var optionEmpty          (default, null):Empty<Option<_>> = new OptionEmpty();
  @:implicit @:noUsing public static var arrayEmpty           (default, null):Empty<Array<_>> = new ArrayEmpty();
  @:implicit @:noUsing public static var lazyListEmpty        (default, null):Empty<LazyList<_>> = new LazyListEmpty();
  @:implicit @:noUsing public static var imListEmpty          (default, null):Empty<ImList<_>> = new ImListEmpty();
  @:implicit @:noUsing public static function validationEmpty <F>(failureMonoid:Monoid<F>):Empty<Validation<F,_>> return new ValidationEmpty(failureMonoid);

  //@:implicit @:noUsing public static function stateEmpty <S>():Empty<S->Tup2<S,_>> return new StateEmpty()

  //@:implicit @:noUsing public static function arrayTEmpty        <M>(base:Pure<M>):Empty<M<Array<_>>> return new ArrayTEmpty(base)
  @:implicit @:noUsing public static function optionTEmpty      <M>(base:Pure<M>):Empty<OptionT<M,_>> return new OptionTEmpty(base);
  //@:implicit @:noUsing public static function validationTEmpty   <M,F>(base:Pure<M>):Empty<M<Validation<F,_>>> return new ValidationTEmpty(base)
}