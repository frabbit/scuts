package scuts.core.macros;

#if (macro || display)
import haxe.macro.Expr.ExprRequire;
import haxe.macro.Expr;
import haxe.macro.Type;
import scuts.core.types.Option;
#end
class Lazy 
{

  @:macro public static function expr(ex:Expr):Expr 
  {
    return mkExpr(ex);
  }
  
  #if (macro || display)
  public static function mkExpr (ex:Expr):Expr {
    var p = ex.pos;
    var constR = { expr: EConst(CIdent("r")), pos: p};
    
    var type = #if (display && !flash) None #else try Some(haxe.macro.Context.typeof(ex)) catch (e:Dynamic) None #end;

    var vars = {
      var r = {
        var e = switch (type) {
          case Some(t):
            switch (t) {
              case TInst(ct, _): 
                var cget = ct.get();
                var n = cget.name;
                var m = cget.module;
                if (n == "Int" && m == "StdTypes") EConst(CInt("0"))
                else if (n == "Float" && m == "StdTypes") EConst(CFloat("0.0"))
                else if (n == "String" && m == "StdTypes") EConst(CString(""))
                else EConst(CIdent("null"));
              case TEnum(et, _):
                var eget = et.get();
                var n = eget.name;
                var m = eget.module;
                if (n == "Bool" && m == "StdTypes") EConst(CIdent("false"))
                else EConst(CIdent("null"));
                
              default: EConst(CIdent("null"));
            }
          case None: EConst(CIdent("null"));
        }
        { type: null, name: "r" , expr:{ expr: e, pos:p}};
      };
      
      var isSet = { type:null, name: "isSet", expr: { expr: EConst(CIdent("false")), pos: p}};
      { expr: EVars([r, isSet]), pos: p};
    }
    
    var f = {
      var functionBody = {
        var ifExpr = {
          var ifCond = { expr: EUnop(Unop.OpNot, false, { expr: EConst(CIdent("isSet")), pos:p}), pos:p};
          var ifBody = {
            var block = [
              { expr : EBinop(Binop.OpAssign, constR, ex), pos:p},
              { expr : EBinop(Binop.OpAssign, { expr: EConst(CIdent("isSet")), pos:p}, { expr:EConst(CIdent("true")), pos:p}), pos:p},
            ];
            
            { expr:EBlock(block), pos:p};
          }
          {expr:EIf(ifCond, ifBody, null), pos:p};
        }
        var retExpr = { expr:EReturn(constR), pos:p};
        
        {expr:EBlock([ifExpr, retExpr]), pos:p}
      }
      { expr: EFunction(null, { args:[], ret:null, expr: functionBody, params:[]}), pos:ex.pos};
    }
    
    return { expr: EBlock([vars, f]), pos:p};
  }
  #end
  
}