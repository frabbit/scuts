package hots.instances;


import hots.classes.MonoidAbstract;

class StringMonoid extends MonoidAbstract<String>
{
  public function new (semi) super(semi)
  
  
  override public inline function empty ():String {
    return "";
  }
}
