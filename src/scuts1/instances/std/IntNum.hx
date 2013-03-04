package scuts1.instances.std;
import scuts1.classes.Eq;
import scuts1.classes.Num;
import scuts1.classes.NumAbstract;
import scuts1.classes.Show;

class IntNum extends NumAbstract<Int>
{
  public function new (eq:Eq<Int>, show:Show<Int>) 
  { 
    super(eq, show);
  }
  
  override public inline function plus (a:Int, b:Int):Int return a+b;
  override public inline function mul (a:Int, b:Int):Int return a*b;
  
  override public inline function minus (a:Int, b:Int):Int return a-b;
  override public inline function negate (a:Int):Int return -a;
  override public inline function abs (a:Int):Int return a > 0 ? a : -1;
  override public inline function signum (a:Int):Int return a > 0 ? 1 : (a < 0  ? -1 : 0);
  override public inline function fromInt (a:Int):Int return a;
}
