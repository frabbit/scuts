package hots.instances;


import hots.classes.MonoidAbstract;

class StringMonoid extends MonoidAbstract<String>
{
  public function new () super(StringSemigroup.get())
  
  
  override public inline function empty ():String {
    return "";
  }
}
