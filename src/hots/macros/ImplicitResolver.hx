package hots.macros;

import haxe.Log;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.PosInfos;
import hots.Implicit;

import scuts.core.extensions.Arrays;
import scuts.core.types.Tup2;
import scuts.core.types.Validation;
import scuts.mcore.Check;
import scuts.mcore.extensions.Exprs;

import scuts.mcore.MContext;
import scuts.mcore.Print;
import scuts.Scuts;
using scuts.core.extensions.Arrays;
import scuts.core.types.Option;

using scuts.core.extensions.Strings;
using scuts.core.extensions.Validations;
using scuts.core.extensions.Options;
using scuts.core.extensions.Functions;

enum Scope {
  Static; // checks ambiguty
  Member; // checks ambiguty
  Local; // take nearest to usage, no scope check possible
  Using; // take first found, based on using import order and declaration order in other module
}

private typedef ScopeExpr = { scope : Scope, expr : Expr }

private typedef NamedExpr = { name: String, expr:Expr }

typedef Scopes = {
  locals : Array<Expr>,
  members : Array<NamedExpr>,
  statics : Array<NamedExpr>
  // TODO add inherited members
}

enum AmbiguityError {
  MembersAmbiguous(arr:Array<NamedExpr>);
  StaticsAmbiguous(arr:Array<NamedExpr>);
}


class ImplicitResolver
{
  
  static var impCasts = null;
  
  static var implicitNextId = 0;
  
  static var implicits : Hash<Array<{e:Expr, pos:{min:Int, max:Int, file:String}}>> = new Hash();
  
  public static function register (exprs:Array<Expr>) 
  {
    
    var method = Context.getLocalMethod();
    var cl = Context.getLocalClass().get();
    
    var id = cl.name + method;
    //trace(id);
    
    var arr = implicits.get(id);
    if (arr == null) arr = [];
    
    var vars = [];
    for (e in exprs) {
      var id = "__implicit__id" + (++implicitNextId);
      var idExpr = { expr : EConst(CIdent(id)), pos : Context.currentPos() };
      arr.push({ e: idExpr, pos: Context.getPosInfos(e.pos)});
      
      vars.push( { name : id, expr : e, type : null } );
    }
    implicits.set(id, arr);
    var vars = { expr : EVars(vars), pos : Context.currentPos() };
    //trace(Print.expr(vars));
    return vars;
  }
  
  
  
  public static function localImplicits (m:String, cl:ClassType) 
  {
      var id = cl.name + m;
      var all = implicits.get(id);
      if (all == null) return [];
      var curPos = Context.getPosInfos(Context.currentPos());
      var filtered = [];
      for (a in all) {
        
        if (a.pos.max < curPos.min && try { Context.typeof(a.e); true; } catch (e:Dynamic) false) 
        {
          
          filtered.push(a.e);
        }
      }
      
      filtered.reverse();
      return filtered;
      
    }
  
  public static function getImplicitsFromMeta (fields:Array<ClassField>):Array<NamedExpr> 
  {
    var res = [];
    // are they sorted by position ? 
    for (f in fields) {
      switch (f.kind) {
        case FieldKind.FVar(_,_):
          if (isImplicitType(f.type)) {
            res.push( { name : f.name, expr:{ expr : EConst(CIdent(f.name)), pos:f.pos } });
          }
        default:
      }
    }
    return res;
  }
  
  public static function staticImplicits (m:String, cl:ClassType):Array<NamedExpr> {
    return getImplicitsFromMeta(cl.statics.get());
  }
  public static function memberImplicits (m:String, cl:ClassType):Array<NamedExpr> {
    return getImplicitsFromMeta(cl.fields.get());
  }
  
  public static function getImplicitsFromScope ():Scopes
  {
    var m = Std.string(Context.getLocalMethod());

    var cl = Context.getLocalClass().get();
    
    
    var scopes = {
      locals : localImplicits(m,cl),
      statics : staticImplicits(m,cl),
      members : memberImplicits(m,cl)
    }
    
    return scopes;
  }
  
  public static function findImplicit (needed:Expr, scopes:Scopes):Validation<AmbiguityError, Option<ScopeExpr>>
  {
    function getLocal ():Option<{ scope:Scope, expr:Expr}> {
      for (l in scopes.locals) {
        if (isNeeded(l, needed)) return Some({ scope:Local, expr : l });
      }
      return None;
    }
    
    function getFrom (scopeExprs:Array<NamedExpr>, err:Array<NamedExpr>->AmbiguityError, scope:Scope):Validation<AmbiguityError, Option<ScopeExpr>>
    {
      var found = [];
      for (m in scopeExprs) {
        if (isTypeable(m.expr) && isNeeded(m.expr, needed)) found.push(m);
      }
      return if (found.length == 1) Success( Some({ scope:scope, expr : found[0].expr }) )
      else   if (found.length > 1)  Failure(err(found))
      else                          Success(None);
    }
    
    
    return 
     Success(getLocal())
     .flatMap(function (x) return if (x.isNone()) getFrom(scopes.members, MembersAmbiguous, Member) else Success(x))
     .flatMap(function (x) return if (x.isNone()) getFrom(scopes.statics, StaticsAmbiguous, Static) else Success(x));
  }
  
  
  public static function onlyWrapInUntyped (f:Expr):Expr {
    
    switch (f.expr) 
    {
      case ECall(c,args): 
        
        if (args.length == 1) switch (c.expr) 
        {
          case EFunction(name1, f1):

            if (name1 == null && f1.args.length == 1 && f1.args[0].name == "_e") switch (f1.expr.expr) 
            {
              case EReturn(ret1Expr): switch (ret1Expr.expr) 
              {
                case EFunction(name2, f2): if (name2 == null) switch (f2.expr.expr) 
                {
                  case EReturn(retExpr): switch (retExpr.expr) {
                    case ECall(callExpr, callArgs): 
                      
                      callExpr.expr = EUntyped({ expr:callExpr.expr, pos:callExpr.pos});
                    default:
                    
                  
                  }
                  default:
                }
                default: 
              }
              default:
            }
          default :
        }
      default:
    
    }
    return f;
  }
  
  public static function simplifyFunction (f:Expr, params1:Array<Expr>):Expr {
    
    var caster = function (c, res, numParams) {//toCast, callArgs, funArgs
      

      
      var castF = switch (numParams) {
        case 0 : macro $helper.castCallbackTo0;
        case 1 : macro $helper.castCallbackTo1;
        case 2 : macro $helper.castCallbackTo2;
        case 3 : macro $helper.castCallbackTo3;
        case 4 : macro $helper.castCallbackTo4;
        case 5 : macro $helper.castCallbackTo5;
      }
      
      
      var casted = macro $castF($c, $res);
      
      
      
      return casted;
    }
    
    
    switch (f.expr) 
    {
      case ECall(c,args): 
        
        if (args.length == 1) switch (c.expr) 
        {
          case EFunction(name1, f1):
            
            
            
            if (name1 == null && f1.args.length == 1 && f1.args[0].name == "_e") switch (f1.expr.expr) 
            {
              case EReturn(ret1Expr): switch (ret1Expr.expr) 
              {
                case EFunction(name2, f2): if (name2 == null) switch (f2.expr.expr) 
                {
                  case EReturn(retExpr): switch (retExpr.expr) {
                    case ECall(callExpr, callArgs): 
                      
                      
                      if (callArgs.length == f2.args.length + 1) {
                        
                        var typed = caster(c, callExpr, f2.args.length);
                        if (callArgs.length > 0) {
                          params1.unshift(args[0]);
                        }
                        
                        return typed;
                      } else {
                        callExpr.expr = EUntyped({ expr:callExpr.expr, pos:callExpr.pos});
                      }
                    default:
                    
                  
                  }
                  default:
                }
                default: 
              }
              default:
            }
          default :
        }
      default:
    
    }
    return f;
  }
  
  public static function apply (f:Expr, params:Array<Expr>) // f is String -> Monoid<T> -> Bool
  {
    
    
    if (params == null) params = [];
    
    
    
    params = params.map(makeTypeable);

    
    return apply1(f, params, getImplicitsFromScope(), []);
  }
  
  public static function apply1 (f:Expr, params:Array<Expr>, scopes:Scopes, lastNeeded:Array<Expr>, tagged:Bool = true) // f is String -> Monoid<T> -> Bool
  {    
    #if scutsDebug
    trace("------------ Apply Started Pre Simplify -------------");
    printTypeOfExpr(f, "function Type");
    printTypeOfExprs(params, "param Types");
    printExprs(params, "exprs");
    trace("----------------------------------------");
    #end
    
    if (params == null) {
      Scuts.error("params must not be null");
    }
    
    
    
    var f = simplifyFunction(f, params);
    
    //f = f;
    //printExpr(f);
    
    //printExprs(params);
    
    
    
    if (params.any(function (x) return Check.isUnsafeCast(x))) {
      trace("----------------Unsafe cast detected ----------------------");
      printExprs(params);
      trace("----------------Unsafe end           ----------------------");
      Scuts.error("Cannot handle unsafe casted expressions");
    }
    
    if (params.any(function (x) return Check.isConstNull(x) || x == null)) {
      
      Scuts.error("null is not allowed as paramter for function" + prettyTypeOfExpr(f));
    } 
    #if secutsDebug
    trace("------------ Apply Started After Simplify -------------");
    printTypeOfExpr(f, "function Type");
    printTypeOfExprs(params, "param Types");
    printExprs(params, "exprs");
    
    trace("----------------------------------------");
    #end
    var t = Context.typeof(f);

    //printTypeOfExpr(f);
    //printExprs(params);
    // typeof can fail when unknowns types are included
    var args = try switch (t) 
    {
      case TFun(args, _): args;
      default: Scuts.macroError("The expression ( " + Print.expr(f) + " ) is not function type", f.pos);
    }
    catch (e:Error) Scuts.macroError("Cannot determine the type of expression ( " + Print.expr(f) + " )", f.pos);
    
    var numArgs = args.length;
    
    
    if (numArgs == -1) Scuts.unexpected();
    
    //if (numArgs == 0) return f;
    
    if (params.length > numArgs) {
      Scuts.macroError("Too many arguments for this function, " + numArgs + " expected, " + params.length + " received ", f.pos);
    }

    
    var curried = switch (numArgs) {
      case 0: macro $helper.curry0($f);
      case 1: macro $helper.curry1($f);
      case 2: macro $helper.curry2($f);
      case 3: macro $helper.curry3($f);
      case 4: macro $helper.curry4($f);
      case 5: macro $helper.curry5($f);
      case 6: macro $helper.curry6($f);
      case 7: macro $helper.curry7($f);
    }
    
    var res = [];
    
    
    for (i in 0...numArgs) 
    {
      //trace("arg + " + i);
      var curArg = args[i];
      
      //printExpr(curried);
      //printTypeOfExpr(curried);
      
      var needed = macro $helper.toEffect($curried);
      
      
      //trace(Context.typeof(needed));
      var param = if (i < params.length) params[i] else null;

      
      
      var r = 
        if (param == null) {
          var neededType = Context.typeof(macro $helper.effectParam($needed));
          
          //trace(Print.type(neededType));
          
          
          function notImplicitError () {
            
            return Scuts.error("The function argument " + curArg.name + " is not an implicit parameter and must be provided"
              + " in function " + Print.expr(f)
            );
          }
          
          if (isImplicitType(neededType)) {
            
            getImplicitObj(needed, scopes, lastNeeded);
          }
          else notImplicitError();

        }
        else {
          getImplicitConversion(param, needed);
        }
      
      res.push(r);
      curried = macro $curried($r);
    }
    
    
    var r = { expr: ECall(f, res), pos : f.pos };
  

    
    
    var result = applyImplicitDowncast(r,tagged);

    //var taggedExpr = makeTaggedCast(result, ct);
  
    
    #if scutsDebug
    trace("IS TAGGED CAST: " + isTaggedCast(result));
    
    printTypeOfExpr(result, "checked Type");
    #end
    
    return result;

  }
  
  
  
  static private function applyImplicitDowncast(r:Expr, tagged:Bool):Expr 
  {
    var x = macro $r.implicitDowncast();

    #if scutsDebug
    var typeable = isTypeable(x);
    trace("------------implicitReturnApplied: " + typeable + " -------------");
    if (typeable) {
      printTypeOfExpr(x, "New Type");
      printTypeOfExpr(r, "Old Type");
    } else {
      trace(prettyTypeOfExpr(r) + " has no function implicitDowncast in scope");
    }
    
    trace("----------------------------------------------------------------------");
    #end
    
    
    return if (isTypeable(x)) (if (tagged) makeTaggedCast(x) else x) else (if (tagged) makeTaggedCast(r) else r);
  }
  
  
  static function isImplicitType (type:Type) return switch (type) {
    case TType(t, _): 
      var tget = t.get();
      if (tget.pack.length == 1 && tget.pack[0] == "hots" && tget.name == "Implicit") true else isImplicitType(Context.follow(type, true));
    default: false;
  }
  /*
  static function sameType (e1:Expr, e2:Expr) {
    return isTypeable(
  }
  */
  
  
  public static function getImplicitConversion (param:Expr, needed:Expr) 
  {
    
    function searchConversion () 
    {
      switch (Context.typeof(param)) {
        case TMono(t): Scuts.error("Cannot search an implicit Conversion for TMONO");
        default:
      }
      
      var searchType = macro $helper.toImplicitConversion($param, $needed);
      var r = macro $helper.toImplicitConversion($param, $needed).implicit;
      
      var valid = macro $helper.isValidConversionFunction($param, $needed, $r);
      
      return if (!isTypeable(macro $r($param)) && !isTypeable(valid)) {
        #if secutsDebug
        trace("--------------Invalid Conversion Function found------------");
        printTypeOfExpr(r);
        printTypeOfExpr(searchType);
        
        trace("----------------------------------------------------------");
        #end
        // print a warning and let let the compiler handle the type mismatch
        Scuts.warning("No Conversion Found", "Cannot find a Conversion from " + prettyTypeOfExpr(param) + " to " + prettyType(neededToType(needed)));
        return param;
      } else {
      
        #if scutsDebug
        trace("--------------Search Conversion for---------------");
        //printExpr(r);
        printTypeOfExpr(r);
        printTypeOfExpr(needed);
        printTypeOfExpr(searchType);
        trace("--------------------------------------------------");
        #end
        
        
        
        r = macro $r($param);
        
        var success = isTypeable(r);
        
        if (!success) 
        {
          var type = macro $helper.effectParam($needed);
          Scuts.macroError("Cannot find an implicit definition for conversion from\n\n "
            + prettyTypeOfExpr(param) + " to " + prettyTypeOfExpr(type) + "\n\n"
            + prettyExpr(param) + " to " + prettyExpr(type)  
          );
        }
        r;
      }
    }
    
    
    

    
    
    
    var upcast = macro $param.implicitUpcast();
    
    
    var neededIsMono = switch (neededToType(needed)) {
      case TMono(_): true;
      default: false;
    }
    
    //var neededIsOf = macro $helper.neededIsOfType($needed);
    // TODO check against of and ofof to make sure that upcast is only done when neccessary
    #if scutsDebug
    trace("-------------- try parameter upcasting first ------------");
    trace("Success: " + isNeeded(upcast, needed));
    trace("Is Also Normal: " + isNeeded(param, needed));
    trace("For needed: " + prettyType(neededToType(needed)));
    trace("Param: " + prettyTypeOfExpr(param));
    trace("IsOfType: " + isTypeable(macro $helper.neededIsOfType($needed)));
    trace("-----------------------------------------");
    #end
    return if (!neededIsMono && isNeeded(upcast, needed)) {
      #if scutsDebug
      trace("Upcasted Type: " + prettyTypeOfExpr(upcast));
      #end
      upcast;
    } else {
      
      var normal = isNeeded(param, needed);
      
      #if scutsDebug
      if (normal) {
        
        trace("--------------Param accepted-----------------");
        printTypeOfExpr(param, "Found");
        printType(neededToType(needed), "Needed");
        trace("--------------------------------------------------");
      } else {
        trace("--------------Param type is not accepted, searching casts or conversions-----------------");
        printTypeOfExpr(param, "Param:");
        printType(neededToType(needed), "Needed");
        trace("--------------------------------------------------");

      }
      #end
      
      if (normal) {
        
        param;
      } else {
        // try downcast once
        var downcast = macro $param.implicitDowncast();
        trace("-------------- try downcasting ------------");
        trace("Success: " + isNeeded(downcast, needed));
        trace("-----------------------------------------");
        if (isNeeded(downcast, needed)) {
          downcast;
        } 
        else searchConversion();
      }
    }
    
  }

  static function printTypeOfExpr (e:Expr, ?msg:String, ?pos:PosInfos) 
  {
    if (msg == null) msg = "";
    switch (getType(e)) {
      case Some(x): Log.trace(msg + ":" + prettyType(x), pos);
      case None: Log.trace("cannot type the expression " + prettyExpr(e), pos);
    }
    
  }
  
  static function printTypeOfExprs (e:Array<Expr>, ?msg:String, ?pos:PosInfos) 
  {
    if (msg == null) msg = "";
    var res = Arrays.map(e, function (x) return prettyTypeOfExpr(x));
    trace(msg + ":" + res.join(","), pos);
    
  }
  
  static function prettyExpr (x:Expr) 
  {
    var first = Print.expr(x);
    return first.split("hots.macros.Implicits.ImplicitsHelper.").join("_").split("hots.extensions.").join("hots.ext.");
  }
  
  
  static function printExpr (x:Expr, ?msg:String, ?pos:PosInfos) 
  {
    if (msg == null) msg = "";
    trace(msg + ":" + prettyExpr(x), pos);
  }

  static function printExprs (x:Array<Expr>, ?msg:String, ?pos:PosInfos) {
    if (msg == null) msg = "";
    Log.trace(msg + ":" + Arrays.map(x, function (r) return prettyExpr(r)).join(","), pos);
    //trace(Print.expr(x));

  }
  
  
  
  static function prettyTypeOfExpr (e:Expr) return switch (getType(e)) 
  {
    case Some(x): prettyType(x);
    case None: "(Cannot Type Expression)";
  }

  static function printType (x:Type, ?msg:String, ?pos:PosInfos) 
  {
    if (msg == null) msg = "";
    Log.trace(msg + ":" + prettyType(x), pos);
  }
  
  
  static function prettyType (t:Type) 
  {
    var first = Print.type(t, true);
    var pretty = first.split("hots.Of").join("Of").split("hots.In").join("In").split("StdTypes.").join("").split(scuts.mcore.Constants.UNKNOWN_T_MONO).join("Unknown");
    
    return "( " + pretty + " )";
    
  }
  
  static function isTypeable (e:Expr) 
  {
    return try { Context.typeof(e); true; } catch (e:Error) false;
  }
  
  static function isNeeded (e:Expr, needed:ExprOf<Dynamic->Void>) 
  {
    return try { Context.typeof(macro $needed($e)); true; } catch (e:Error) false;
  }
  
  static function getType (e:Expr):Option<Type> 
  {
    return try Some(Context.typeof(e)) catch (e:Error)  None;
  }
  
  //static var castTags:IntHash<Bool> = new IntHash();
  
  //static var nextTagId:Int = 0;
  
  static function makeTaggedCast (e:Expr)  
  {
    


      
      var info = Context.getPosInfos(e.pos);
      var curId = nextId();
      
      var newInfo = { file:"tag:" + curId + ":" + info.file, min:info.min, max:info.max };

      idHash.set(curId,  e);
    
      
      var castTo = { expr : EParenthesis(e), pos : Context.makePosition(newInfo) };
      
      return castTo;
    
    
  }
  
  static function isTaggedCast (e:Expr)  
  {
    
    
    function checkTag (e1) {
      var info = Context.getPosInfos(e1.pos);
      
      return info.file.startsWith("tag:");
    }
    
    return switch (e.expr) {
      case EParenthesis(e1): checkTag(e);
      default:false;
    }
  }
  static var id  = 0;
  
  static function nextId () return id++
  
  static var idHash  = new IntHash();
  
  static function makeTypeable (e:Expr)  
  {
    function apply (e1, info) {
      
      
      
      var id = Std.parseInt(info.file.substr(4, info.file.indexOf(":", 5)));
      
      
      var uncastedExpr = idHash.get(id);
      
      var res = uncastedExpr;
      

      
      return res;
      // { expr : ECheckType(e, ct.ct), pos : e1.pos };
      
      
    }
    
    return switch (e.expr) {
      case EParenthesis(ep): switch (ep.expr) 
      {
        case ECast(ec,_):
          var info = Context.getPosInfos(e.pos);
          if (info.file.startsWith("tag:")) apply(ec, info) else e;
        default: e;
      }
      default:e;
    }
    
    
  }
  
  

  
  public static function getImplicitObj (needed:Expr, scopes:Scopes, lastNeeded:Array<Expr>) 
  {
    
    if (lastNeeded.length > 0) {
      
      for ( i in lastNeeded) {
        var test = macro $helper.sameType($needed, $i);

        if (isTypeable(test)) 
        {
          Scuts.warning("Circular dependency",
              "Circular dependency between " + prettyType(neededToType(needed)) + " and " + prettyType(neededToType(i)) + " in current scope\n"
            + "This may happen if the passed expression contains unsafe casts"
          );
        }
      }
    }

    // search in scopes
    
    var r = null;
    
    var fullfilled = false;
    
    
    
    // TODO should check for amiguity or use the first match?
    
    var found = findImplicit(needed, scopes);
    
    return switch (found) 
    {
      case Success(s): switch (s) 
      {
        case Some(v): v.expr;
        case None: switch (acceptAmbiguity(needed, "implicitObj", scopes, lastNeeded)) 
        {
          case Success(s): s;
          case Failure(f): 
            var msg = "Invalid implicitObj definition for type " + prettyType(neededToType(needed))  + " in current scope\n"
            + "It's possible that you leaved out an explicit return type, which is needed when the resulting object depends "
            + "on type parameters.";
            Scuts.error(msg);
        }
      }
      case Failure(f): 
        handleAmbiguityError(f);
        
    }

  }
  
  static function handleAmbiguityError(f:AmbiguityError) 
  {
    function makeMessage (scope:String, arr:Array<NamedExpr>) {
      
      var e = arr[0].expr;
      
      var typeStr = prettyTypeOfExpr(macro $helper.removeImplicit($e));
      
      return "Ambiguity Error Multiple Implicit Objects for Type " + typeStr + " in " + scope + "-Scope\n"
          +  "Namely : " + arr.map(function (x) return x.name).join(", ");
    }
    
    var msg = switch (f) {
      case StaticsAmbiguous(arr): makeMessage("Static", arr);
      case MembersAmbiguous(arr): makeMessage("Member", arr);
    }
    
    return Scuts.macroError(msg);
    
  }
  
  static function acceptAmbiguity(needed:Expr, method:String, scopes:Scopes, lastNeeded:Array<Expr>):Validation<Expr, Expr>
  {
    var impNeeded = macro $helper.toImplicitObject($needed);
    
    var field = { expr : EField(impNeeded, method), pos : Context.currentPos() };
    var r = macro $field;
    
    
    
    var r2 = switch (getType(r))
    {
      case Some(t): switch (t)
      {
        case TFun(args, ret):
          if (args.length == 0) {
            var r = (macro $r());
            
            if (!isNeeded(r,needed)) 
            {
              Scuts.error(
                "---------------- Wrong implicit Obj definition found --------------\n"
              + "Found: " + prettyTypeOfExpr(r) + "\n"
              + "Expected: " + prettyType(neededToType(needed)) + "\n"
              + "-------------------------------------------------------------------");
            } else r;
            
          }
          else 
          {
            #if secutsDebug
            trace("---------------- Implicit Object neede Dependencies ---------------");
            printTypeOfExpr(needed, "Needed");
            //if (lastNeeded.length > 0) printTypeOfExpr(lastNeeded.extract(), "LastNeeded") else "No Last Needed";
            printTypeOfExpr(r, "New Needed");
            trace("-------------------------------------------------------------------");
            #end
            //trace("recurse: " + args.length);
            //trace("recurse: " + args);
            
            var res = apply1(r, [], scopes, lastNeeded.concat([needed]),false);

            
            res;
          }
        default: 
          Scuts.error(method + " must be a function taking an implicit variable");
      }
      case None:
        // No implicit Object Found
        Scuts.error("Cannot found implicitObj Definition for type " + prettyType(neededToType(needed)) + " in current context");
    }
    
    
    
    return if (isNeeded(r2, needed)) Success(r2) else Failure(r2);
  }
  
  static function withoutAmbiguity(needed:Expr, method:String):Validation<Expr, Expr>
  {
    // TODO implement local using for to check for 
    // ambigouties, maybe optional with compiler flag because of computation overhead.
    return Scuts.notImplemented();
  }
  
  static function neededToType (needed:Expr) {
    var type = macro $helper.effectParam($needed);
    return Context.typeof(type);
  }
  
  public static function implicitByType (t:String, ?supplied:Array<Expr>) 
  {
    if (supplied == null) supplied = [];
    
    
    var needed = Context.parse(" { var e : " + t + " -> Void = null; e; } ", Context.currentPos());
    var res = getImplicitObj(needed, getImplicitsFromScope(), []);
    // make Implicit
    
    
    return macro $helper.toImplicit($res);
    
  }
  
  
  
  static var helper = (macro hots.macros.ImplicitInternal);
}




