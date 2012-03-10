package hots.instances;


import hots.classes.MonoidAbstract;

class BoolMonoidImpl extends MonoidAbstract<Bool>
{
  public function new () {}
  
  override public inline function append (a:Bool, b:Bool):Bool return a && b
  override public inline function empty ():Bool return false
}

typedef BoolMonoid = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(BoolMonoidImpl)]>;