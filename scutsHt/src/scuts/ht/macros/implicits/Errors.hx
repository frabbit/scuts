package scuts.ht.macros.implicits;

#if macro

import haxe.macro.Context;
import scuts.mcore.Print;
import scuts.Scuts;

import haxe.macro.Expr;
import scuts.ht.macros.implicits.Data;

import scuts.ht.macros.implicits.Typer;

using scuts.core.Arrays;
using scuts.core.Options;

/**
 * Error Logging
 */

enum ResolverError 
{
  InvalidType(t:String);
  CastFailed(expr:Expr, method:String);
  ImplicitObjectDefinitionIsIncorrect(found:Expr, required:Expr);
  NoImplicitObjectInContext (required:Expr);
  CircularDependency (imp1:Expr, imp2:Expr);
  InvalidImplicitObjInScope (required:Expr, reason:ResolverError);
  FunctionParameterIsIncompatible(param:Expr, required:Expr);
  InvalidImplicitObjFunction;
  FunctionExprIsNotAFunction (functionExpr:Expr);
  FunctionExprCannotBeTyped (functionExpr:Expr);
  TooManyFunctionParams (functionExpr:Expr, params:Array<Expr>, numArgs:Int);
  NullExprInArgs(functionExpr:Expr, params:Array<Expr>);
  UnsafeCastInArgs(functionExpr:Expr, params:Array<Expr>); 
  ImplicitAmbiguityError(err:AmbiguityError);
}

class Errors
{
  public static function invalidType(t:String) 
  {
    return InvalidType(t);
  }
  
  public static function castFailed(expr:Expr, method:String) 
  {
    return CastFailed(expr, method);
  }
  
  public static function nullExprInArgs(functionExpr:Expr, params:Array<Expr>) {
  
    return NullExprInArgs(functionExpr, params);
  }
  
  public static function unsafeCastInArgs(functionExpr:Expr, params:Array<Expr>) 
  {
    return UnsafeCastInArgs(functionExpr, params);
  }
  
  
  public static function implicitObjectDefinitionIsIncorrect (found:Expr, required:Expr) 
  {
    return ImplicitObjectDefinitionIsIncorrect(found, required);
  }
  
  public static function invalidImplicitObjInScope (required:Expr, reason:ResolverError) 
  {
    return InvalidImplicitObjInScope (required, reason);
  }
  
  public static function noImplicitObjectInContext (required:Expr) 
  {
    return NoImplicitObjectInContext(required);
  }
  
  public static function circularDependency (imp1:Expr, imp2:Expr) 
  {
    return CircularDependency(imp1, imp2);
  }
  
  public static function functionParameterIsIncompatible(param:Expr, required:Expr) 
  {
    return FunctionParameterIsIncompatible(param, required);
  }
  
  public static function invalidImplicitObjFunction() 
  {
    return InvalidImplicitObjFunction;
  }

  public static function functionExprIsNotAFunction (functionExpr:Expr) 
  {
    return FunctionExprIsNotAFunction(functionExpr);
  }
  
  public static function functionExprCannotBeTyped (functionExpr:Expr) 
  {
    return FunctionExprCannotBeTyped(functionExpr);
  }
  
  public static function tooManyFunctionParams (functionExpr:Expr, params:Array<Expr>, numArgs:Int) 
  {
    return TooManyFunctionParams(functionExpr, params, numArgs);
  }
  
}

class ErrorPrinter
{

  public static function toString (e:ResolverError) {
    return switch (e) {
      case InvalidType(t): invalidType(t);
      case CastFailed(expr, method): castFailed(expr, method);
      case ImplicitObjectDefinitionIsIncorrect(found, required): implicitObjectDefinitionIsIncorrect(found, required);
      case NoImplicitObjectInContext (required): noImplicitObjectInContext(required);
      case CircularDependency (imp1, imp2): circularDependency(imp1, imp2);
      case InvalidImplicitObjInScope (required, reason): invalidImplicitObjInScope(required, reason);
      case FunctionParameterIsIncompatible(param, required): functionParameterIsIncompatible(param, required);
      case InvalidImplicitObjFunction: invalidImplicitObjFunction();
      case FunctionExprIsNotAFunction (functionExpr): functionExprIsNotAFunction(functionExpr);
      case FunctionExprCannotBeTyped (functionExpr): functionExprCannotBeTyped(functionExpr);
      case TooManyFunctionParams (functionExpr, params, numArgs): tooManyFunctionParams(functionExpr, params, numArgs);
      case NullExprInArgs(functionExpr, params): nullExprInArgs(functionExpr, params);
      case UnsafeCastInArgs(functionExpr, params): unsafeCastInArgs(functionExpr,params);
      case ImplicitAmbiguityError(err): implicitAmbiguityError(err);
    }
  }
  public static function invalidType(t:String) 
  {
    return "The String " + t + " is not a valid type in current context.";
  }
  
  public static function castFailed(expr:Expr, method:String) 
  {
    return "cast '" + method + "' failed for expr " + Tools.prettyExpr(expr) + " of Type " + Tools.prettyTypeOfExpr(expr);
  }
  
  public static function nullExprInArgs(functionExpr:Expr, params:Array<Expr>) {
  
    return "null is not allowed as function argument" + Tools.prettyTypeOfExpr(functionExpr);
  }
  
  public static function unsafeCastInArgs(functionExpr:Expr, params:Array<Expr>) 
  {
    return 
        "----------------Unsafe cast detected ----------------------"
      + Tools.prettyExprs(params)
      + "----------------Unsafe end           ----------------------"
      + "Cannot handle unsafe casted expressions";
  }
  
  public static function implicitAmbiguityError(f:AmbiguityError) 
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
    
    return msg;
  }
  
  public static function implicitObjectDefinitionIsIncorrect (found:Expr, required:Expr) 
  {
    var msg = 
      "---------------- Wrong implicit Obj definition found --------------\n"
      + "Found: " + Tools.prettyTypeOfExpr(found) + "\n"
      + "Expected: " + Typer.typeof(required).map(Tools.prettyType) + "\n"
      + "-------------------------------------------------------------------";
    return msg;
  }
  
  public static function invalidImplicitObjInScope (required:Expr, reason:ResolverError) 
  {
    var msg = 
      "Invalid implicitObj definition for type " + Typer.typeof(required).map(Tools.prettyType)  + " in current scope\n"
      + "Reason:\n" + toString(reason) + "\n"
      + "It's possible that you leaved out an explicit return type, which is needed when the resulting object depends "
      + "on type parameters.";
    return msg;
  }
  public static function noImplicitObjectInContext (required:Expr) 
  {
    return "Cannot find implicitObj Definition for type " + Typer.typeof(required).map(Tools.prettyType) + " in current context";
  }
  public static function circularDependency (imp1:Expr, imp2:Expr) {
    return 
      "Circular dependency\n"
      + "Circular dependency between " + Typer.typeof(imp1).map(Tools.prettyType) + " and " + Typer.typeof(imp2).map(Tools.prettyType) + " in current scope\n"
      + "This may happen if the passed expression contains unsafe casts";
    
  }
  
  public static function functionParameterIsIncompatible(param:Expr, required:Expr) 
  {
    return 
      "The Type is not compatible and an cannot find an implicit cast\n\n "
      + "from " + Tools.prettyTypeOfExpr(param) + " to " + Typer.typeof(required).map(Tools.prettyType) + "\n\n"
      + "for expression " + Tools.prettyExpr(param);
  }
  
  public static function invalidImplicitObjFunction() 
  {
    return "implicitObj must be a function taking a parameter of type ImplicitObject<T> as first parameter";
  }

  public static function functionExprIsNotAFunction (functionExpr:Expr) 
  {
    return "The expression ( " + Print.expr(functionExpr) + " ) is not function type at " + Std.string(Context.getPosInfos(functionExpr.pos));
  }
  
  public static function functionExprCannotBeTyped (functionExpr:Expr) 
  {
    return "Cannot determine the type of expression ( " + Print.expr(functionExpr) + " ) at " + Std.string(Context.getPosInfos(functionExpr.pos));
  }
  
  public static function tooManyFunctionParams (functionExpr:Expr, params:Array<Expr>, numArgs:Int) 
  {
    return "Too many arguments for this function, " + numArgs + " expected, " + params.length + " received at " +  Std.string(Context.getPosInfos(functionExpr.pos));
  }
  
}

#end