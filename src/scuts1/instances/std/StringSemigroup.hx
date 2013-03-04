package scuts1.instances.std;



import scuts1.classes.Semigroup;

class StringSemigroup implements Semigroup<String>
{
  public function new () {}
  
  public inline function append (a:String, b:String):String {
    return a + b;
  }

}
