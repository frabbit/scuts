package hots.instances;

import hots.classes.Monad;

#if (macro || display)
import hots.macros.TypeClasses;
import haxe.macro.Expr;
#end

class KleisliArrow
{
  static var hash:Hash<KleisliArrowImpl<Dynamic>> = new Hash();
  
  @:macro public static function get <S>(monadT:ExprRequire<Monad<S>>):Expr {
    return TypeClasses.forType([monadT], "Hash<KleisliArrowImpl<Dynamic>>", "hots.instances.KleisliArrowImpl", "hots.instances.KleisliArrow");
  }
}

private typedef B = hots.instances.KleisliBox;

