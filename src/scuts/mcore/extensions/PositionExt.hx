package scuts.mcore.extensions;

import haxe.macro.Context;
import haxe.macro.Expr;
import scuts.core.extensions.IntExt;
import scuts.core.extensions.StringExt;

class PositionExt 
{

  public static inline function nullOrCurrent (p:Position) {
    return p == null ? Context.currentPos() : p;
  }
  public static function eq (a:Position, b:Position):Bool 
  {
    var infosA = Context.getPosInfos(a);
    var infosB = Context.getPosInfos(b);
    
    return StringExt.eq(infosA.file, infosB.file)
      && IntExt.eq(infosA.min, infosB.min)
      && IntExt.eq(infosA.max, infosB.max);
  }
  
}