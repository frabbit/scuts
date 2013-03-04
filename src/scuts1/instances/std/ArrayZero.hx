package scuts1.instances.std;


import scuts1.classes.Zero;


class ArrayZero<T> implements Zero<Array<T>>
{
  public function new () { }
  
  public inline function zero ():Array<T> return [];
}
