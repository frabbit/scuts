package hots.instances;

import hots.classes.MonoidAbstract;


class IntSumMonoidImpl extends MonoidAbstract<Int>
{
  public function new () {}
  
  override public inline function append (a:Int, b:Int):Int {
    return IntNum.get().plus(a,b);
  }
  override public inline function empty ():Int {
    return 0;
  }
}

typedef IntSumMonoid = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(IntSumMonoidImpl)]>;