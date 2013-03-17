
package scuts.ht.instances;


import scuts.ht.classes.Arrow;
import scuts.ht.classes.Monad;
import scuts.ht.core.In;
import scuts.ht.instances.std.FunctionArrow;
import scuts.ht.instances.std.KleisliArrow;
import scuts.ht.core.Of;

import scuts.ht.instances.Categorys.*;

class Arrows 
{
  @:implicit @:noUsing public static var functionArrow          (default, null):Arrow<In->In> = new FunctionArrow(functionCategory);
  
  @:implicit @:noUsing public static function kleisliArrow      <M>(m:Monad<M>):Arrow<In->Of<M, In>> return new KleisliArrow(m, kleisliCategory(m));
}