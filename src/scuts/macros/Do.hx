package scuts.macros;



#if macro
import hots.macros.Implicits;
import scuts.macros.syntax.DoParser;
import scuts.macros.syntax.DoGen;
import haxe.macro.Expr;
import scuts.macros.syntax.DoTools;
import scuts.Scuts;
using scuts.core.extensions.Arrays;
using scuts.core.extensions.Validations;
#end



class Do 
{
  
  @:macro public static function run<M>(e1:Expr, ?exprs : Array<Expr>)
  {
    var exprs = exprs == null ? [e1] : exprs.cons(e1);
    
    var op = DoParser.parseExprs(exprs).getOrElse(function (e) return DoParseErrors.handleError(e, e1.pos));
    
    var res = DoGen.toExpr(op).getOrElse(function (e) return DoGenErrors.handleError(e, e1.pos));

    return res;
  }

}