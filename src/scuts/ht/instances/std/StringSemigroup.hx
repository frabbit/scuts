package scuts.ht.instances.std;



import scuts.ht.classes.Semigroup;

class StringSemigroup implements Semigroup<String>
{
  public function new () {}
  
  public inline function append (a:String, b:String):String {
    return a + b;
  }

}
