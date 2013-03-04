package scuts1.instances.std;

using scuts.core.Functions;

import scuts1.classes.Monoid;
import scuts1.classes.Zero;
import scuts.Scuts;

class EndoZero<T> implements Zero<T->T>
{
  
  public function new () {}
  
  public function zero ():T->T 
  {
    return Scuts.id;
  }
}
