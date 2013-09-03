package scuts.ht.instances.std;

import scuts.ht.classes.Empty;

import scuts.ht.core.In;
import scuts.ht.instances.std.ArrayOf;

class ArrayEmpty implements Empty<Array<In>>
{
  public function new () {}
  
  public inline function empty <A>():ArrayOf<A> 
  {
    return [];
  }
  
}
