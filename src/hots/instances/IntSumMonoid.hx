package hots.instances;

import hots.classes.MonoidAbstract;



class IntSumMonoid extends MonoidAbstract<Int>
{
  public function new (semi) super(semi)
  
  override public inline function empty ():Int return 0
}
