package scuts1.instances.std;

import scuts1.classes.EqAbstract;
import scuts.core.Options;

import scuts1.classes.Eq;


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
