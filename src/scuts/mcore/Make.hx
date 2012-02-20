package scuts.mcore;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)
import haxe.macro.Expr;
import haxe.macro.Context;
import scuts.core.types.Option;
import scuts.Scuts;

class Make
{
  
  public static inline function field (obj:Expr, field:String, ?pos:Position):Expr
    return expr(EField(obj, field), pos)
    
  public static inline function const (const:Constant, ?pos:Position):Expr
    return expr(EConst(const), pos)
    
  public static inline function constIdent (ident:String, ?pos:Position):Expr
    return const(CIdent(ident), pos)
    
  public static inline function constInt (value:String, ?pos:Position):Expr
    return const(CInt(value), pos)
    
  public static inline function identNull (?pos:Position):Expr
    return const(CIdent("null"), pos)
    
  public static inline function identFalse (?pos:Position):Expr
     return const(CIdent("false"), pos)
      
  public static inline function identTrue (?pos:Position):Expr
     return const(CIdent("true"), pos)
    
  public static inline function assign (left:Expr, right:Expr, ?pos:Position):Expr
    return expr(EBinop(OpAssign, left, right), pos)
    
  public static inline function ifExpr (econd:Expr, ethen:Expr, ?eelse:Expr = null, ?pos:Position):Expr
    return expr(EIf(econd, ethen, eelse), pos)
	
  static function fields (declarations:Array<String>, p) {
		var e = Context.parse( "{var x: {" + declarations.join("\n") + "}}", p);

		return switch (e.expr) {
			case EBlock(exprs): switch (exprs[0].expr) {
				case EVars(v):
					switch (v[0].type) {
						case TAnonymous(f): f;
						default: Scuts.error("Assert");
					}
				default: Scuts.error("Assert");
			}
			default: Scuts.error("Assert");
		}
	}
	
  public static function call (e:Expr, func:String, params:Array<Expr>, ?pos:Position) {
    return expr(ECall(field(e, func, pos), params), pos);
  }
  
  public static inline function expr (def:ExprDef, ?pos:Position):Expr
    return 
      { 
        expr:def, 
        pos: if (pos == null) Context.currentPos() else pos 
      }
    
  public static inline function block (exprs:Array<Expr>, ?pos:Position):Expr 
    return expr(EBlock(exprs), pos)
  
  public static inline function emptyBlock (?pos:Position):Expr 
    return expr(EBlock([]), pos)
  
  public static inline function varExpr (variableId:String, ?type:ComplexType, ?ex:Expr, ?pos:Position) 
  {
    return vars([{ type : type, expr: ex, name:variableId}], pos);
  }
  
  public static inline function varNullExpr (name:String, ?type:ComplexType, ?pos:Position):Expr
  {
    return vars([{ type : type, expr: identNull(pos), name:name}], pos);
  }
  
  public static inline function vars (vars:Array<{name:String, ?type:ComplexType, ?expr:Expr}>, ?pos:Position):Expr
  {
    return expr(EVars(vars), pos);
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