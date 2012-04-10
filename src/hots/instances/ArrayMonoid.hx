package hots.instances;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;


class ArrayMonoid<T> extends MonoidAbstract<Array<T>>
{
  public function new () super(ArraySemigroup.get())
  
  override public inline function empty ():Array<T> return []
}
