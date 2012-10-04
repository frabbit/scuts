package hots.macros.implicits;

#if macro

// unwanted dependecies


import scuts.mcore.extensions.Exprs;
import scuts.mcore.extensions.Types;
import scuts.mcore.Make;
import scuts.mcore.Print;
import scuts.Assert;
import scuts.Scuts;
import haxe.Stack;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.PosInfos;
import hots.macros.implicits.Data;

import scuts.core.types.Tup2;
import scuts.core.types.Validation;
import scuts.core.types.Option;

import hots.macros.implicits.Data;

using scuts.core.extensions.Strings;

using scuts.core.extensions.Arrays;
using scuts.core.extensions.Validations;
using scuts.core.extensions.Options;
using scuts.core.extensions.Functions;



enum ArgumentAdjustment 
{
  Upcast;
  Downcast;
  None;
}

private typedef R = Resolver;
private typedef RE = Errors;
private typedef RL = Log;


class Resolver
{
  /**
   * Returns an Expression representing the implicit Object for the given type t.
   * The type is encoded as a string, because something like Array<Int> is not a valid expression.
   */
  public static function resolveImplicitObjByType (t:String) 
  {
    return try 
    {
      var required = Context.parse(" { var e : " + t + " = null; e; } ", Context.currentPos());
      var res = resolveImplicitObj(required);
      return macro $helper.toImplicit($res);
    } 
    catch (e:Dynamic) RE.invalidType(t);
  }
  
  /**
   * Resolves all missing implicit Objects and implicit Casts (implicitDowncast and implicitUpcast) 
   * of a function call expression. The expression f represents a function like myFunc and the params 
   * are the parameters that are already given. The following rules are applied during resolvement:
   * 
   * Parameter Casting:
   * After the first conversion (upcast or downcast) is applied, all following parameters can only be converted with
   * the same type of conversion. This means if the first conversion is an upcast all following conversions can only
   * be upcasts, same for downcasts.
   * 
   * Result Casting:
   * If any Conversion is applied, the resulting function call is casted in the other direction if possible.
   * Examples: 
   * f(p.implicitUpcast()).implicitDowncast() // resulting downcast because of upcast of params
   * f(p.implicitDowncast()).implicitUpcast() // resulting upcast because of downcast of params
   * f(p) // no resulting cast because none of the params are casted
   * 
   */
  public static function resolve (f:Expr, args:Array<Expr>) // f is String -> Monoid<T> -> Bool
  {
    if (args == null) args = [];

    var typeableArgs = args.map(Hacks.makeTypeable);

    return try 
    {
      resolve1(f, typeableArgs, Manager.getImplicitsFromScope(), []);
    } 
    catch (e:Error) 
    {
      Scuts.warning("Resolver Error", e.message);
      { expr : ECall(f, args), pos: Context.currentPos()};
    }
  }
  
  /**
   * 
   * Applies a downcast to the expression expr if the resulting expression
   * is typeable, which means that there exists an implicit downcast through "using" in the current scope.
   * If the flag canFail is set to true, an Error is created, if the resulting expression is not typeable.
   * 
   * Example:
   * e => e.implicitDowncast()
   *
   */
  public static function applyImplicitDowncast(expr:Expr, tagged:Bool, ?canFail:Bool = false):Expr 
  {
    return applyImplicitCast(expr, "implicitDowncast", tagged, canFail);
  }
  
  /**
   * 
   * Applies an upcast to the expression expr if the resulting expression
   * is typeable, which means that there exists an implicit downcast through "using" in the current scope.
   * If the flag canFail is set to true, an Error is created, if the resulting expression is not typeable.
   * 
   * Example:
   * e => e.implicitUpcast()
   *
   */
  public static function applyImplicitUpcast(expr:Expr, tagged:Bool, ?canFail:Bool = false):Expr 
  {
    return applyImplicitCast(expr, "implicitUpcast", tagged, canFail);
  }
  
  /**
   * 
   * Applies a transformer upcast to the expression expr if the resulting expression
   * is typeable, which means that there exists an implicit transformer upcast through "using" in the current scope.
   * If the flag canFail is set to true, an Error is created, if the resulting expression is not typeable.
   * 
   * Example:
   * e => e.implicitUpcastT()
   *
   */
  public static function applyImplicitUpcastT(expr:Expr, tagged:Bool, ?canFail:Bool = true):Expr 
  {
    return applyImplicitCast(expr, "implicitUpcastT", tagged, canFail);
  }
  
  /**
   * 
   * Applies a transformer downcast to the expression expr if the resulting expression
   * is typeable, which means that there exists an implicit transformer downcast through "using" in the current scope.
   * If the flag canFail is set to true, an Error is created, if the resulting expression is not typeable.
   * 
   * Example:
   * e => e.implicitDowncastT()
   *
   */
  public static function applyImplicitDowncastT(expr:Expr, tagged:Bool, ?canFail:Bool = true):Expr 
  {
    return applyImplicitCast(expr, "implicitDowncastT", tagged, canFail);
  }
  
  /**
   * Returns an expression representing an Implicit Object with the same type as 
   * the expression required.
   */
  public static function resolveImplicitObj (required:Expr) 
  {
    return resolveImplicitObj1(required, Manager.getImplicitsFromScope(), []);
  }
  
  // internal functions
  
  /**
   * Shortcut for referencing the Helper class, which is used for a lot of Expression Manipulation.
   * Should have package wide visibility, but this is currently not possible in haxe.
   */
  public static var helper(default, null) = (macro hots.macros.implicits.Helper);
  


  static function curryFunctionExpr (f:Expr, numArgs:Int) return switch (numArgs) 
  {
    case 0: macro $helper.curry0($f);
    case 1: macro $helper.curry1($f);
    case 2: macro $helper.curry2($f);
    case 3: macro $helper.curry3($f);
    case 4: macro $helper.curry4($f);
    case 5: macro $helper.curry5($f);
    case 6: macro $helper.curry6($f);
    case 7: macro $helper.curry7($f);
    default: Scuts.notImplemented();
  }

  /**
   * Returns the number of function parameters of the expression f.
   * If f does not represent a function, an error is thrown.
   */
  static function getFunctionParamsNum (f:Expr) 
  {
    var functionType = Tools.getType(f);
    
    return switch (functionType) 
    {
      case Some(t): switch (t) 
      {
        case TFun(params, _): params.length;
        default: RE.functionExprIsNotAFunction(f);
      }
      case Option.None: RE.functionExprCannotBeTyped(f);
    }
  }

  /**
   * The actual internal resolve implementation with the functionality described in resolve.
   */
  static function resolve1 (f:Expr, args:Array<Expr>, scopes:Scopes, lastNeeded:Array<Expr>, tagged:Bool = true)
  {    
    // some hacks and logging to circumvent some typing and inlining problems
    Assert.notNull(args);
    
    RL.startResolve(f, args);
    
    var f = Hacks.simplifyFunction(f, args);

    RL.afterSimplify(f);

    Hacks.checkIfArgsAreValid(f, args);
    
    // This is the real start point of the functionality
    
    var numParams = getFunctionParamsNum(f);
      
    // more parameters as function arguments, this is bad
    if (args.length > numParams) {
      RE.tooManyFunctionParams(f, args, numParams);
    }
    
    // adjust all parameters, which means apply casts if required
    var res = adjustArgs(f, args, numParams, scopes, lastNeeded, None);
    
    // create the function call expression
    var callExpr = Make.call(f, res._1, f.pos);
  
    // eventually apply a resulting cast
    var resultingExpr = switch (res._2) {
      case Upcast:   applyImplicitDowncast(callExpr,tagged);
      case Downcast: applyImplicitUpcast(callExpr,tagged);
      case None:  Hacks.makeTaggedCast(callExpr);
    }

    RL.resultingExpr(resultingExpr);
    
    return resultingExpr;
  }

  /**
   * Applies an implicit conversion (cast) 
   */
  static function applyImplicitCast(expr:Expr, method:String, tagged:Bool, ?canFail:Bool = false):Expr 
  {
    var expr = Hacks.makeTypeable(expr);
    
    function applyCast () 
    {
      var fieldExpr = Make.field(expr, method);

      var castCallExpr = macro $fieldExpr();
      
      var castApplicable = Tools.isTypeable(castCallExpr);
      
      RL.implicitCastApplication(expr, castCallExpr, castApplicable, method, canFail);
      
      return if (!castApplicable && canFail) 
        RE.castFailed(expr, method);
      else 
      {
        var usedExpr = if (castApplicable) castCallExpr else expr;
        if (tagged) Hacks.makeTaggedCast(usedExpr) else usedExpr;
      }
    }
    
    return if (Tools.exprTypeableAndTypeIsMono(expr)) expr else applyCast();
  }

  /**
   * returns a new expr with the parameter type (A) of the function expr e (A->B)
   */
  static function first (e :Expr):Expr {
    return macro $helper.first($e);
  }
  
  /**
   * Contains the actual loop over all parameters. 
   */
  static function adjustArgs (functionExpr:Expr, args:Array<Expr>, numParams:Int, 
    scopes:Scopes, lastRequired:Array<Expr>, argAdjustment:ArgumentAdjustment):Tup2<Array<Expr>, ArgumentAdjustment> 
  {
    // convert the function expr into a curried version
    var curried = curryFunctionExpr(functionExpr, numParams);
    // the resulting parameters
    var newArgs = [];
    // loop over all arguments of the function
    for (i in 0...numParams) 
    {
      // create an expr representing the required type
      var required = first(curried);
      // do we have an expression for this position
      var argExists = i < args.length;
      
      var adjustedArg = 
        if (argExists) // do we have an argument
        {
          // Adjust the argument if required
          var arg = args[i];
          adjustArg(arg, required, argAdjustment);  
        } // resolve Implicit
        else Tup2.create(resolveImplicitObj1(required, scopes, lastRequired), argAdjustment);
      
      
      var adjustedExpr = adjustedArg._1;
      // store upcasting direction
      argAdjustment = adjustedArg._2;
      newArgs.push(adjustedExpr);
      // next required Type
      curried = macro $curried($adjustedExpr);
    }
    // return resulting argumentlist and casting direction
    return Tup2.create(newArgs, argAdjustment);
  }
  
  /**
   * Applies an implicit conversion to the Argument Arg if it's type is not compatible. Adjustment is 
   * based on some rules in the following order:
   *  1. If the argument is compatible no conversion is applied
   *  2. if argAdjustment is None an upcast is tried, if it fails a downcast is done.
   *  3. If argAdjustment is either a downcast or an upcast, only the same operation is applied.
   */
  static function adjustArg (arg:Expr, required:Expr, argAdjustment:ArgumentAdjustment) 
  {
    function tryUpcast () 
    {
      var casted = macro $arg.implicitUpcast();
      return if (Tools.isCompatible(casted, required)) Some(Tup2.create(casted, Upcast)) else Option.None;
    }
    
    function tryDowncast () 
    {
      var casted = macro $arg.implicitDowncast();
      return if (Tools.isCompatible(casted, required)) Some(Tup2.create(casted, Downcast)) else Option.None;
    }
    
    function tryRegular () 
    {
      return if (Tools.isCompatible(arg, required)) Some(Tup2.create(arg, argAdjustment)) else Option.None;
    }
    
    function errorParamIncompatible () return RE.functionParameterIsIncompatible(arg, required);
    
    RL.adjustParameterInit(arg, required);

    return switch (argAdjustment) 
    {
      case Upcast:   tryRegular().orElse(tryUpcast).getOrElse(errorParamIncompatible);
      case Downcast: tryRegular().orElse(tryDowncast).getOrElse(errorParamIncompatible);
      case None:  tryRegular().orElse(tryUpcast).orElse(tryDowncast).getOrElse(errorParamIncompatible);
    }
  }
  
  static function checkForCircularDependency (required:Expr, lastRequired:Array<Expr>) 
  {
    if (lastRequired.length > 0) 
    {
      for ( i in lastRequired) 
      {
        var requiredAlreadySearched = Tools.isTypeable(macro $helper.sameType($required, $i));
        if (requiredAlreadySearched) RE.circularDependency(required, i);
      }
    }
  }
  
  
  /**
   * Internal function for the resolution of implicit objects.
   */
  static function resolveImplicitObj1 (required:Expr, scopes:Scopes, lastRequired:Array<Expr>) 
  {
    checkForCircularDependency(required, lastRequired);
    
    function getImplicitFromUsingContext () 
    {
      return switch (resolveImplicitInUsingContext(required, scopes, lastRequired)) 
      {
        case Success(s): s;
        case Failure(f): RE.invalidImplicitObjInScope(required);
      }
    }
    var found = resolveImplicitInLocalAndClassContext(required, scopes);
    
    return switch (found) 
    {
      case Success(s): switch (s) 
      {
        case Some(v): v.expr;
        case Option.None:    getImplicitFromUsingContext();
      }
      case Failure(f): RE.handleAmbiguityError(f);
    }
  }
  
  /**
   * resolves an implicit object in local, member and static context.
   */
  static function resolveImplicitInLocalAndClassContext (required:Expr, scopes:Scopes):Validation<AmbiguityError, Option<ScopeExpr>>
  {
    function findInLocalImplicits ():Option<ScopeExpr> 
    {
      for (localExpr in scopes.locals) 
      {
        if (Tools.isCompatible(localExpr, required)) 
        {
          return Some({ scope:Local, expr : localExpr });
        }
      }
      return None;
    }
    
    function findInClassImplicits (scopeExprs:Array<NamedExpr>, 
      err:Array<NamedExpr>->AmbiguityError, scope:Scope):Validation<AmbiguityError, Option<ScopeExpr>>
    {
      var found = [];

      for (m in scopeExprs) 
      {
        if (Tools.isTypeable(m.expr) && Tools.isCompatible(m.expr, required)) found.push(m);
      }
      return if (found.length == 1) Success( Some({ scope:scope, expr : found[0].expr }) )
      else   if (found.length > 1)  Failure(err(found))
      else                          Success(Option.None);
    }
    
    return 
     Success(findInLocalImplicits()) // search in locals
     .flatMap(function (x) return if (x.isNone()) findInClassImplicits(scopes.members, MembersAmbiguous, Member) else Success(x)) // search in members
     .flatMap(function (x) return if (x.isNone()) findInClassImplicits(scopes.statics, StaticsAmbiguous, Static) else Success(x)); // search in statics
  }

  /**
   * Internal function that resolves implicits from the using scope
   */
  static function resolveImplicitInUsingContext(required:Expr, scopes:Scopes, lastRequired:Array<Expr>):Validation<Expr, Expr>
  {
    
    //trace("start resolve");
    
    var usings = Context.getLocalUsing();
    
    var res = [];
    
    for (u in usings) {
      var cl = u.get();
      var statics = cl.statics.get();
      var filtered = statics.filter(function (x) return x.isPublic && x.meta.has(":implicit"));
      for (f in filtered) {
        res.push( { cl:cl, field: f } );
      }
      
    }
    
    //Tools.printExpr(required);
    
    for ( r in res) {
      var e = r.cl.module + "." + r.cl.name + "." + r.field.name;
      //trace(e);
      //trace(r.field.type);
      var parsed = Context.parse(e, r.cl.pos);
      
      switch (r.field.type) {
        case TInst(t,p):
          
          //var cur = parsed;
          //var req = required;
          var cur = macro $helper.toImplicitObject($parsed);
          var req = macro $helper.toImplicitObject($required);
          var isComp = Tools.isCompatible( cur, req);
          
          
          
          //Tools.printTypeOfExpr(cur);
          //Tools.printTypeOfExpr(req);
          if (isComp) {
            //trace("isComp:");
            
            //Tools.printTypeOfExpr(parsed);
            //Tools.printTypeOfExpr(required);
            return Success(parsed);
          }
          
        case TFun(args, ret):
          //trace(args.length);
          var check = switch (args.length) {
            case 0: macro $helper.ret0($parsed);
            case 1: macro $helper.ret1($parsed);
            case 2: macro $helper.ret2($parsed);
            case 3: macro $helper.ret3($parsed);
            case 4: macro $helper.ret4($parsed);
            case 5: macro $helper.ret5($parsed);
            case 6: macro $helper.ret6($parsed);
            default: trace("error");  Scuts.notImplemented();
          }
          
          
          
          var isComp = Tools.isCompatible(macro $helper.toImplicitObject($check), macro $helper.toImplicitObject($required));
          if (isComp) {
            
            var typed = switch (args.length) {
              case 0: macro $helper.typed0($parsed, $required);
              case 1: macro $helper.typed1($parsed, $required);
              case 2: macro $helper.typed2($parsed, $required);
              case 3: macro $helper.typed3($parsed, $required);
              case 4: macro $helper.typed4($parsed, $required);
              case 5: macro $helper.typed5($parsed, $required);
              case 6: macro $helper.typed6($parsed, $required);
              default: trace("error"); Scuts.notImplemented();
            }
            return Success(if (args.length == 0) macro $parsed() else resolve1(typed, [], scopes, lastRequired.concat([required]),false));

          }
        default: 
          
      }
      
    }
    
    //trace("not found");
    
    //trace(res);
    
    
    // Converts an Expr with Type X to an Expr with Type ImplicitObject<X>
    var requiredAsImplicit = macro $helper.toImplicitObject($required);
    
    var implicitObjField = macro $requiredAsImplicit.implicitObj;

    function resolveImplicitWithoutDependecies() 
    {
      // implicitExpr ("toImplicit(required).implicitObj()") is the required Expression that return the correct implicit Object 
      var implicitExpr = (macro $implicitObjField());
      // Check if the Return type of the implicitObj function has the expected type, which means the definition is valid
      return 
        if (Tools.isCompatible(implicitExpr,required)) implicitExpr
        else RE.implicitObjectDefinitionIsIncorrect(implicitExpr, required);
    }
    
    function resolveImplicitWithDependecies() 
    {
      // log
      RL.implicitObjectDependencies(implicitObjField, required);
      // recursive call to resolve1 to resolve dependencies of the implicit object
      return resolve1(implicitObjField, [], scopes, lastRequired.concat([required]),false);
    }
    
    // Check if the expr "toImplicit(required).implicitObj" is typeable, which means there exists an Implicit Object
    // Tools.getType must return an Option.Some
    var r2 = switch (Tools.getType(implicitObjField))
    {
      // The expr "toImplicit(required).implicitObj" must be a function.
      case Some(t): switch (t)
      {
        case TFun(args, _): 
          // if the function takes parameters, resolve dependencies
          if (args.length == 0) resolveImplicitWithoutDependecies() else resolveImplicitWithDependecies();
        default: 
          // "toImplicit(required).implicitObj" is typeable, but it is not a function definition, should never happen
          RE.invalidImplicitObjFunction();
      }
      case Option.None:
        // No implicit Object in using Context
        RE.noImplicitObjectInContext(required);
    }
    return if (Tools.isCompatible(r2, required)) Success(r2) else Failure(r2);
  }
  
}


#end
