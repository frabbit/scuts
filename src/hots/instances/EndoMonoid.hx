package hots.instances;

using scuts.core.extensions.Function1Ext;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import scuts.Scuts;


class EndoMonoid
{
  static var instance:EndoMonoidImpl<Dynamic>;

  public static function get <T>():EndoMonoidImpl<T>
  {
    if (instance == null) instance = new EndoMonoidImpl<T>();
    return cast instance;
  }
}

private class EndoMonoidImpl<T> extends MonoidAbstract<T->T>
{
  public function new () {}
  
  override public function append (a:T->T, b:T->T):T->T {
    return a.compose(b);
  }
  override public function empty ():T->T {
    return Scuts.id;
  }
}