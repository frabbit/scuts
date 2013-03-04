package scuts1.instances.std;



import scuts1.classes.Semigroup;


class BoolSemigroup implements Semigroup<Bool>
{
  public function new () {}
  
  public inline function append (a:Bool, b:Bool):Bool return a && b;
}
