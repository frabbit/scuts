package scuts1.instances.std;

import scuts1.classes.Ord;
import scuts1.classes.OrdAbstract;
import scuts.core.Options;
import scuts.core.Ordering;

class OptionOrd<T> extends OrdAbstract<Option<T>> 
{
  var ordT:Ord<T>;

  public function new (ordT, eq) 
  {
    super(eq);
    this.ordT = ordT;
  }

  override public function compare(a:Option<T>, b:Option<T>):Ordering return Options.compareBy(a,b, ordT.compare);
}
