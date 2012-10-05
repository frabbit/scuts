package hots.instances;


import hots.classes.Zero;


class ArrayZero<T> implements Zero<Array<T>>
{
  public function new () { }
  
  public inline function zero ():Array<T> return []
}
