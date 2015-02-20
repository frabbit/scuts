package scuts.ht.instances.std;

import scuts.ht.classes.Empty;


class ArrayEmpty implements Empty<Array<In>>
{
  public function new () {}

  public inline function empty <A>():Array<A>
  {
    return [];
  }

}
