package scuts.mcore;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)
import haxe.macro.Expr;
import haxe.macro.Context;

class Make
{

  public static inline function mkFieldExpr (obj:Expr, field:String, ?pos:Position):Expr
    return mkExpr(EField(obj, field), pos)
    
  public static inline function mkConstExpr (const:Constant, ?pos:Position):Expr
    return mkExpr(EConst(const), pos)
    
  public static inline function mkIdentConstExpr (ident:String, ?pos:Position):Expr
    return mkConstExpr(CIdent(ident), pos)
    
  public static inline function mkConstIntExpr (value:String, ?pos:Position):Expr
    return mkConstExpr(CInt(value), pos)
    
  public static inline function mkNullExpr (?pos:Position):Expr
    return mkConstExpr(CIdent("null"), pos)
    
  public static inline function mkFalseExpr (?pos:Position):Expr
     return mkConstExpr(CIdent("false"), pos)
      
  public static inline function mkTrueExpr (?pos:Position):Expr
     return mkConstExpr(CIdent("true"), pos)
    
  public static inline function mkAssignExpr (left:Expr, right:Expr, ?pos:Position):Expr
    return mkExpr(EBinop(OpAssign, left, right), pos)
    
  public static inline function mkIfExpr (econd:Expr, ethen:Expr, ?eelse:Expr = null, ?pos:Position):Expr
    return mkExpr(EIf(econd, ethen, eelse), pos)
	
  static function makeFields (declarations:Array<String>, p) {
		var e = Context.parse( "{var x: {" + declarations.join("\n") + "}}", p);

		return switch (e.expr) {
			case EBlock(exprs): switch (exprs[0].expr) {
				case EVars(v):
					switch (v[0].type) {
						case TAnonymous(f): f;
						default:null;
					}
				default: null;
			}
			default:null;
		}
	}
	
  public static function mkCall (e:Expr, func:String, params:Array<Expr>, ?pos:Position) {
    return mkExpr(ECall(mkFieldExpr(e, func, pos), params), pos);
  }
  
  public static inline function mkExpr (def:ExprDef, ?pos:Position):Expr
    return { 
      expr:def, 
      pos: if (pos == null) Context.currentPos() else pos 
    }
    
  public static inline function mkBlock (exprs:Array<Expr>, ?pos:Position):Expr 
    return mkExpr(EBlock(exprs), pos)
  
   public static inline function mkEmptyBlock (?pos:Position):Expr 
    return mkExpr(EBlock([]), pos)
  public static inline function mkVarExpr (expr:String) 
    return extractVarsFromBlock(Context.parse("{" + expr + ";}", Context.currentPos()))[0]

  public static function mkVarAssignExpr (variable:String, expr:Expr):Expr {
    var varExpr = mkVarExpr("var " + variable + " = null");
    switch (varExpr.expr) {
      case EVars(vars):
        vars[0].expr = expr;
      default:
    }
    return varExpr;
  }
  public static function extractVarsFromBlock (block:Expr) 
    return switch (block.expr) 
    {
      case EBlock(exprs):
        if (exprs.length == 0) throw "assert: No vars in block";
        exprs;
      default: throw "assert";
    }
}

#end