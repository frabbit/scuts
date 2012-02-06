package hots.instances;
import hots.classes.Num;
import hots.instances.EqInt;
/**
 * ...
 * @author 
 */

class NumInt {
  public static var get(getInstance, null):NumIntImpl;
  
  static function getInstance ()
  {
    if (get == null) get = new NumIntImpl();
    return get;
  }
}
 
class NumIntImpl extends EqIntImpl, implements Num<Int>
{
  public function new () { super();}
  public inline function show (i:Int) return ShowInt.get.show(i)
  
  public inline function plus (a:Int, b:Int):Int return a+b
  public inline function mul (a:Int, b:Int):Int return a*b
  
  public inline function minus (a:Int, b:Int):Int return a-b
  public inline function negate (a:Int):Int return -a 
  public inline function abs (a:Int):Int return a > 0 ? a : -1
  public inline function signum (a:Int):Int return a > 0 ? 1 : (a < 0  ? -1 : 0)
  public inline function fromInt (a:Int):Int return a
}