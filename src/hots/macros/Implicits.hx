package hots.macros;
#if (macro || display)
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;
import hots.Implicit;
import scuts.core.extensions.Arrays;
import scuts.core.types.Tup2;
import scuts.core.types.Validation;
import scuts.mcore.Check;

import hots.macros.utils.Constants;
import scuts.core.types.Tup2;
import scuts.mcore.MContext;
import scuts.mcore.Print;
import scuts.Scuts;
using scuts.core.extensions.Arrays;
import scuts.core.types.Option;




class Implicits 
{
  
  static var nextId = 0;
  
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
      var id = "__implicit__id" + (++nextId);
      var idExpr = { expr : EConst(CIdent(id)), pos : Context.currentPos() };
      arr.push({ e: idExpr, pos: Context.getPosInfos(e.pos)});
      
      vars.push( { name : id, expr : e, type : null } );
    }
    implicits.set(id, arr);
    var vars = { expr : EVars(vars), pos : Context.currentPos() };
    //trace(Print.expr(vars));
    return vars;
  }
  
  public static function apply (f:Expr, params:Array<Expr>) // f is String -> Monoid<T> -> Bool
  {
    //trace(Print.expr(f));
    
    if (params == null) params = [];

    // workaround because of the monomorph issue
    // see http://code.google.com/p/haxe/issues/detail?id=1131
    // instead of using the supplied expression we save the first parameter in 
    // a temporary variable first and call the underscore function afterwards with
    // the same parameters
    /*
    if (params.length > 0 && params.any(function (p) return !Check.isConst(p))) {
      
      #if scutsDebug
      //trace(params.map(function (p) return Print.expr(p) + " isConst " + !Check.isConst(p)));
      #end
      
      // store all params in a temp and try again
      
      
      
      var prefix = "__p" + ++id + "_";
      
      var vars = params.mapWithIndex(function (p, i) return { name : prefix + i, type: null, expr : p } );
      
      var varsDecl = { expr : EVars(vars), pos : Context.currentPos() };
      var callArgs = vars.map(function (x) return { expr : EConst(CIdent(x.name)),  pos : x.expr.pos});
      
      var call = { expr: ECall(macro hots.Hots._, [macro $f].concat(callArgs)), pos : f.pos };
      
      var block = macro { $varsDecl; $call; };
      //trace(Print.expr(block));
      
      return block;
      

    }
    */
    // last param can be supplied context objects
    var supplied = 
      if (params.length > 0) 
      {
        var values = switch (params[params.length - 1].expr) 
        {
          case EIn(e1, e2): switch (e2.expr) 
          {
            case EArrayDecl(values): Some(values);
            default: Some([e2]);
          }
          default: Some([]);
        }
        
        switch (values) 
        {
          case Some(s): if (s.length > 0) params.pop(); s;
          case None: Scuts.macroError("You can only provide an expression like ( a _ in [a,b] ) as an additional parameter", f.pos);
        }
      } else [];
    
    

    return apply1(f, params, supplied.concat(getImplicitsFromScope()), None);
  }
  
  public static function getImplicitsFromScope ():Array<Expr>
  {
    var m = Std.string(Context.getLocalMethod());

    var cl = Context.getLocalClass().get();
    
    function fromLocals () {
      var id = cl.name + m;
      //trace(id);
      var all = implicits.get(id);
      //trace(all);
      if (all == null) return [];
      var curPos = Context.getPosInfos(Context.currentPos());
      var filtered = [];
      for (a in all) {
        
        //trace(a.pos.max);
        //trace(curPos.min);
        if (a.pos.max < curPos.min && try { Context.typeof(a.e); true; } catch (e:Dynamic) false) 
        {
          
          filtered.push(a.e);
        }
      }
      
      filtered.reverse();
      return filtered;
      
    }
    
    function addMeta (fields:Array<ClassField>) 
    {
      
      var res = [];
      
      for (f in fields) {
        switch (f.kind) {
          case FieldKind.FVar(_,_):
            if (isImplicitType(f.type)) {
              res.push( { expr : EConst(CIdent(f.name)), pos:f.pos } );
            }
          default:
        }
      }
      return res;
    }
    
    var fromFields=  addMeta(cl.fields.get());
    var fromStatics = addMeta(cl.statics.get());
    
    return fromLocals().concat(fromFields.concat(fromStatics));
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
        case 0 : macro hots.macros.Implicits.ImplicitsHelper.castCallbackTo0;
        case 1 : macro hots.macros.Implicits.ImplicitsHelper.castCallbackTo1;
        case 2 : macro hots.macros.Implicits.ImplicitsHelper.castCallbackTo2;
        case 3 : macro hots.macros.Implicits.ImplicitsHelper.castCallbackTo3;
        case 4 : macro hots.macros.Implicits.ImplicitsHelper.castCallbackTo4;
        case 5 : macro hots.macros.Implicits.ImplicitsHelper.castCallbackTo5;
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
  
  
  public static function apply1 (f:Expr, params:Array<Expr>, supplied:Array<Expr>, lastNeeded:Option<Expr>) // f is String -> Monoid<T> -> Bool
  {

    //trace(Print.expr(f));
    
    
    //trace(prettyType(Context.typeof(f)));
    
    //var f = onlyWrapInUntyped(f);
    
    
    
    var f = simplifyFunction(f, params);
    
    
   
    var t = Context.typeof(f);
    
    
    // typeof can fail when unknowns types are included
    var args = try switch (t) 
    {
      case TFun(args, _): args;
      default: Scuts.macroError("The expression ( " + Print.expr(f) + " ) is not function type", f.pos);
    }
    catch (e:Error) Scuts.macroError("Cannot determine the type of expression ( " + Print.expr(f) + " )", f.pos);
    
    var numArgs = args.length;
    
    
    if (numArgs == -1) Scuts.unexpected();
    
    if (numArgs == 0) return f;
    
    if (params.length > numArgs) {
      Scuts.macroError("Too many arguments for this function, " + numArgs + " expected, " + params.length + " received ", f.pos);
    }
    
    var tComplex = Context.toComplexType(t);
    //trace(tComplex);
    var fsimple = macro { var a : $tComplex -> Void = null; a; };
    
    //trace(Print.expr(f));
    //trace(Print.expr(fsimple));
    
    
    var curried = switch (numArgs) {
      case 0: macro hots.macros.Implicits.ImplicitsHelper.curry0($f);
      case 1: macro hots.macros.Implicits.ImplicitsHelper.curry1($f);
      case 2: macro hots.macros.Implicits.ImplicitsHelper.curry2($f);
      case 3: macro hots.macros.Implicits.ImplicitsHelper.curry3($f);
      case 4: macro hots.macros.Implicits.ImplicitsHelper.curry4($f);
      case 5: macro hots.macros.Implicits.ImplicitsHelper.curry5($f);
      case 6: macro hots.macros.Implicits.ImplicitsHelper.curry6($f);
      case 7: macro hots.macros.Implicits.ImplicitsHelper.curry7($f);
    }
    
    var res = [];
    
    for (i in 0...numArgs) 
    {
      //trace("arg + " + i);
      var curArg = args[i];
      var needed = macro hots.macros.Implicits.ImplicitsHelper.toEffect($curried);
      
      
      
      var param = if (i < params.length) params[i] else null;

      //trace(param);
      var r = 
        if (param == null) {
          var neededType = Context.typeof(macro hots.macros.Implicits.ImplicitsHelper.effectParam($needed));
          
          //trace(Print.type(neededType));
          
          
          function notImplicitError () {
            
            return Scuts.error("The function argument " + curArg.name + " is not an implicit parameter and must be provided"
              + " in function " + Print.expr(f)
            );
          }
          
          if (isImplicitType(neededType)) {
            
            getImplicitObj(needed, supplied, lastNeeded);
          }
          else notImplicitError();

        }
        else {
          // take param and convert if necessary
         // trace("convertIfNeccessary");
          getImplicitConversion(param, needed);
        }
      //trace("push:" + r);
      res.push(r);
      curried = macro $curried($r);
      
    }
    
    
    var r = { expr: ECall(f, res), pos : f.pos };
   // trace(r);
    //var r = macro $f($[res]);
    

    
    //trace(r);
    //trace(try Print.expr(r) catch (e:Dynamic) "cannot print expr");
    // implicit returns now
    
    var check = true;
    
    var i = 0;
    
    while (check && i < 2) {
      i++;
      var x = macro $r.implicitRet();
      
      //trace(x);
      //trace(Print.expr(x));
      //trace(x);
      try { 
        var t = Context.typeof(x);
        trace("Using Implicit Return for type: " + prettyType(t));
        #if scutsDebug
        
        #end
         r = x; 
      } catch (e:Error) { check = false; };
    }
    
    //trace(Print.expr(r));
    
    
    //var y = { expr : ECheckType(r, Context.toComplexType(Context.typeof(r))), pos : r.pos };
    
    //trace(Print.expr(y));

    #if display
    //return { expr : ECheckType(macro null, Context.toComplexType(Context.typeof(r))), pos : r.pos }
    return r;
    #else
    //trace(Print.expr(r));
    return r;
    #end
  }
  
  
  static function isImplicitType (type:Type) return switch (type) {
    case TType(t, _): 
      var tget = t.get();
      if (tget.pack.length == 1 && tget.pack[0] == "hots" && tget.name == "Implicit") true else false;
    default: false;
  }
  
  
  public static function getImplicitConversion (param:Expr, needed:Expr) 
  {
    
    function searchConversion () 
    {
      //trace(Print.expr(param));
      var r = macro hots.macros.Implicits.ImplicitsHelper.toImplicitConversion($param, $needed).implicit($param);
      var success = try { Context.typeof(r); true; } catch (e:Error) false;
      if (!success) 
      {
        var type = macro hots.macros.Implicits.ImplicitsHelper.effectParam($needed);
        Scuts.macroError("Cannot find an implicit definition for conversion from\n\n "
          + prettyType(Context.typeof(param)) + " to " + prettyType(Context.typeof(type)) + "\n\n");
      }
      return r;
    }
    
    var accept = try Context.typeof(macro $needed($param)) catch (e:Error) null;

    return if (accept != null) param else searchConversion();
  }

  static function prettyType (t:Type) {
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
    return try Some(Context.typeof(e)) catch (e:Error) None;
  }

  
  public static function getImplicitObj (needed:Expr, supplied:Array<Expr>, lastNeeded:Option<Expr>) 
  {
    
    
    switch (lastNeeded) {
      case Some(s): 
        var test = macro hots.macros.Implicits.ImplicitsHelper.sameType($needed, s);
        if (isTypeable(test)) 
        {
          Scuts.error("Cannot find implicitObj definition for type " + prettyType(neededToType(needed)) + " in current scope");
        }
      case None: 
        //trace("try again for " + prettyType(neededToType(needed)));
        
    }

    
    // search in supplied
    
    var r = null;
    
    var fullfilled = false;
    
    // TODO should check for amiguity or use the first match?
    for (s in supplied) {
      var accept = isTypeable(macro $needed($s));
      if (accept) { r = s; fullfilled = true; break; }
    }
    
    if (!fullfilled) 
    {
      var e = acceptAmbiguity(needed, "implicitObj", supplied, lastNeeded);
      switch (e) 
      {
        case Success(s): r = s; fullfilled = true;
        case Failure(s): r = s; fullfilled = false;
      }
    }
    
    return 
      if (fullfilled) r 
      else switch (getType(r)) 
      {
        case Some(s): switch (s) 
        {
          case TFun(args,_): 
            apply1( r, [], supplied, Some(needed) );
          default: 
            var msg = "Invalid implicitObj definition for type " + prettyType(neededToType(needed))  + " in current scope\n"
              + "It's possible that you leaved out an explicit return type, which is needed when the resulting object depends "
              + "on type parameters.";
            Scuts.error(msg);
          
        }
        case None: Scuts.error("Cannot find implicitObj definition for type " + prettyType(neededToType(needed)) + " in current scope");
      }
      
  }
  
  static function acceptAmbiguity(needed:Expr, method:String, supplied:Array<Expr>, lastNeeded:Option<Expr>):Validation<Expr, Expr>
  {
    var impNeeded = macro hots.macros.Implicits.ImplicitsHelper.toImplicitObject($needed);
    
    var field = { expr : EField(impNeeded, method), pos : Context.currentPos() };
    var r = macro $field;
    
    var r2 = switch (Context.typeof(r))
    {
      case TFun(args, ret):
        if (args.length == 0) (macro $r())
        else apply1(r, [], supplied,lastNeeded);
      default: 
        Scuts.error(method + " must be a function taking an implicit variable");
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
    var type = macro hots.macros.Implicits.ImplicitsHelper.effectParam($needed);
    return Context.typeof(type);
  }
  
  public static function implicitType (t:String, ?supplied:Array<Expr>) 
  {
    if (supplied == null) supplied = [];
    
    var needed = Context.parse(" { var e : " + t + " -> Void = null; e; } ", Context.currentPos());
    return getImplicitObj(needed, supplied, None);
    
  }
  
  
}
#end

#if !macro

class ImplicitsHelper {
  public static inline function curry0<A> (f:Void->A):Void->A return null
  public static inline function curry1<A,B> (f:A->B):A->B return null
  public static inline function curry2<A,B,C> (f:A->B->C):A->(B->C) return null
  public static inline function curry3<A,B,C,D> (f:A->B->C->D):A->(B->(C->D)) return null
  public static inline function curry4<A,B,C,D,E> (f:A->B->C->D->E):A->(B->(C->(D->E))) return null
  public static inline function curry5<A,B,C,D,E,F> (f:A->B->C->D->E->F):A->(B->(C->(D->(E->F)))) return null
  public static inline function curry6<A,B,C,D,E,F,G> (f:A->B->C->D->E->F->G):A->(B->(C->(D->(E->(F->G))))) return null
  public static inline function curry7<A,B,C,D,E,F,G,H> (f:A->B->C->D->E->F->G->H):A->(B->(C->(D->(E->(F->(G->H)))))) return null
  
  public static inline function toImplicitConversion <A,B>(a:A, b:B->Void):hots.ImplicitConversion<A,B> return null
  public static inline function toImplicitObject <A>(a:A->Void):hots.ImplicitObject<A> return null
  
    
  public static inline function castCallbackTo0 <A,B>          (f:A->(Void->B),          c:Dynamic):A->B             return cast c
  public static inline function castCallbackTo1 <A,B,C>        (f:A->(B->C),             c:Dynamic):A->B->C          return cast c
  public static inline function castCallbackTo2 <A,B,C,D>      (f:A->(B->C->D),          c:Dynamic):A->B->C->D       return cast c
  public static inline function castCallbackTo3 <A,B,C,D,E>    (f:A->(B->C->D->E),       c:Dynamic):A->B->C->D->E    return cast c
  public static inline function castCallbackTo4 <A,B,C,D,E,F>  (f:A->(B->C->D->E->F),    c:Dynamic):A->B->C->D->E->F return cast c
  public static inline function castCallbackTo5 <A,B,C,D,E,F,G>(f:A->(B->C->D->E->F->G), c:Dynamic):A->B->C->D->E->F->G return cast c
  
  public static inline function castTo <X>(f:X, c:Dynamic):X return cast c
  
  public static inline function sameType <A,B>(a:A,b:B):Void { }
 
  public static inline function effectParam <T> (x:T->Void):T return null
  
  public static inline function toEffect <A,B> (f:A->B):A->Void return null
}
#end

