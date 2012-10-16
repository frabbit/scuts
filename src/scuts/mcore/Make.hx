package scuts.mcore;

#if macro

import haxe.macro.Expr;
import haxe.macro.Context;
import scuts.core.Option;
import scuts.Scuts;
using scuts.core.Dynamics;
using scuts.core.Arrays;

class Make
{

  public static inline function whileExpr (cond:Expr, body:Expr, ?pos:Position):Expr
    return expr(EWhile(cond, body, true), pos)
    
  public static inline function forIn (varName:String, iter:Expr, body:Expr, ?pos:Position):Expr
    return expr(EFor(expr(EIn(constIdent(varName, pos), iter), pos), body), pos)
  
  public static inline function binop (left:Expr, right:Expr, op:Binop, ?pos:Position):Expr
    return expr(EBinop(op,left, right), pos)
    
  public static inline function unop (e:Expr, op:Unop, ?postFix:Bool = false, ?pos:Position):Expr
    return expr(EUnop(op, postFix, e), pos)
  
  public static inline function field (e:Expr, field:String, ?pos:Position):Expr
    return expr(EField(e, field), pos)
    
  public static function fields (e:Expr, fields:Array<String>, ?pos:Position):Expr
    return fields.foldLeft(e, function (acc, cur) return field(acc, cur, pos))
    
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
	
  public static function anon (fields:Array<{ field : String, expr : Expr }>, ?pos:Position) 
    return expr(EObjectDecl(fields), pos)
  
  public static function anonField (field:String, expr:Expr)
    return { field: field, expr:expr}
  
  public static function parenthesis (e:Expr, ?pos:Position) {
     return expr(EParenthesis(e), pos);
  }
    
  public static function funcExpr (
    ?name:String, ?args:Array<FunctionArg>, ?ret:ComplexType, ?eexpr:Expr, 
    ?params:Array<{ ?params : Array<TypeParamDecl>, name:String, ?constraints:Array<ComplexType>}>, ?pos:Position) 
  {
    return expr(EFunction(name, func(args, ret, eexpr, params)), pos);
  }
  
  public static function func (?args:Array<FunctionArg>, ?ret:ComplexType, ?expr:Expr, ?params:Array<{?params : Array<TypeParamDecl>, name:String, ?constraints:Array<ComplexType>}>) {
    return {
      args: args == null ? [] : args,
      ret: ret,
      expr: expr,
      params: params == null ? [] : params,
    }
  }
  
  public static function funcArg (name:String, opt:Bool, ?type:ComplexType, ?value:Expr) {
    return {
      name:name,
      opt:opt,
      type:type,
      value:value
    }
  }
    
  static function anonFields (declarations:Array<String>, ?p:Position) 
  {
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
	
  public static function call (e:Expr, params:Array<Expr>, ?pos:Position)
    return expr(ECall(e, params), pos)
  
  public static inline function expr (def:ExprDef, ?pos:Position):Expr
    return 
      { 
        expr:def, 
        pos: if (pos == null) Context.currentPos() else pos 
      }
    
  public static inline function block (?exprs:Array<Expr>, ?pos:Position):Expr 
    return expr(EBlock(exprs == null ? [] : exprs), pos)
  
  public static inline function emptyBlock (?pos:Position):Expr return block()
  
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
  
  public static inline function castExpr (e:Expr, ?type:ComplexType, ?pos:Position):Expr
  {
    return expr(ECast(e, type), pos);
  }
  
  public static inline function returnExpr (?e:Expr, ?pos:Position):Expr
  {
    return expr(EReturn(e), pos);
  }
  
  public static inline function type (pack:Array<String>, name:String, ?module:String, ?pos:Position):Expr
  {
    return if (pack.length == 0) {
      if (module == null) const(CType(name), pos)
      else expr(EType(expr(EConst(CType(module)), pos), name), pos);
    } else {
      var first = pack[0];
      var e = constIdent(first);
      for (i in 1...pack.length) e = field(e, pack[i], pos);
      if (module != null) e = expr(EType(e, module), pos);
      e = expr(EType(e, name));
      e;
    }
  }

  public static function typePath (pack:Array<String>, name:String, ?params:Array<TypeParam>, ?sub:String):TypePath
  {
    return {
      pack : pack,
      name : name,
      params : params == null ? [] : params,
      sub : sub
    }
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