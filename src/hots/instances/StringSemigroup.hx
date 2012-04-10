package hots.instances;



import hots.classes.SemigroupAbstract;

class StringSemigroup extends SemigroupAbstract<String>
{
  public function new () {}
  
  override public inline function append (a:String, b:String):String {
    return a + b;
  }

}
