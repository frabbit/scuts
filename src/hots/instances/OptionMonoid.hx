package hots.instances;


//import haxe.macro.Expr;
import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.classes.Semigroup;

import scuts.core.types.Option;

class OptionMonoid<X> extends MonoidAbstract<Option<X>>
{
  
  public function new (semi) super(semi)
  
  
  override public inline function empty ():Option<X> {
    return None;
  }
}
