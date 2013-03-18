package scuts.mcore.ast;

#if macro

import haxe.macro.Type;
import scuts.core.Strings;

class VarAccesses 
{

  public static function eq(v1:VarAccess, v2:VarAccess) return switch [v1,v2]
  {
    case [AccCall(m1), AccCall(m2)]: Strings.eq(m1, m2);
    case [AccInline, AccInline] : true;
    case [AccNever, AccNever] : true;
    case [AccNo, AccNo] : true;
    case [AccNormal, AccNormal] : true;
    case [AccResolve, AccResolve] : true;
    case [AccRequire(r1, msg1), AccRequire(r2, msg2)]: Strings.eq(r1, r2) && Strings.eq(msg1, msg2);
    case _ : false;
  }
  
}

#end