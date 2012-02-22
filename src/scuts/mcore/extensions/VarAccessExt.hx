package scuts.mcore.extensions;

import haxe.macro.Type;
import scuts.core.extensions.StringExt;

class VarAccessExt 
{

  public static function eq(v1:VarAccess, v2:VarAccess) 
  {
    return switch (v1) 
    {
      case AccCall(m1):    switch (v2) { case AccCall(m2):    StringExt.eq(m1, m2); default: false; }
      case AccInline:      switch (v2) { case AccInline:      true;                 default: false; }
      case AccNever:       switch (v2) { case AccNever:       true;                 default: false; }
      case AccNo:          switch (v2) { case AccNo:          true;                 default: false; }
      case AccNormal:      switch (v2) { case AccNormal:      true;                 default: false; }
      case AccRequire(r1): switch (v2) { case AccRequire(r2): StringExt.eq(r1, r2); default: false; }
      case AccResolve:     switch (v2) { case AccResolve:     true;                 default: false; }
    }
  }
  
}