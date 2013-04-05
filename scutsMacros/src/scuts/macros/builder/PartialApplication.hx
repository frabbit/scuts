package scuts.macros.builder;

#if false

#if macro

import scuts.core.Arrays;
import scuts.core.Iterables;

using scuts.core.Arrays;
using scuts.core.Options;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import scuts.core.Dynamics;
import scuts.mcore.Check;
import scuts.mcore.Parse;
import scuts.mcore.Print;



class PartialApplication 
{

  public static function apply (exprs:Array<Expr>) {
    
    // first is function
    var f = exprs[0];
    
    var isUnderscore = function (e:Expr) return Check.isConstIdent(e, function (s) return s == "_");
    var isNull =  function (e:Expr) return Check.isConstIdent(e, function (s) return s == "null");
    
    var underscoreExpr = {expr:EConst(CIdent("_")), pos: Context.currentPos()};
    
    var args = exprs.drop(1).map(function (e) return if (isNull(e)) underscoreExpr else e);
    
    
    var ftype = Context.typeof(f);
    
    var functionArgs = switch (ftype) {
      case TFun(args, ret):
        args;
      default: Context.error("First argument must be function", f.pos);
    }
    
    
    var argsDiff = functionArgs.length - args.length; 
    
    // passed args and function must be same size, fill missing ones with underscore
    var usedArgs = if (argsDiff > 0) 
                      args.concat(Dynamics.replicateToArray(underscoreExpr, functionArgs.length - args.length)) 
                   else if (argsDiff < 0)
                      Context.error("You cannot partially apply more arguments than " + functionArgs.length, f.pos)
                   else args;
    
   
    
    var zipped = functionArgs.zip(usedArgs);
    
    var newArgs = zipped.filter(function (a) return isUnderscore(a._2)).map(function (a) return a._1.name);
    
    var params = zipped.map(function (a) return if (isUnderscore(a._2)) {expr:EConst(CIdent(a._1.name)), pos:f.pos} else a._2);
    
    var fCall = {expr:ECall(f, params), pos:f.pos};
    
    var res = Parse.parse('function (' + newArgs.join(",") + ') return $0', [fCall]);
   
    return res;

  }
  
}
#end

#end