package hots.instances;


import hots.classes.MonoidAbstract;
import scuts.core.types.Option;

class OptionMonoid<X> extends MonoidAbstract<Option<X>>
{
  
  public function new (semi) super(semi)
  
  
  override public inline function empty ():Option<X> {
    return None;
  }
}
