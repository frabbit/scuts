package hots.instances;


import hots.classes.SemigroupAbstract;


class ArraySemigroup<T> extends SemigroupAbstract<Array<T>>
{
  public function new () {}
  
  override public inline function append (a1:Array<T>, a2:Array<T>):Array<T> 
  {
    return a1.concat(a2);
  }
}
