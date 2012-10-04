package hots.instances;

import hots.classes.EqAbstract;
import scuts.core.extensions.Options;
import scuts.core.types.Option;
import hots.classes.Eq;


class OptionEq<T> extends EqAbstract<Option<T>> 
{
  var eqT:Eq<T>;

  public function new (eqT:Eq<T>) 
  {
    this.eqT = eqT;
  }
  
  override public function eq  (a:Option<T>, b:Option<T>):Bool 
  {
    return Options.eq(a,b, eqT.eq);
  }
  
}
