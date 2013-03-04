
package scuts1.instances;


import scuts1.classes.Arrow;
import scuts1.classes.Monad;
import scuts1.core.In;
import scuts1.instances.std.FunctionArrow;
import scuts1.instances.std.KleisliArrow;
import scuts1.core.Of;

import scuts1.instances.Categorys.*;

class Arrows 
{
  @:implicit @:noUsing public static var functionArrow          (default, null):Arrow<In->In> = new FunctionArrow(functionCategory);
  
  @:implicit @:noUsing public static function kleisliArrow      <M>(m:Monad<M>):Arrow<In->Of<M, In>> return new KleisliArrow(m, kleisliCategory(m));
}