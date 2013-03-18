package scuts.ht.syntax;
import scuts.ht.classes.Applicative;
import scuts.ht.classes.Monad;
import scuts.ht.classes.Pure;
import scuts.ht.core.Of;

#if macro
import haxe.macro.Expr.ExprOf;

private typedef R = scuts.ht.macros.implicits.Resolver;

#end

#if display

class PuresM
{
  
  public static function pure_<M,A>(x:A, pure:String):Of<M, A>
  {
    return m.pure(x);
  }
  
}

#else



class PuresM
{
  macro public static function pure_<M,A>(x:ExprOf<A>, pure:String):ExprOf<Of<M,A>>
  {
  	var pure = R.resolveImplicitObjByType("Pure<" + pure + ">");
    return R.resolve(macro scuts.ht.syntax.Pures.pure, [x, pure]);
  }
  
}

#end