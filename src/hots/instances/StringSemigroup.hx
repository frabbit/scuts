package hots.instances;



import hots.classes.Semigroup;

class StringSemigroup implements Semigroup<String>
{
  public function new () {}
  
  public inline function append (a:String, b:String):String {
    return a + b;
  }

}
