package scuts.ht.instances.std;

import scuts.ht.classes.Empty;
import scuts.core.Options;


class OptionEmpty implements Empty<Option<_>>
{
  public function new () {}

  public inline function empty <A>():Option<A>
  {
    return None;
  }

}
