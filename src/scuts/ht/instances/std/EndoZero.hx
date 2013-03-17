package scuts.ht.instances.std;

using scuts.core.Functions;

import scuts.ht.classes.Monoid;
import scuts.ht.classes.Zero;
import scuts.Scuts;

class EndoZero<T> implements Zero<T->T>
{
  
  public function new () {}
  
  public function zero ():T->T 
  {
    return Scuts.id;
  }
}
