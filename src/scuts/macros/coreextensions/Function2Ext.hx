package scuts.macros.coreextensions;

#if (macro || display)
import haxe.macro.Expr;
import scuts.macros.builder.PartialApplication;
#end

class Function2Ext 
{

  @:macro public static function _<A,B,C>(f:ExprRequire<A->B->C>, a:ExprRequire<A>, b:ExprRequire<B>) 
  {
    return PartialApplication.apply([f,a,b]);
  }
  
}