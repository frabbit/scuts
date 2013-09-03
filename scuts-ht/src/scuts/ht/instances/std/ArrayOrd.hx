package scuts.ht.instances.std;

import scuts.ht.classes.Ord;
import scuts.ht.classes.OrdAbstract;
import scuts.ht.instances.std.BoolEq;
import scuts.core.Ordering;

class ArrayOrd<T> extends OrdAbstract<Array<T>> 
{
  var ordT:Ord<T>;
  
  public function new (ordT, eq) 
  {
    super(eq);
    this.ordT = ordT;
  }

  override public function compare(a:Array<T>, b:Array<T>):Ordering 
  {
    var smaller = a.length < b.length ? a : b;
    
    for (i in 0...smaller.length) 
    {
      var e1 = a[i];
      var e2 = b[i];
      var r = ordT.compare(e1,e2);
      if (r != EQ) return r;
    }
    var diff = a.length - b.length;
    
    return if (diff < 0) LT else if (diff > 0) GT else EQ;
  }
}
