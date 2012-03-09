package scuts.core.macros;

#if (macro || display)
import haxe.macro.Expr.ExprRequire;
import haxe.macro.Expr;
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
    
    var vars = {
      var r = { type: null, name: "r" , expr:{ expr: EConst(CIdent("null")), pos:p}};
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