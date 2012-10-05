package hots.instances;

import hots.classes.Empty;

import hots.In;
import hots.of.ArrayOf;

class ArrayEmpty implements Empty<Array<In>>
{
  public function new () {}
  
  public inline function empty <A>():ArrayOf<A> 
  {
    return [];
  }
  
}
