package hots.instances;

import hots.classes.MonoidAbstract;
import hots.Objects;


class IntProductMonoid extends MonoidAbstract<Int>
{
  public function new (semi) super(semi)
  
  
  override public inline function empty ():Int {
    return 1;
  }
}
