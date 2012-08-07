package hots.instances;

import hots.classes.SemigroupAbstract;

using hots.extensions.ArrayOfs;



class ArrayOfSemigroup<T> extends SemigroupAbstract<ArrayOf<T>>
{
  public function new () {}
  
  override public inline function append (a:ArrayOf<T>, b:ArrayOf<T>):ArrayOf<T> 
  {
    return a.append(b);
  }
}
