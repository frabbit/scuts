package scuts1.instances.std;

import scuts1.classes.Empty;

import scuts1.core.In;
import scuts1.instances.std.ArrayOf;

class ArrayEmpty implements Empty<Array<In>>
{
  public function new () {}
  
  public inline function empty <A>():ArrayOf<A> 
  {
    return [];
  }
  
}
