package scuts.ht.instances.std;


import scuts.ht.classes.Zero;

class BoolZero implements Zero<Bool>
{
  public function new () {}
  
  public inline function zero () return false;
}
