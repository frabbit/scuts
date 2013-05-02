package scuts.ht.macros.implicits;

#if macro


import haxe.macro.Expr;
import haxe.macro.Context;

class DisplayResolver 
{
  public static function resolve (f:Expr, args:Array<Expr>,?numArgs:Int = -1) 
  {
    var numArgs = if (numArgs != -1) {
      numArgs;
    } else {
      var t = try Context.typeof(f) catch (e:Dynamic) null;
      if (t != null) {
        switch (t) {
          case TFun(fargs, _):
            
            fargs.length
          case _ : -1
        }
      } else -1;
    }

    return if (numArgs != -1) {
      var len = numArgs - args.length;
      var hasWildCards = false;
      for (a in args) {
        switch (a.expr) {
          case EConst(CIdent("_")): 
            hasWildCards = true;
            break;
          case _:
        }
      }
      for (l in 0...len) {
        args.push(macro null);
      }
      var f1 = if (hasWildCards) macro $f.bind else f;
      var res = macro $f1($a{args});
      res;
    } else {
      macro $f($a{args});  
    }
    
  }

  public static function resolveImplicitObjByType (t:String):Expr 
  {
    return Context.parse(" { var e : " + t + " = null; e; } ", Context.currentPos());
  }

  public static function resolveImplicitObj (required:Expr) {
    return required;
  }

}

#end