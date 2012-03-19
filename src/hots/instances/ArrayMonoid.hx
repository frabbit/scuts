package hots.instances;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;




class ArrayMonoid<T> extends MonoidAbstract<Array<T>>
{
  public function new () {}
  
  override public inline function append (a:Array<T>, b:Array<T>):Array<T> {
    return a.concat(b);
  }
  override public inline function empty ():Array<T> {
    return [];
  }

}
