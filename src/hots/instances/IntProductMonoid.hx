package hots.instances;

import hots.classes.MonoidAbstract;


class IntProductMonoid extends MonoidAbstract<Int>
{
  public function new () super(IntProductSemigroup.get())
  
  
  override public inline function empty ():Int {
    return 1;
  }
}
