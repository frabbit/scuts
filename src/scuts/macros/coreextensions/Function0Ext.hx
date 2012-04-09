package scuts.macros.coreextensions;

#if (macro || display)
import haxe.macro.Expr;
import scuts.macros.builder.PartialApplication;
#end

class Function0Ext 
{

  @:macro public static function _<A>(f:ExprRequire<Void->A>) 
  {
    return PartialApplication.apply([f]);
  }
  
}