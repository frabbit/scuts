package scuts.mcore.extensions;

#if macro

import haxe.macro.Expr;
import scuts.core.Strings;
import scuts.core.Option;

class Constants 
{

  public static function eq (a:Constant, b:Constant):Bool 
  {
    var eqStr = Strings.eq;
    
    return switch (a) 
    {
      case CInt(v1):          switch (b) { case CInt(v2):          eqStr(v1, v2);                      default: false; };
      case CFloat(f1):        switch (b) { case CFloat(f2):        eqStr(f1, f2);                      default: false; };
      case CString(s1):       switch (b) { case CString(s2):       eqStr(s1, s2);                      default: false; };
      case CIdent(s1):        switch (b) { case CIdent(s2):        eqStr(s1, s2);                      default: false; };
      case CType(s1):         switch (b) { case CType(s2):         eqStr(s1, s2);                      default: false; };
      case CRegexp(r1, opt1): switch (b) { case CRegexp(r2, opt2): eqStr(r1, r2) && eqStr(opt1, opt2); default: false; };
    }
  }
  
  public static function selectCIdentValue (c:Constant):Option<String> return switch (c) 
  {
    case CIdent(s): Some(s);
    default: None;
  }
  
}

#end