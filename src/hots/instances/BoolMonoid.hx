package hots.instances;


import hots.classes.MonoidAbstract;

class BoolMonoid extends MonoidAbstract<Bool>
{
  public function new () {}
  
  override public inline function append (a:Bool, b:Bool):Bool return a && b
  override public inline function empty ():Bool return false
}
