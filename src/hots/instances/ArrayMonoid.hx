package hots.instances;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.Objects;


class ArrayMonoid<T> extends MonoidAbstract<Array<T>>
{
  public function new (semi) super(semi)
  
  override public inline function empty ():Array<T> return []
}
