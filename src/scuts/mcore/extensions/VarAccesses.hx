package scuts.mcore.extensions;

#if macro

import haxe.macro.Type;
import scuts.core.Strings;

class VarAccesses 
{

  public static function eq(v1:VarAccess, v2:VarAccess) return switch v1 
  {
    case AccCall(m1):    switch v2 { case AccCall(m2):    Strings.eq(m1, m2); default: false; }
    case AccInline:      switch v2 { case AccInline:      true;                 default: false; }
    case AccNever:       switch v2 { case AccNever:       true;                 default: false; }
    case AccNo:          switch v2 { case AccNo:          true;                 default: false; }
    case AccNormal:      switch v2 { case AccNormal:      true;                 default: false; }
    case AccRequire(r1, msg1): switch v2 { case AccRequire(r2, msg2): Strings.eq(r1, r2) && Strings.eq(msg1, msg2); default: false; }
    case AccResolve:     switch v2 { case AccResolve:     true;                 default: false; }
  }
  
}

#end