package hots.instances;
import hots.classes.Num;
import hots.classes.NumAbstract;

class IntNumImpl extends NumAbstract<Int>
{
  public function new () { super(IntEq.get(), IntShow.get());}
  
  
  override public inline function plus (a:Int, b:Int):Int return a+b
  override public inline function mul (a:Int, b:Int):Int return a*b
  
  override public inline function minus (a:Int, b:Int):Int return a-b
  override public inline function negate (a:Int):Int return -a 
  override public inline function abs (a:Int):Int return a > 0 ? a : -1
  override public inline function signum (a:Int):Int return a > 0 ? 1 : (a < 0  ? -1 : 0)
  override public inline function fromInt (a:Int):Int return a
}

typedef IntNum = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(IntNumImpl)]>;