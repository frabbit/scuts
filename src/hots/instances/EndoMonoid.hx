package hots.instances;

using scuts.core.extensions.Functions;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import scuts.Scuts;

class EndoMonoid<T> extends MonoidAbstract<T->T>
{
  static var instance = new EndoMonoid(new EndoSemigroup());
  
  public static inline function endo <T>():EndoMonoid<T> return instance
  
  
  public function new (semi) super(semi)
  
  override public function empty ():T->T 
  {
    return Scuts.id;
  }
}
