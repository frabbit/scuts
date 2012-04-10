package hots.instances;


import hots.classes.MonoidAbstract;

class BoolMonoid extends MonoidAbstract<Bool>
{
  public function new () super(BoolSemigroup.get())
  
  
  override public inline function empty ():Bool return false
}
