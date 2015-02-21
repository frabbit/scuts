
package scuts.ht.instances;


import scuts.ht.classes.Arrow;
import scuts.ht.classes.Monad;
import scuts.ht.instances.std.Function;
import scuts.ht.instances.std.Kleisli;
import scuts.ht.instances.std.FunctionArrow;
import scuts.ht.instances.std.KleisliArrow;

import scuts.ht.instances.Categorys.*;

class Arrows
{
  @:implicit @:noUsing public static var functionArrow          (default, null):Arrow<Function<_,_>> = new FunctionArrow(functionCategory);

  @:implicit @:noUsing public static function kleisliArrow      <M>(m:Monad<M>):Arrow<Kleisli<M,_,_>> return new KleisliArrow(m, kleisliCategory(m));
}