package hots.instances;

using scuts.core.extensions.Functions;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import scuts.Scuts;

class EndoMonoid<T> extends MonoidAbstract<T->T>
{
  public function new () super(EndoSemigroup.get())
  
  override public function empty ():T->T 
  {
    return Scuts.id;
  }
}
