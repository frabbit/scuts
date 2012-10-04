package hots.macros.implicits;

#if macro

import scuts.Scuts;

import haxe.macro.Expr;
import haxe.macro.Context;

/**
 * Logging Helpers
 */
class Log 
{
  
  static var enabled = #if scutsDebug true #else false #end;
  
  public static function resultingExpr(expr:Expr) 
  {
    if (enabled) 
    {
      trace("---------------- Returned Expr---------------------- ---------------");
      trace("IS TAGGED CAST: " + Hacks.isTaggedCast(expr));
      Tools.printTypeOfExpr(expr, "checked Type");
      Tools.printExpr(expr, "expr");
      trace("--------------------------------------------------------------------");
      trace("--------------------------------------------------------------------");
      trace("--------------------------------------------------------------------");
    }
  }
    
  public static function implicitObjectDependencies(field:Expr, required:Expr) 
  {
    if (enabled) 
    {
      trace("---------------- Implicit Object needed Dependencies ---------------");
      Tools.printTypeOfExpr(required, "Needed");
      Tools.printTypeOfExpr(field, "New Needed");
      trace("-------------------------------------------------------------------");
    }
  }
  
  
  public static function adjustParameterInit(param:Expr, required:Expr) 
  {
    if (enabled) {
      var upcasted = macro $param.implicitUpcast();
      var helper = Resolver.helper;
      trace("-------------- try parameter upcasting first ------------");
      trace("Success: " + Tools.isCompatible(upcasted, required));
      if (Tools.isTypeable(upcasted)) {
        trace("Upcasted Type: " + Tools.prettyTypeOfExpr(upcasted));
      } else {
        trace("Upcasted Type: not available");
      }
      trace("Is Also Normal: " + Tools.isCompatible(param, required));
      trace("For needed: " + Tools.prettyType(Tools.getTypeOfRequired(required)));
      trace("Param: " + Tools.prettyTypeOfExpr(param));
      trace("IsOfType: " + Tools.isTypeable(macro $helper.neededIsOfType($required)));
      trace("-----------------------------------------");
    }
  }
  
  public static function implicitCastApplication(expr:Expr, casted:Expr, castTypeable:Bool, method:String, canFail:Bool) 
  {
    if (enabled) 
    {
      trace("------------implicitCastApplied: " + castTypeable + " -------------");
      trace("method: " + method);
      trace("canFail: " + canFail);
      if (castTypeable) {
        Tools.printTypeOfExpr(casted, "New Type");
        Tools.printTypeOfExpr(expr, "Old Type");
      } else {
        
        trace(Tools.prettyTypeOfExpr(expr) + " has no function implicitDowncast in scope");
      }
      trace("----------------------------------------------------------------------");
    }
  }
  
  public static function startResolve (functionExpr:Expr, params:Array<Expr>) 
  {
    if (enabled) 
    {
      trace("--------------------------------------------------------------------");
      trace("--------------------------------------------------------------------");
      trace("------------ Apply Started Pre Simplify -------------");
      trace("IS Tagged Cast: " + Hacks.isTaggedCast(functionExpr));
      Tools.printTypeOfExpr(Hacks.makeTypeable(functionExpr), "typable function Type");
      Tools.printTypeOfExpr(functionExpr, "function Type");
      if (params.length > 0) {
        trace("Param 0 is Tagged Cast: " + Hacks.isTaggedCast(params[0]));
        trace("ExprInfos: " + Std.string(Context.getPosInfos(params[0].pos).file));
      }
      Tools.printExpr(functionExpr, "function Expr");
      Tools.printTypeOfExprs(params, "param Types");
      Tools.printExprs(params, "exprs");
      trace("----------------------------------------");
    }
  }
  
  public static function afterSimplify (functionExpr:Expr) 
  {
    if (enabled) 
    {
      trace("------------ Apply Started Post Simplify -------------");
      trace("IS Tagged Cast: " + Hacks.isTaggedCast(functionExpr));
      Tools.printTypeOfExpr(Hacks.makeTypeable(functionExpr), "typable function Type");
      Tools.printTypeOfExpr(functionExpr, "function Type");
      Tools.printExpr(functionExpr, "Post Simplify");
      trace("-------------passed function-------------");
    }
  }
}

#end

