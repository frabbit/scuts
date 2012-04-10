package hots.instances;



import hots.classes.SemigroupAbstract;

class BoolSemigroup extends SemigroupAbstract<Bool>
{
  public function new () {}
  
  override public inline function append (a:Bool, b:Bool):Bool return a && b

}
