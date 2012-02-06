package hots.instances;

import hots.classes.Category;
import hots.classes.Monad;



#if (macro || display)
import scuts.mcore.Print;
import hots.macros.TypeClasses;
import haxe.macro.Expr;
#end

class KleisliCategory 
{
  static var hash:Hash<KleisliCategoryImpl<Dynamic>> = new Hash();
  
  @:macro public static function get <S>(monadT:ExprRequire<Monad<S>>):Expr {
    var e = TypeClasses.forType([monadT], "Hash<hots.instances.KleisliCategoryImpl<Dynamic>>", "hots.instances.KleisliCategoryImpl", "hots.instances.KleisliCategory");
    //trace(Print.exprStr(e));
    return e;
  }
}


