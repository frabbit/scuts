package scuts.ht.macros.implicits;

#if macro

import haxe.ds.StringMap;

import haxe.macro.ExprTools;
import haxe.macro.TypeTools;
import haxe.Timer;
import neko.Lib;
import scuts.core.Bools;
import scuts.ht.macros.implicits.Cache;
import scuts.core.debug.Assert;
import scuts.ht.macros.implicits.Errors;
import scuts.ht.macros.implicits.Profiler;
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


import scuts.ht.macros.implicits.Errors.ResolverError;

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

private typedef R = RealResolver;
private typedef RE = Errors;
private typedef RL = Log;




class RealResolver
{


  //static function addResolveTime (id:String, time:Float) {
  //  return Profiler.addTime("Resolver." + id, time);
  //}

  /**
   * Returns an Expression representing the implicit Object for the given type t.
   * The type is encoded as a string, because something like Array<Int> is not a valid expression.
   */
  public static function resolveImplicitObjByType (t:String):Expr
  {
    return Profiler.profile(function () {
      return try
      {
        var required = Context.parse(" { var e : " + t + " = null; e; } ", Context.currentPos());
        var res = switch (resolveImplicitObj1(required, Manager.getImplicitsFromScope(), [])) {
          case Success(e): e;
          case Failure(f): Scuts.error(f);
        }
        res;
      }
      catch (e:Dynamic) Scuts.error(ErrorPrinter.toString(RE.invalidType(t)));
    });
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
  static var calls = 0;


  static function isMacroCall (f:Expr) {
    return try {
      Context.typeof(f);
      return false;
    } catch (e:haxe.macro.Expr.Error) {

      if (e.message == "Macro functions must be called immediately") {
        true;
      } else {
        false;
      }

    }
  }


  public static function resolve (f:Expr, args:Array<Expr>, ?numArgs:Int = -1)
  {
    if (args == null) throw "args should not be null";
    //trace("------------- start");
    //trace(ExprTools.toString(macro $f($a{args}) ));
    return Profiler.profile(function ()
    {
      return if (isMacroCall(f)) {
        macro $f($a{args});
      } else {



        Profiler.push("check-args");
        if (args == null) args = [];

        numArgs = if (numArgs == -1 && args.length > 0) switch (args[args.length-1].expr)
        {
          case EMeta(m, {expr:EConst(CInt(x))}) if (m.name == ":resolveParamsCount"):
            args.pop();
            Std.parseInt(x);
          case _ : -1;
        }
        else numArgs;
        Profiler.pop();

        function resolveRegular ()
        {
          return Profiler.profile(function () return switch (resolve1(f,f, args, Manager.getImplicitsFromScope(), [], numArgs))
          {
            case Success(e):
              //trace(ExprTools.toString(e));
              e;
            case Failure(err):
              var pos = Std.string(Context.getPosInfos(f.pos));
              var msg = "Resolver Error for Expr: " + ExprTools.toString(macro $f($a{args})) + " at " + pos + "\n" + ErrorPrinter.toString(err);
              //Scuts.error(msg);
              Context.warning(msg, f.pos);
              { expr : ECall(f, args), pos: Context.currentPos()};
          }, "resolveRegular");
        }



        var outsourceFirstArg = if (args.length > 0) switch (args[0].expr)
        {
          case EConst(_) | EField({expr:EConst(_)}, _) | EFunction(_,_): false;
          case _ : true;
        } else false;

        //trace(ExprTools.toString(f));
        var outsourceFunc = switch (f.expr) {

          case EBlock(_) | EParenthesis({ expr : EBlock(_) | ECall(_)}) | ECall(_): true;
          case _ : false;
        }
        //trace("------------- pre return");
        return Profiler.profile(function () return if (outsourceFirstArg || outsourceFunc)
        {
          var p = Context.currentPos();

          var newArgs = [];

          newArgs.push(if (outsourceFunc) macro @:pos(p) __f1 else f);

          if (outsourceFirstArg) newArgs.push(macro @:pos(p) __a1);

          var startIndex = if (outsourceFirstArg) 1 else 0;

          for (i in startIndex...args.length) newArgs.push(args[i]);

          // pass the param count of function f to the runtime and catch it like above, so we don't have to type the function (could be expensive)
          if (numArgs != -1) newArgs.push(macro @:resolveParamsCount $v{numArgs});


          var blockExprs = [];

          if (outsourceFunc) blockExprs.push(macro @:pos(p) var __f1 = $f);
          if (outsourceFirstArg) blockExprs.push(macro @:pos(p) var __a1 = ${args[0]});

          blockExprs.push(macro scuts.ht.core.Ht.resolve($a{newArgs}));

          var res = macro @:pos(p) $b{blockExprs};
          //trace(ExprTools.toString(res));
          res;
        } else {
          //trace("------------- pre regular");
          var r = resolveRegular();
          //trace("------------- after regular");
          //trace(ExprTools.toString(r));
          return macro @:allowPrivate $r;
        }, "outsource complex expressions");

      }
    });

  }



  /**
   * Returns an expression representing an Implicit Object with the same type as
   * the expression required.
   */
  public static function resolveImplicitObj (required:Expr)
  {
    return Profiler.profile(function () {
      return switch (resolveImplicitObj1(required, Manager.getImplicitsFromScope(), [])) {
        case Success(e): e;
        case Failure(f): Scuts.warning("error", Std.string(f));
      }
    });
  }

  // internal functions

  /**
   * Shortcut for referencing the Helper class, which is used for a lot of Expression Manipulation.
   * Should have package wide visibility, but this is currently not possible in haxe.
   */
  public static var helper(default, null) = (macro scuts.ht.macros.implicits.Helper);

  //public static var helper(default, null) = (macro HI1);

  /**
   * Returns the number of function parameters of the expression f.
   * If f does not represent a function, an error is thrown.
   */
  static function getFunctionParamsNum (f:Expr):Validation<ResolverError, Int>
  {
    return Profiler.profile(function ()
    {
      return switch (Typer.typeof(f))
      {

        case Some(TFun(params, _)): Success(params.length);
        case Some(_): Failure(RE.functionExprIsNotAFunction(f));
        case None: Failure(RE.functionExprCannotBeTyped(f));
      }
    });
  }

  static var resolve1Cache = new Cache();

  /**
   * The actual internal resolve implementation with the functionality described in resolve.
   */
  static function resolve1 (f:Expr, funtyped:Expr, args:Array<Expr>, scopes:Scopes, lastNeeded:Array<Expr>, numArgs:Int = -1):Validation<ResolverError, Expr>
  {
    //trace(Tools.prettyTypeOfExpr(f));
    //trace(Tools.prettyTypeOfExpr(funtyped));
    return Profiler.profile(function ()
    {

      Assert.notNull(args);

      RL.startResolve(f, args);



      var numFunctionParams = if (numArgs == -1) getFunctionParamsNum(f) else Success(numArgs);

      return switch (numFunctionParams)
      {
        case Success(numParams) if (args.length > numParams):
          // more parameters as function arguments, this is bad
          Failure(RE.tooManyFunctionParams(f, args, numParams));

        case Success(numParams):
          // adjust all parameters, which means apply casts if required

          switch (adjustArgs(f, args, numParams, scopes, lastNeeded)) {
            case Success(res):
              var isBind = args.foldLeft(false,
                function (acc, e) return acc || switch (e.expr)
                {
                  case EConst(CIdent("_")):  true;
                  case _ : false;
                }
              );

              var fn = isBind ? macro ($funtyped).bind : funtyped;
              var callExpr = macro @:pos(funtyped.pos) $fn($a{res});
              RL.resultingExpr(callExpr);

              Success(callExpr);
            case Failure(f):
              Failure(f);
          }

        case Failure(f):
          Failure(f);
      };
    });
  }


  /**
   * returns a new expr with the parameter type (A) of the function expr e (A->B)
   */
  static inline function  first (e :Expr):Expr {
    return macro $helper.first($e);
  }

  /**
   * Contains the actual loop over all parameters.
   */

  static function adjustArgs (functionExpr:Expr, args:Array<Expr>, numParams:Int,
    scopes:Scopes, lastRequired:Array<Expr>):Validation<ResolverError, Array<Expr>>
  {
    var argLen = args.length;
    var nullMacro = macro null;
    function foldArgs(acc:Validation<ResolverError, Tup2<Array<Expr>, Expr>>, i:Int) return Profiler.profile(function () return switch (acc)
    {
      case Success(st):
        var newArgs = st._1;
        var curried = st._2;
        // replace placeholders with null, we need a function with exactly one
        // parameter and as much as possible arguments applied.
        Profiler.push("expandArgs");
        var newArgsExpanded = newArgs.map(function (a) {
          return switch (a.expr) {
            case EConst(CIdent("_")): nullMacro;
            case _ : a;
          }
        });

        newArgsExpanded.push(macro _);
        for (j in i+1...numParams) {
          newArgsExpanded.push(nullMacro);
        }
        Profiler.pop();
        Profiler.push("makeHelperExpr");
        // create an expr representing the required type
        var cur = first(curried);
        var partial = macro $curried.bind($a{newArgsExpanded});


        var required = macro $helper.first($partial);
        Profiler.pop();

        // do we have an expression for this position

        var argExists = i < argLen;

        var adjustedArgVal = Profiler.profile(function () {
          return if (argExists) // do we have an argument
            adjustArg(args[i], required);
          else
          {
            if (Context.defined("display"))
              Success(tup2(macro null, macro null));
            else switch (resolveImplicitObj1(required, scopes, lastRequired))
            {
              case Success(impExpr): Success(tup2(impExpr, impExpr));
              case Failure(f): Failure(f);
            }
          }
        }, "adjustArg");
        Profiler.profile(function () {
          return switch (adjustedArgVal)
          {
            case Success(adjustedArg):
              var adjustedExpr = adjustedArg._2;
              var typeExpr = adjustedArg._1;

              newArgs.push(adjustedExpr);

              //curried = macro $curried($typeExpr);

              Success(tup2(newArgs, curried));
            case Failure(f):
              Failure(f);
          }
        }, "extractAdjustedArg");
      case Failure(f):
        Failure(f);
    },"foldArgs");

    return Profiler.profile(function ()
    {
      //var curried = curryFunctionExpr(functionExpr, numParams);

      var indices = [for (i in 0...numParams) i];
      var res = Profiler.profile(function () return indices.foldLeft(Success(tup2([], functionExpr)), foldArgs), "foldLeft");

      return res.map(Tup2s.first);
    });

  }


  static function adjustArg (arg:Expr, required:Expr):Validation<ResolverError, Tup2<Expr, Expr>>
  {
    return Profiler.profile(function ()
    {
      return switch (arg.expr)
      {
        case EConst(CIdent("_")): Success(tup2(macro null, arg));
        case _: Success(tup2(arg, arg));
      }
    });
  }

  static inline function sameType (a:Expr,b:Expr) {
    return Typer.isTypeable(macro $helper.sameType($a, $b));
   }

  static function checkForCircularDependency (required:Expr, lastRequired:Array<Expr>):Option<ResolverError>
  {
    return Profiler.profile(function ()
    {
      return lastRequired.some(sameType.bind(required, _)).map(RE.circularDependency.bind(required, _));
    });

  }

  static var impObj1Cache = new Cache();

  /**
   * Internal function for the resolution of implicit objects.
   */

  static function resolveImplicitObj1 (required:Expr, scopes:Scopes, lastRequired:Array<Expr>):Validation<ResolverError, Expr>
  {
    //trace(Tools.prettyExpr(required));
    //trace(Tools.prettyTypeOfExpr(required));
    return Profiler.profile(function ()
    {

      function getImplicitFromUsingContext ()
      {
        return Profiler.profile(function ()
        {
          return switch (resolveImplicitInUsingContext(required, scopes, lastRequired))
          {
            case Success(s): Success(s);
            case Failure(f):
              //trace(Tools.prettyTypeOfExpr(required));
              //trace(Tools.prettyExpr(required));
              Failure(RE.invalidImplicitObjInScope(required, f));
          }
        },"getImplicitFromUsingContext");
      }

      function doResolve ()
      {
        return Profiler.profile(function ()
        {
          var found = resolveImplicitInLocalAndClassContext(required, scopes);
          var res = switch (found)
          {
            case Success(Some(v)): Success(v.expr);
            case Success(None) : getImplicitFromUsingContext();
            case Failure(f): Failure(ImplicitAmbiguityError(f));
          }
          Profiler.pushPop("set-cache");
          //return impObj1Cache.set(id, res);
          return res;
        }, "doResolve");
      }

      return /*if (impObj1Cache.exists(id))
      {
        Profiler.pushPop("use-cache");
        impObj1Cache.get(id);
      }
      else */
      {
        Profiler.pushPop("no-cache");
        checkForCircularDependency(required, lastRequired).map(Failure).getOrElse(doResolve);
      };

    });



  }

  /**
   * resolves an implicit object in local, member and static context.
   */
  static function resolveImplicitInLocalAndClassContext (required:Expr, scopes:Scopes)
    :Validation<AmbiguityError, Option<ScopeExpr>>
  {
    function findInLocalImplicits ():Option<ScopeExpr>
    {
      for (localExpr in scopes.locals)
      {
        if (Typer.isCompatible(localExpr, required))
        {
          return Some({ scope:Local, expr : localExpr });
        }
      }
      return None;
    }

    function findInClassImplicits (scopeExprs:Array<NamedExpr>, err:Array<NamedExpr>->AmbiguityError,
      scope:Scope):Validation<AmbiguityError, Option<ScopeExpr>>
    {
      var found = [];

      for (m in scopeExprs)
      {
        if (Typer.isTypeable(m.expr) && Typer.isCompatible(m.expr, required)) found.push(m);
      }

      var len = found.length;

      return if (len == 1) Success( Some({ scope:scope, expr : found[0].expr }) )
      else   if (len  > 1) Failure(err(found))
      else                 Success(Option.None);
    }

    return
     Success(findInLocalImplicits()) // search in locals
     .flatMap(function (x) return if (x.isNone()) findInClassImplicits(scopes.members, MembersAmbiguous, Member) else Success(x)) // search in members
     .flatMap(function (x) return if (x.isNone()) findInClassImplicits(scopes.statics, StaticsAmbiguous, Static) else Success(x)); // search in statics
  }

  static var implicitCache:Cache<StringMap<Array<{ parsed : haxe.macro.Expr, field : haxe.macro.ClassField, cl : haxe.macro.ClassType, followedType:Option<Type> }>>> = new Cache();

  static function exprTypeHashes(parsed:Expr):Array<String> return switch (Typer.typeof(parsed))
  {
    case Some(t):
      var type = Context.follow(t);
      exprTypeHashesFromType(type);
    case None:
      ["3_Fallbacks"];
  }

  static function exprTypeHashesFromOptionType(type:Option<Type>):Array<String> return switch (type)
  {
    case Some(t):
      var type = Context.follow(t);
      exprTypeHashesFromType(type);
    case None:
      ["3_Fallbacks"];
  }

  static function exprTypeHashesFromType(type:Type):Array<String>
  {
    var hashes = switch (type)
    {
      case TInst(t,p):
        var cl = t.get();
        var clId = "10_TInst_" + cl.module + "." + cl.name;

        if (p.length > 0) switch (Context.follow(p[0]))
        {
          case TInst(t2, _):
            var cl2 = t2.get();
            var res = [ "00_TInst_TInst_" + cl.module + "." + cl.name + "_" + cl2.module + "." + cl2.name, clId ];


            res;

          case TEnum(t2, _):
            var cl2 = t2.get();
            [ "01_TInst_TEnum_" + cl.module + "." + cl.name + "_" + cl2.module + "." + cl2.name, clId ];

          case TAbstract(t2, _):
            var cl2 = t2.get();
            [ "02_TInst_TAbstract_" + cl.module + "." + cl.name + "_" + cl2.module + "." + cl2.name, clId ];

          case _ : [clId];
        }
        else
        {
          [clId];
        }
      case _ :
        ["20_Other_"];
    }

    return hashes.concat(["30_Fallbacks"]);
  }

  static function getImplicitExprTypeHashes(parsed:Expr):{ followedType:Option<Type>, hashes : Array<String> } return switch (Typer.typeof(parsed))
  {
    case Some(t): switch (Context.follow(t))
    {
      case TFun(_, ret) if (ret != null):
        //trace(TypeTools.toString(Context.follow(ret)));
        //trace(TypeTools.toString(ret));
        { followedType : None,  hashes : exprTypeHashesFromType(Context.follow(ret)) };
      case type :

        { followedType : Some(type), hashes : exprTypeHashesFromType(type) };
    }
    case None: { followedType : None, hashes : ["3_Fallbacks"] };
  }

  static inline function getUsingsId (usings:Array<Null<Ref<ClassType>>>)
  {
    return usings.join("_");
  }

  static inline function getRequiredTypeAndUsingId (requiredTypeId:String, usingsId:String)
  {
    return requiredTypeId + "_using_" + usingsId;
  }


  static function getPublicStaticClassImplicits (cl:ClassType)
  {
    var cache:StringMap<Array<{ parsed : Expr, field : ClassField, cl : ClassType, followedType : Option<Type> }>> = new StringMap();

    var statics = cl.statics.get();
    var filtered = statics.filter(function (x) return x.isPublic && x.meta.has(":implicit"));
    for (f in filtered)
    {

      //var e = if (cl.module == cl.name || StringTools.endsWith(cl.module, "." + cl.name)) cl.module + "." + f.name else cl.module + "." + cl.name + "." + f.name;
      var e = cl.module + "." + cl.name + "." + f.name;
      //trace(e);

      var parsed = Typer.makeFastTypeable(Context.parse(e, cl.pos));
      var hashAndType = getImplicitExprTypeHashes(parsed);
      // trace(hashAndType);
      var hashes = hashAndType.hashes;

      var data = { cl:cl, field: f, parsed : parsed, followedType : hashAndType.followedType };
      for (h in hashes)
      {
        if (cache.exists(h)) cache.get(h).push(data)
        else cache.set(h, [data]);
      }
    }

    return cache;
  }

  static function cacheUsingClasses (usings:Array<Null<Ref<ClassType>>>)
  {
    for (u in usings)
    {
      var cl = u.get();
      if (!implicitCache.exists(cl.module + "_" + cl.name))
      {
        implicitCache.set(cl.module + "_" + cl.name, getPublicStaticClassImplicits(cl));
      }
    }
  }

  static function getUsingContext (required:Expr, usings:Array<Null<Ref<ClassType>>>, usingsId:String)
  {
    return Profiler.profile(function ()
    {
      cacheUsingClasses(usings);

      var requiredType = Typer.typeof(required);

      var requiredHashes = exprTypeHashesFromOptionType(requiredType);


      var res1:StringMap<Array<{ parsed : Expr, field : ClassField, cl : ClassType, followedType : Option<Type> }>> = new StringMap();
      for ( u in usings)
      {

        var cl = u.get();

        var cacheData = implicitCache.get(cl.module + "_" + cl.name);


        for (h in requiredHashes)
        {
          if (cacheData.exists(h))
          {
            if (res1.exists(h))
            {
              var h1 = res1.get(h);
              var vals = cacheData.get(h);

              h1 = h1.concat(vals);
              res1.set(h, h1);
            }
            else
            {
              res1.set(h, cacheData.get(h));
            }
          }
        }
      }

      var sortedKeys = [for (k in res1.keys()) k ];
      sortedKeys.sort(Strings.compareInt);

      var res = sortedKeys.foldLeft([], function (acc, cur) return acc.concat(res1.get(cur)));

      var result = { requiredType : requiredType, res : res, requiredHashes : requiredHashes };
      //trace(result.res.map(function (x) return ExprTools.toString(x.parsed)));
      return result;
    });
  }

  static var usingCtxFirstLevelCache = new Cache();

  static inline function asImplicitObject (e:Expr)
  {
    return macro $helper.toImplicitObject($e);
  }

  static function resolveImplicitUsingObject (parsed:Expr, required:Expr, requiredType:Option<Type>)
  {
    return Profiler.profile(function ()
    {
      var cur = asImplicitObject(parsed);
      var req = asImplicitObject(required);
      /*trace(ExprTools.toString(cur));
      trace(ExprTools.toString(req));*/
      var isComp = Typer.isCompatible( cur, req);

      return if (isComp) Some(parsed) else Option.None;
      /*switch (requiredType) {
        case TInst(cl,_):
          var cls = cl.get();
          if (cl.module == "scuts.ht.core.Of" && cl.name =="Of") {
            var cur = asImplicitObject(parsed);
            var req = asImplicitObject(required);
            // trace(ExprTools.toString(cur));
            // trace(ExprTools.toString(req));
            var isComp = Typer.isCompatible( cur, req);
          }
        case _ : Option.None;*/
    });
  }


  static function makeFunctionExprReturnTypeConcrete (f:Expr, returnType:Expr, numArgs:Int)
  {
    return switch (numArgs)
    {
      case 0: macro $helper.typed0($f, $returnType);
      case 1: macro $helper.typed1($f, $returnType);
      case 2: macro $helper.typed2($f, $returnType);
      case 3: macro $helper.typed3($f, $returnType);
      case 4: macro $helper.typed4($f, $returnType);
      case 5: macro $helper.typed5($f, $returnType);
      case 6: macro $helper.typed6($f, $returnType);
      case _: Scuts.notImplemented();
    }
  }
  static function getFunctionExprReturnType (f:Expr, numArgs:Int)
  {
    return switch (numArgs)
    {
      case 0: macro $helper.ret0($f);
      case 1: macro $helper.ret1($f);
      case 2: macro $helper.ret2($f);
      case 3: macro $helper.ret3($f);
      case 4: macro $helper.ret4($f);
      case 5: macro $helper.ret5($f);
      case 6: macro $helper.ret6($f);
      case _: Scuts.notImplemented();
    }
  }

  static function resolveImplicitUsingFunction (rawFunc:Expr, required:Expr, requiredType:Option<Type>, args, scopes, lastRequired)
  {
    return Profiler.profile(function ()
    {
      // check if the return type of the implicit function is compatible to the required type

      var returnedExpr = getFunctionExprReturnType(rawFunc, args.length);


      var isComp = Typer.isCompatible(asImplicitObject(returnedExpr), asImplicitObject(required));

      return if (isComp) // it's compatible
      {
        if (args.length == 0) // function requires no arguments, just call it
          Some(Success(macro $rawFunc()))
        else
        {
          // function requires arguments, but these arguments must be compatible to the required type,
          // which could be more specific than the raw return type (e.g. type parameters).
          var withConcreteReturn = makeFunctionExprReturnTypeConcrete(rawFunc, required, args.length);
          Some(resolve1(Typer.makeFastTypeable(withConcreteReturn), rawFunc, [], scopes, lastRequired.concat([required]), args.length));
        }
      }
      else Option.None;
    });
  }

  static var concatUsingsCache = new Cache();

  static function resolveImplicitInUsingContext(required:Expr, scopes:Scopes, lastRequired:Array<Expr>):Validation<ResolverError, Expr>
  {
    return Profiler.profile(function () {


      function checkCandidate (requiredType:Option<Type>, x:{parsed : Expr, field:ClassField, cl:ClassType, followedType : Option<Type>})
      {
        return Profiler.profile(function () {
          var parsed = x.parsed;
          // this loop logic (follows) can also be performed during the collection phase, so it's only done once
          function loop (t:Type) return switch (t)
          {
            case TLazy(x): loop(Context.follow(x()));
            case TInst(_,_):     resolveImplicitUsingObject(parsed, required, requiredType).map(Success);
            case TAbstract(_,_): resolveImplicitUsingObject(parsed, required, requiredType).map(Success);
            case TEnum(_,_):     resolveImplicitUsingObject(parsed, required, requiredType).map(Success);
            case TAnonymous(_):  resolveImplicitUsingObject(parsed, required, requiredType).map(Success);
            case TFun(args, _):  resolveImplicitUsingFunction(parsed, required, requiredType, args, scopes, lastRequired);
            case _:  Option.None;
          }
          return loop(Context.follow(x.field.type));


        },"checkCandidate");
      }

      var usings = Profiler.profile(Context.getLocalUsing, "getLocalUsing");

      var usingsId = Profiler.profile(function () {
        var c = Context.getLocalClass();
        var cl = c.get();
        var hash = cl.module + cl.name;
        return concatUsingsCache.getOrSet(hash, getUsingsId.bind(usings));
      }, "concatUsingsAlt");

      function typeToUsingTypeId(requiredType)
      {
        return Profiler.profile(function ()
        {
          var requiredTypeStr = TypeTools.toString(requiredType);
          return getRequiredTypeAndUsingId(requiredTypeStr, usingsId);
        }, "typeToUsingTypeId");
      }

      function getContext()
      {
        return Profiler.profile(function () {
          var ctx = getUsingContext(required, usings, usingsId);
          var res = ctx.res;

          return switch (res.mapThenSomeOption(checkCandidate.bind(ctx.requiredType)))
          {
            case Some(x): x;
            case None: Failure(RE.noImplicitObjectInContext(required));
          }
        }, "getContext");
      }

      var hasNonUsingImplicits = scopes.locals.length == 0 && scopes.members.length == 0 && scopes.statics.length == 0;


      return if (hasNonUsingImplicits)
      {
        var idOpt = Profiler.profile(function () return Typer.typeof(required).map(typeToUsingTypeId), "complex-TypeOf");
        switch (idOpt)
        {
          case Some(id) if (usingCtxFirstLevelCache.exists(id)):
            Profiler.pushPop("cache");
            usingCtxFirstLevelCache.get(id);
          case Some(id):
            if (usingCtxFirstLevelCache.exists(id)) {

              Context.error("ERROR", Context.currentPos());
            } else {
              Profiler.pushPop("set-cache");
              usingCtxFirstLevelCache.set(id, getContext());
            }
          case _:
            Profiler.pushPop("no-cache");
            getContext();
        }
      }
      else
      {
        Profiler.pushPop("no-cache");
        getContext();
      }
    });

  }

}



#end