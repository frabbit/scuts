package scuts.ht.instances.std;

import scuts.ht.classes.EqAbstract;
import scuts.core.Options;

import scuts.ht.classes.Eq;


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
