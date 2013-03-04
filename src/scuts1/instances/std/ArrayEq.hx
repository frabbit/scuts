package scuts1.instances.std;

import scuts1.classes.Eq;
import scuts1.classes.EqAbstract;
import scuts.core.Arrays;


class ArrayEq<T> extends EqAbstract<Array<T>> 
{
  var eqT:Eq<T>;
  
  public function new (eqT:Eq<T>) 
  {
    this.eqT = eqT;
  }
  
  override public inline function eq  (a:Array<T>, b:Array<T>):Bool return Arrays.eq(a,b, eqT.eq);
}
