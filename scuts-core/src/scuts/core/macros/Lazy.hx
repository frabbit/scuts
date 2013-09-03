package scuts.core.macros;



#if (macro)
import haxe.macro.Expr.ExprOf;
import haxe.macro.Expr;
import haxe.macro.Type;
import scuts.core.Options;
#end
class Lazy 
{

  #if !macro macro #end public static function expr(ex:Expr):Expr 
  {
    return mkExpr(ex);
  }
  
  #if (macro)
  public static function mkExpr (ex:Expr):Expr 
  {
    var type = try Some(haxe.macro.Context.typeof(ex)) catch (e:Dynamic) None;
    
    var r = switch (type) 
    {
      case Some(TInst(ct, _)):
        var cget = ct.get();
        var n = cget.name;
        var m = cget.module;
        var modStdTypes = m == "StdTypes";
        
        switch (n) 
        {
          case "Int"    if (modStdTypes): macro 0; 
          case "Float"  if (modStdTypes): macro 0.0;
          case "String" if (modStdTypes): macro "";
          case _:                         macro null;
        }
        case Some(TEnum(et, _)):
          var eget = et.get();
          var n = eget.name;
          var m = eget.module;
          
          if (n == "Bool" && m == "StdTypes") macro false else macro null;
        case _: macro null;
    };

    return macro @:pos(ex.pos) 
    {
      var r = $r;
      var isSet = false;
      function () 
      {
        if (!isSet) 
        {
          r = $ex;
          isSet = true;
        }
        return r;
      };
    }
  }
  #end
  
}
