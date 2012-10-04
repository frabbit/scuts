package hots.macros.implicits;

#if macro

import haxe.macro.Context;
import haxe.macro.Expr;
import scuts.mcore.extensions.Exprs;

using scuts.core.extensions.Strings;
using scuts.core.extensions.Arrays;

class Hacks 
{
  static var hacksHelper = macro hots.macros.implicits.HacksHelper;
  
  public static function checkIfArgsAreValid (f:Expr, args:Array<Expr>) 
  {
    if (args.any(Exprs.isUnsafeCast)) {
      Errors.unsafeCastInArgs(f, args);
    }
    
    if (args.any(function (x) return Exprs.isConstNull(x) || x == null)) {
      Errors.nullExprInArgs(f, args);
    } 
  }
  
  public static function simplifyFunction (f:Expr, argsX:Array<Expr>):Expr {
    
    var helper = hacksHelper;
    
    function caster (c, res, numParams) //toCast, callArgs, funArgs
    {
      var castF = switch (numParams) 
      {
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
                       if (callArgs.length == f2.args.length + 1) 
                       {
                        var typed = caster(c, callExpr, f2.args.length);
                        if (callArgs.length > 0) {
                          argsX.unshift(args[0]);
                        }
                        return typed;
                      } 
                      else callExpr.expr = EUntyped({ expr:callExpr.expr, pos:callExpr.pos});
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
  
  static var id  = 0;

  static var idHash  = new IntHash();
  
  static function nextId () return ++id
  
  public static function makeTypeable (e:Expr)  
  {
    function apply (info) 
    {
      var id = Std.parseInt(info.file.substr(4, info.file.indexOf(":", 5)));
      var typedExpr = idHash.get(id);
      return typedExpr;
    }
    
    return switch (e.expr) 
    {
      case EParenthesis(ep): 
        var info = Context.getPosInfos(e.pos);
        if (info.file.startsWith("tag:")) apply(info) else makeTypeable(ep);
        
      default:e;
    }
  }
  
  public static function makeTaggedCast (e:Expr)  
  {
    var info = Context.getPosInfos(e.pos);
    var curId = nextId();
    
    var newInfo = { file:"tag:" + curId + ":" + info.file, min:info.min, max:info.max };

    idHash.set(curId,  e);
  
    var castTo = { expr : EParenthesis(e), pos : Context.makePosition(newInfo) };
    
    return castTo;
  }
  
  public static function isTaggedCast (e:Expr)  
  {
    function checkTag (e1) 
    {
      var info = Context.getPosInfos(e1.pos);
      
      return info.file.startsWith("tag:");
    }
    
    return switch (e.expr) 
    {
      case EParenthesis(e1): checkTag(e) || isTaggedCast(e1);
      default:false;
    }
  }
  
}

#end
  
