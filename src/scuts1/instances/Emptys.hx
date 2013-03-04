
package scuts1.instances;

import scuts1.classes.Empty;
import scuts1.classes.Monoid;
import scuts1.classes.Pure;
import scuts1.instances.std.ArrayEmpty;
import scuts1.instances.std.ImListEmpty;
import scuts1.instances.std.LazyListEmpty;
import scuts1.instances.std.OptionEmpty;
import scuts1.instances.std.OptionTEmpty;
import scuts1.instances.std.PromiseEmpty;
import scuts1.instances.std.ValidationEmpty;
import scuts.core.Option;
import scuts.core.Promise;
import scuts.core.Validation;
import scuts.ds.ImList;
import scuts.ds.LazyList;
import scuts1.core.In;
import scuts1.core.Of;

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