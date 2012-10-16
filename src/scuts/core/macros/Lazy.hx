package scuts.core.macros;

#if (macro)
import haxe.macro.Expr.ExprRequire;
import haxe.macro.Expr;
import haxe.macro.Type;
import scuts.core.Option;
#end
class Lazy 
{

  @:macro public static function expr(ex:Expr):Expr 
  {
    return mkExpr(ex);
  }
  
  #if (macro)
  public static function mkExpr (ex:Expr):Expr 
  {
    var p = ex.pos;
    var constR = { expr: EConst(CIdent("r")), pos: p};
    
    var type = try Some(haxe.macro.Context.typeof(ex)) catch (e:Dynamic) None;

    var constNull = EConst(CIdent("null"));
    
    var vars = 
    {
      var r = 
      {
        var e = switch (type) 
        {
          case Some(t): switch (t) 
          {
            case TInst(ct, _): 
              var cget = ct.get();
              var n = cget.name;
              var m = cget.module;
              var modStdTypes = m == "StdTypes";
              
              switch (true) {
                case n == "Int"    && modStdTypes: EConst(CInt("0"));
                case n == "Float"  && modStdTypes: EConst(CFloat("0.0"));
                case n == "String" && modStdTypes: EConst(CString(""));
                default:                           constNull;
              }
            case TEnum(et, _):
              var eget = et.get();
              var n = eget.name;
              var m = eget.module;
              
              if (n == "Bool" && m == "StdTypes") 
                EConst(CIdent("false"))
              else 
                constNull;
              
            default: constNull;
          }
          case None: constNull;
        }
        { type: null, name: "r" , expr:{ expr: e, pos:p}};
      };
      
      var isSet = { type:null, name: "isSet", expr: { expr: EConst(CIdent("false")), pos: p}};
      { expr: EVars([r, isSet]), pos: p};
    }
    
    var f = 
    {
      var functionBody = 
      {
        var ifExpr = 
        {
          var ifCond = { expr: EUnop(Unop.OpNot, false, { expr: EConst(CIdent("isSet")), pos:p}), pos:p};
          var ifBody = 
          {
            var block = 
            [
              { expr : EBinop(Binop.OpAssign, constR, ex), pos:p},
              { expr : EBinop(Binop.OpAssign, { expr: EConst(CIdent("isSet")), pos:p}, { expr:EConst(CIdent("true")), pos:p}), pos:p},
            ];
            
            { expr:EBlock(block), pos:p};
          }
          
          {expr:EIf(ifCond, ifBody, null), pos:p};
        }
        
        var retExpr = { expr:EReturn(constR), pos:p};
        {expr:EBlock([ifExpr, retExpr]), pos:p }
        
      }
      
      { expr: EFunction(null, { args:[], ret:null, expr: functionBody, params:[]}), pos:ex.pos};
    }
    
    return { expr: EBlock([vars, f]), pos:p};
  }
  #end
  
}