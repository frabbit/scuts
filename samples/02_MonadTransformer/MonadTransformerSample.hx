package ;


using hots.macros.Box;
using hots.macros.Resolver;

import scuts.core.extensions.Options;
import scuts.core.types.Option;
import hots.classes.Monad;
import hots.classes.MonadZero;
import hots.instances.ArrayOfMonad;
import hots.instances.ArrayOfMonadZero;
import hots.instances.OptionTOfMonad;
import hots.instances.OptionTOfMonadZero;

using hots.extensions.MonadExt;

class MonadTransformerSample 
{

  public static function main () {
    var a = [Some(5), Some(7), Some(2)].box(2);
    var b = [Some(2), Some(3), Some(1)].box(2);
    
    var m = a.tc(Monad); // ArrayTMonad.get(OptionMonad.get())
    
    var res = m.runDo(
      x <= a,
      y <= b,
      return x + y
    );
    
    
    trace(res);
    
    var mz = a.tc(MonadZero);
    
    var res2 = mz.runDo(
      x <= a,
      filter(x > 2),
      y <= b,
      return x + y
    );
    
    trace(res2);
    
    
  }
    
  
}
