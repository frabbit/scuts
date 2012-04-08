package hots.instances;

using scuts.core.extensions.FunctionExt;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import scuts.Scuts;

class EndoMonoid<T> extends MonoidAbstract<T->T>
{
  public function new () {}
  
  override public function append (a:T->T, b:T->T):T->T {
    return a.compose(b);
  }
  override public function empty ():T->T {
    return Scuts.id;
  }
}
