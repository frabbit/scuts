package hots;


#if (macro || display)
import haxe.macro.Expr;
import haxe.PosInfos;
import hots.macros.Box;
#end

// Of is like a newtype, it's compiled as Dynamic, but at compilation time it is a full featured type.
@:native('Dynamic')
class Of<M,A>
{
  // tries to create an Of type of val
  @:macro public static function box (val:Expr):Expr
  {
    return Box.box1(val);
  }
  
  /*
  @:macro public function unbox (ethis):Expr {
    return Box.unbox1(ethis);
  }
  */
}