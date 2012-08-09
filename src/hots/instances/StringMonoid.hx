package hots.instances;


import hots.classes.MonoidAbstract;
import hots.Objects;

class StringMonoid extends MonoidAbstract<String>
{
  public function new (semi) super(semi)
  
  
  override public inline function empty ():String {
    return "";
  }
}
