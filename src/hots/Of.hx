package hots;

import haxe.macro.Expr;
#if (macro || display)
import hots.macros.Box;
#end

// Of is like a newtype, it's compiled as Dynamic, but at compilation time it is a full featured type.
@:native('Dynamic')
class Of<M,A>
{
  @:macro public function unbox (ethis):Expr {
    return Box.mkUnbox(ethis);
  }
}