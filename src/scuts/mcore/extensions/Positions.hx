package scuts.mcore.extensions;

#if macro

import haxe.macro.Context;
import haxe.macro.Expr;
import scuts.core.Ints;
import scuts.core.Strings;

class Positions 
{

  public static inline function nullOrCurrent (p:Position) 
  {
    return p == null ? Context.currentPos() : p;
  }
  
  public static function eq (a:Position, b:Position):Bool 
  {
    var infosA = Context.getPosInfos(a);
    var infosB = Context.getPosInfos(b);
    
    return Strings.eq(infosA.file, infosB.file)
      && Ints.eq(infosA.min, infosB.min)
      && Ints.eq(infosA.max, infosB.max);
  }
  
}

#end