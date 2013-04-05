package scuts.ht.macros.implicits;

#if macro

// unwanted dependecies


import haxe.ds.StringMap;
import haxe.macro.ExprTools;
import haxe.macro.TypeTools;
import scuts.ht.macros.implicits.Cache;
import scuts.core.debug.Assert;
import scuts.ht.macros.implicits.Typer;
import scuts.Scuts;
import haxe.CallStack;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.PosInfos;
import scuts.ht.macros.implicits.Data;

import scuts.core.Tuples.*;
import scuts.core.Tuples;

 

import scuts.ht.macros.implicits.Data;

using scuts.core.Strings;

using scuts.core.Arrays;
using scuts.core.Validations;
using scuts.core.Options;
using scuts.core.Functions;



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
      //trace("try resolve");
      var res = resolveImplicitObj(required);
      return res;
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

  static var resolveCache = new Cache();
  public static function resolve (f:Expr, args:Array<Expr>) // f is String -> Monoid<T> -> Bool
  {
    var id = Context.signature([f, args]);
    if (resolveCache.exists(id)) return resolveCache.get(id);
    
    //trace("--------------------------------------");
    /*
    var valid = switch (f.expr) {
      case EConst(CIdent("__z")): true;
      case _ : false;
    }

    trace(valid);

    if (!valid) {
      args.unshift(macro __z);
      return macro ({
        var __z = $f;
        scuts.ht.core.Hots.resolve($a{args});
      });
    }
  */

    if (args == null) args = [];


    //trace(haxe.macro.ExprTools.toString(f));
    //trace(Context.typeof(f));
    //trace(ExprTools.toString(f));
    //var typeableArgs = args.map(Hacks.makeTypeable);
    var typeableArgs = args;
    return resolveCache.set(id, try 
    {
      
      resolve1(f, typeableArgs, Manager.getImplicitsFromScope(), []);
    } 
    catch (e:Error) 
    {
      Scuts.warning("Resolver Error", e.message);
      { expr : ECall(f, args), pos: Context.currentPos()};
    });
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
  public static var helper(default, null) = (macro scuts.ht.macros.implicits.Helper);
  


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

  static var resolve1Cache = new Cache();

  /**
   * The actual internal resolve implementation with the functionality described in resolve.
   */
  static function resolve1 (f:Expr, args:Array<Expr>, scopes:Scopes, lastNeeded:Array<Expr>, tagged:Bool = true)
  {    
    var id = Context.signature([f, args, lastNeeded, tagged]);
    if (resolve1Cache.exists(id)) return resolve1Cache.get(id);


    var isBind = false;
    // trace("----r1");
    // trace(args.map(ExprTools.toString));
    // trace(ExprTools.toString(f));
    // trace(TypeTools.toString(Context.typeof(f)));
    //trace(Context.typeof(f));
    // some hacks and logging to circumvent some typing and inlining problems
    Assert.notNull(args);
    
    //trace(haxe.macro.ExprTools.toString(f));
   
    RL.startResolve(f, args);
    
    //var f = Hacks.simplifyFunction(f, args);
    //trace(ExprTools.toString(f));
    //trace(Context.typeof(f));

    RL.afterSimplify(f);

    //Hacks.checkIfArgsAreValid(f, args);
    
    // This is the real start point of the functionality
    
    if (args.length > 0) {
      // trace(haxe.macro.ExprTools.toString(args[0]));
      // trace(Print.expr(args[0]));
      // trace(haxe.macro.TypeTools.toString(Context.typeof(args[0])));
      
    }
    

    var numParams = getFunctionParamsNum(f);
      
    // more parameters as function arguments, this is bad
    if (args.length > numParams) {
      RE.tooManyFunctionParams(f, args, numParams);
    }
    for (a in args) {
      if (!isBind) {
        isBind = switch (a.expr) {
          case EConst(CIdent("_")): true;
          case _ : false;
        }
      }
    }
    
    //trace(Context.typeof(f));

    // adjust all parameters, which means apply casts if required
    var res = adjustArgs(f, args, numParams, scopes, lastNeeded, None);
    

    f = isBind ? macro ($f).bind : f;
    // create the function call expression
    //var callExpr = Make.call(f, res._1, f.pos);
    var callExpr = macro @:pos(f.pos) $f($a{res._1});
  
    // eventually apply a resulting cast
    
    var resultingExpr = callExpr;

    RL.resultingExpr(resultingExpr);
    // trace("----r1 - end");
    // trace(TypeTools.toString(Context.typeof(f)));

    resolve1Cache.set(id, resultingExpr);

    //trace(ExprTools.toString(resultingExpr));

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
      return Scuts.error("casts are invalid");
      
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
      var cur = first(curried);
      var required = Typer.tryFastTypeable(cur);
      // switch (Context.typeof(required)) {
      //   case TMono(_): Scuts.error("Cannot apply a parameter to an unknown type");
      //   case _: 
      // }
      // do we have an expression for this position
      var argExists = i < args.length;
      
      var adjustedArg = 
        if (argExists) // do we have an argument
        {
          // Adjust the argument if required
          var arg = args[i];

          adjustArg(arg, required, argAdjustment);  
        } // resolve Implicit
        else 
        {
          if (Context.defined("display")) {
            tup3(macro null, macro null, argAdjustment);
          } else {
            var impExpr = resolveImplicitObj1(required, scopes, lastRequired);
            tup3(impExpr, impExpr, argAdjustment);
          }
        }
      
      
      var adjustedExpr = adjustedArg._2;
      var typeExpr = adjustedArg._1;
      // store upcasting direction
      argAdjustment = adjustedArg._3;
      newArgs.push(adjustedExpr);
      // next required Type
      curried = macro $curried($typeExpr);
    }
    // return resulting argumentlist and casting direction
    return tup2(newArgs, argAdjustment);
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
    
    function tryRegular () 
    {
      return switch (arg.expr) {
        case EConst(CIdent("_")): Some(tup3(macro null, arg, argAdjustment));
        case _ : if (Tools.isCompatible(arg, required)) Some(tup3(arg, arg, argAdjustment)) else Option.None;
      }
      
    }
    
    function errorParamIncompatible () return RE.functionParameterIsIncompatible(arg, required);
    
    RL.adjustParameterInit(arg, required);

    return switch (argAdjustment) 
    {
      case Upcast:   tryRegular().getOrElse(errorParamIncompatible);
      case Downcast: tryRegular().getOrElse(errorParamIncompatible);
      case None:     tryRegular().getOrElse(errorParamIncompatible);
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
  
  static var impObj1Cache = new Cache();
  /**
   * Internal function for the resolution of implicit objects.
   */
  static function resolveImplicitObj1 (required:Expr, scopes:Scopes, lastRequired:Array<Expr>) 
  {
    var id = Context.signature([required, scopes, lastRequired]);
    if (impObj1Cache.exists(id)) return impObj1Cache.get(id);

    
    checkForCircularDependency(required, lastRequired);
    
    function getImplicitFromUsingContext () 
    {
      return switch (resolveImplicitInUsingContext(required, scopes, lastRequired)) 
      {
        case Success(s): s;
        case Failure(_): RE.invalidImplicitObjInScope(required);
      }
    }

    //trace("type" + Context.typeof(required));
    switch (Typer.typeof(required)) {
      case TAnonymous(_):

        //Scuts.error("Implicit Anonymous Objects are ot yet supported");
      case _: 

    }

    var found = resolveImplicitInLocalAndClassContext(required, scopes);
    
    var res = switch (found) 
    {
      case Success(Some(v)): v.expr;
      case Success(None) : getImplicitFromUsingContext();
      case Failure(f): RE.handleAmbiguityError(f);
    }
    
    return impObj1Cache.set(id, res);
    
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

  static var implicitCache = new Cache();
  static function resolveImplicitInUsingContext(required:Expr, scopes:Scopes, lastRequired:Array<Expr>):Validation<Expr, Expr>
  {
    //trace("--------------start-----------------------");
    //trace("start resolve@" + Context.currentPos());
    
    //Tools.printTypeOfExpr(required);

    var usings = Context.getLocalUsing();
    
    //trace(usings);

    var res = [];
    
    for (u in usings) {

      var cl = u.get();

      if (!implicitCache.exists(cl.module + "_" + cl.name)) {
        var cache = [];
        var statics = cl.statics.get();
        var filtered = statics.filter(function (x) return x.isPublic && x.meta.has(":implicit"));
        for (f in filtered) {
          var e = cl.module + "." + cl.name + "." + f.name;
          var parsed = Context.parse(e, cl.pos);
          cache.push({ cl:cl, field: f, parsed : parsed });
          res.push( { cl:cl, field: f, parsed : parsed } );
        }
        implicitCache.set(cl.module + "_" + cl.name, cache);
      } else {
        
        for (r in implicitCache.get(cl.module + "_" + cl.name)) {
          res.push(r);
        }
        
        
      }
      
    }
    
    //Tools.printExpr(required);
    
    for ( r in res) {
      
      
      //trace(e);
      //trace(r.field.type);
      var parsed = r.parsed;
      
      function findIn (t:Type) {

        switch (t) {
          case TLazy(x): return findIn(x());
          case TInst(_,_):
            
            //var cur = parsed;
            //var req = required;
            var cur = macro $helper.toImplicitObject($parsed);
            var req = macro $helper.toImplicitObject($required);

            //Tools.printTypeOfExpr(cur);
            //Tools.printTypeOfExpr(req);

            // Tools.printTypeOfExpr(parsed);
            // Tools.printTypeOfExpr(cur);

            // Tools.printTypeOfExpr(req);

            var isComp = Tools.isCompatible( cur, req);
            
            //trace("isComp=" + isComp);
            
            //Tools.printTypeOfExpr(cur);
            //Tools.printTypeOfExpr(req);
            if (isComp) {
              //trace("isComp:");
              //trace("isComp@" + Context.currentPos());
              //trace(e);
              //Tools.printTypeOfExpr(required);
              return Success(parsed);
            }
            
          case TFun(args, _):
            //trace("check Func");
            //trace("try " + e);
            //trace(args.length);
            var check = switch (args.length) {
              case 0: macro $helper.ret0($parsed);
              case 1: macro $helper.ret1($parsed);
              case 2: macro $helper.ret2($parsed);
              case 3: macro $helper.ret3($parsed);
              case 4: macro $helper.ret4($parsed);
              case 5: macro $helper.ret5($parsed);
              case 6: macro $helper.ret6($parsed);
              case _: trace("error");  Scuts.notImplemented();
            }

            
            //Tools.printTypeOfExpr(macro $helper.toImplicitObject($check));
            //Tools.printTypeOfExpr(macro $helper.toImplicitObject($required));
            
            var isComp = Tools.isCompatible(macro $helper.toImplicitObject($check), macro $helper.toImplicitObject($required));
            if (isComp) {
              //trace("isComp@" + Context.currentPos());
              var typed = switch (args.length) {
                case 0: macro $helper.typed0($parsed, $required);
                case 1: macro $helper.typed1($parsed, $required);
                case 2: macro $helper.typed2($parsed, $required);
                case 3: macro $helper.typed3($parsed, $required);
                case 4: macro $helper.typed4($parsed, $required);
                case 5: macro $helper.typed5($parsed, $required);
                case 6: macro $helper.typed6($parsed, $required);
                case _: trace("error"); Scuts.notImplemented();
              }
              return Success(if (args.length == 0) macro $parsed() else resolve1(typed, [], scopes, lastRequired.concat([required]),false));

            }
          default: 
            
        }
        return null;  
      }
      var res = findIn(r.field.type);
      if (res != null) return res;
      
    }

    
    //trace("found nothing in using");
    //Tools.printTypeOfExpr(required);
    //trace("------------end---------------");
    
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
