package hots.instances;

import hots.classes.Ord;
import hots.classes.OrdAbstract;
import scuts.core.extensions.Options;
import scuts.core.types.Option;
import scuts.core.types.Ordering;

class OptionOrd<T> extends OrdAbstract<Option<T>> 
{
  var ordT:Ord<T>;

  public function new (ordT, eq) 
  {
    super(eq);
    this.ordT = ordT;
  }

  override public function compare(a:Option<T>, b:Option<T>):Ordering return Options.compareBy(a,b, ordT.compare)
}
