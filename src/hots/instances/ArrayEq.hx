package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;
import scuts.core.extensions.Arrays;


class ArrayEq<T> extends EqAbstract<Array<T>> 
{
  
  var eqT:Eq<T>;
  
  public function new (eqT:Eq<T>) 
  {
    this.eqT = eqT;
  }
  
  override public inline function eq  (a:Array<T>, b:Array<T>):Bool return Arrays.eq(a,b, eqT.eq)
  
}
