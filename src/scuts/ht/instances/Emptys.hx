
package scuts.ht.instances;

import scuts.ht.classes.Empty;
import scuts.ht.classes.Monoid;
import scuts.ht.classes.Pure;
import scuts.ht.instances.std.ArrayEmpty;
import scuts.ht.instances.std.ImListEmpty;
import scuts.ht.instances.std.LazyListEmpty;
import scuts.ht.instances.std.OptionEmpty;
import scuts.ht.instances.std.OptionTEmpty;
import scuts.ht.instances.std.PromiseEmpty;
import scuts.ht.instances.std.ValidationEmpty;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.Validations;
import scuts.ds.ImLists;
import scuts.ds.LazyLists;
import scuts.ht.core.In;
import scuts.ht.core.Of;

class Emptys 
{
  @:implicit @:noUsing public static var promiseEmpty         (default, null):Empty<Promise<In>> = new PromiseEmpty();
  @:implicit @:noUsing public static var optionEmpty          (default, null):Empty<Option<In>> = new OptionEmpty();
  @:implicit @:noUsing public static var arrayEmpty           (default, null):Empty<Array<In>> = new ArrayEmpty();
  @:implicit @:noUsing public static var lazyListEmpty        (default, null):Empty<LazyList<In>> = new LazyListEmpty();
  @:implicit @:noUsing public static var imListEmpty          (default, null):Empty<ImList<In>> = new ImListEmpty();
  @:implicit @:noUsing public static function validationEmpty <F>(failureMonoid:Monoid<F>):Empty<Validation<F,In>> return new ValidationEmpty(failureMonoid);
  
  //@:implicit @:noUsing public static function stateEmpty <S>():Empty<S->Tup2<S,In>> return new StateEmpty()
  
  //@:implicit @:noUsing public static function arrayTEmpty        <M>(base:Pure<M>):Empty<Of<M, Array<In>>> return new ArrayTEmpty(base)
  @:implicit @:noUsing public static function optionTEmpty      <M>(base:Pure<M>):Empty<Of<M, Option<In>>> return new OptionTEmpty(base);
  //@:implicit @:noUsing public static function validationTEmpty   <M,F>(base:Pure<M>):Empty<Of<M, Validation<F,In>>> return new ValidationTEmpty(base)
}