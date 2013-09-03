package scuts.ht.instances.std;



import scuts.ht.classes.Semigroup;


class BoolSemigroup implements Semigroup<Bool>
{
  public function new () {}
  
  public inline function append (a:Bool, b:Bool):Bool return a && b;
}
