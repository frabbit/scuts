package scuts.macros.coreextensions;

#if (macro || display)
import haxe.macro.Expr;
import scuts.macros.builder.PartialApplication;
#end

class Function1Ext 
{

  @:macro public static function _<A,B>(f:ExprRequire<A->B>, a:ExprRequire<A>) 
  {
    return PartialApplication.apply([f,a]);
  }
  
}