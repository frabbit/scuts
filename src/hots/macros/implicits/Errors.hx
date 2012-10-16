package hots.macros.implicits;

#if macro

import scuts.mcore.Print;
import scuts.Scuts;

import haxe.macro.Expr;
import hots.macros.implicits.Data;

using scuts.core.Arrays;

/**
 * Error Logging
 */
class Errors
{
  public static function invalidType(t:String) 
  {
    return Scuts.error("The String " + t + " is not a valid type in current context.");
  }
  
  public static function castFailed(expr:Expr, method:String) 
  {
    return Scuts.error("cast '" + method + "' failed for expr " + Tools.prettyExpr(expr) + " of Type " + Tools.prettyTypeOfExpr(expr));
  }
  
  public static function nullExprInArgs(functionExpr:Expr, params:Array<Expr>) {
  
    return Scuts.error("null is not allowed as function argument" + Tools.prettyTypeOfExpr(functionExpr));
  }
  
  public static function unsafeCastInArgs(functionExpr:Expr, params:Array<Expr>) 
  {
    trace("----------------Unsafe cast detected ----------------------");
    Tools.printExprs(params);
    trace("----------------Unsafe end           ----------------------");
    return Scuts.error("Cannot handle unsafe casted expressions");
  }
  
  public static function handleAmbiguityError(f:AmbiguityError) 
  {
    function makeMessage (scope:String, arr:Array<NamedExpr>) {
      
      var e = arr[0].expr;
      
      var helper = Resolver.helper;
      
      var typeStr = Tools.prettyTypeOfExpr(macro $helper.removeImplicit($e));
      
      return "Ambiguity Error Multiple Implicit Objects for Type " + typeStr + " in " + scope + "-Scope\n"
          +  "Namely : " + arr.map(function (x) return x.name).join(", ");
    }
    
    var msg = switch (f) {
      case StaticsAmbiguous(arr): makeMessage("Static", arr);
      case MembersAmbiguous(arr): makeMessage("Member", arr);
    }
    
    return Scuts.macroError(msg);
  }
  
  public static function implicitObjectDefinitionIsIncorrect (found:Expr, required:Expr) 
  {
    var msg = 
      "---------------- Wrong implicit Obj definition found --------------\n"
      + "Found: " + Tools.prettyTypeOfExpr(found) + "\n"
      + "Expected: " + Tools.prettyType(Tools.getTypeOfRequired(required)) + "\n"
      + "-------------------------------------------------------------------";
    return Scuts.error(msg);
  }
  
  public static function invalidImplicitObjInScope (required:Expr) 
  {
    var msg = 
      "Invalid implicitObj definition for type " + Tools.prettyType(Tools.getTypeOfRequired(required))  + " in current scope\n"
      + "It's possible that you leaved out an explicit return type, which is needed when the resulting object depends "
      + "on type parameters.";
    return Scuts.error(msg);
  }
  public static function noImplicitObjectInContext (required:Expr) 
  {
    return Scuts.macroError("Cannot find implicitObj Definition for type " + Tools.prettyType(Tools.getTypeOfRequired(required)) + " in current context");
  }
  public static function circularDependency (imp1:Expr, imp2:Expr) {
    return Scuts.warning(
      "Circular dependency",
      "Circular dependency between " + Tools.prettyType(Tools.getTypeOfRequired(imp1)) + " and " + Tools.prettyType(Tools.getTypeOfRequired(imp2)) + " in current scope\n"
      + "This may happen if the passed expression contains unsafe casts"
    );
  }
  
  public static function functionParameterIsIncompatible(param:Expr, required:Expr) 
  {
    return 
      Scuts.macroError("The Type is not compatible and an cannot find an implicit cast\n\n "
      + "from " + Tools.prettyTypeOfExpr(param) + " to " + Tools.prettyType(Tools.getTypeOfRequired(required)) + "\n\n"
      + "for expression " + Tools.prettyExpr(param) 
      );
  }
  
  public static function invalidImplicitObjFunction() 
  {
    return Scuts.macroError("implicitObj must be a function taking a parameter of type ImplicitObject<T> as first parameter");
  }

  public static function functionExprIsNotAFunction (functionExpr:Expr) 
  {
    return Scuts.macroError("The expression ( " + Print.expr(functionExpr) + " ) is not function type", functionExpr.pos);
  }
  
  public static function functionExprCannotBeTyped (functionExpr:Expr) 
  {
    return Scuts.macroError("Cannot determine the type of expression ( " + Print.expr(functionExpr) + " )", functionExpr.pos);
  }
  
  public static function tooManyFunctionParams (functionExpr:Expr, params:Array<Expr>, numArgs:Int) 
  {
    return Scuts.macroError("Too many arguments for this function, " + numArgs + " expected, " + params.length + " received ", functionExpr.pos);
  }
  
}

#end