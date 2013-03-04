package scuts1.instances.std;


import scuts1.classes.Semigroup;



class ArraySemigroup<T> implements Semigroup<Array<T>>
{
  public function new () {}
  
  public inline function append (a1:Array<T>, a2:Array<T>):Array<T> 
  {
    return a1.concat(a2);
  }
}
