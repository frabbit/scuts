package hots.instances;

using scuts.core.extensions.Functions;

import hots.classes.Monoid;
import hots.classes.Zero;
import scuts.Scuts;

class EndoZero<T> implements Zero<T->T>
{
  
  public function new () {}
  
  public function zero ():T->T 
  {
    return Scuts.id;
  }
}
