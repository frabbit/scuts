package scuts.mcore.ast;

#if macro

import haxe.macro.Expr;
import scuts.core.Strings;
import scuts.core.Options;

class Constants 
{

  public static function eq (a:Constant, b:Constant):Bool 
  {
    var eqStr = Strings.eq;
    
    return switch [a,b] 
    {
      case [CInt(v1),          CInt(v2)]:          eqStr(v1,v2);
      case [CFloat(f1),        CFloat(f2)]:        eqStr(f1,f2);
      case [CString(s1),       CString(s2)]:       eqStr(s1,s2);
      case [CIdent(s1),        CIdent(s2)]:        eqStr(s1,s2);
      case [CRegexp(r1, opt1), CRegexp(r2, opt2)]: eqStr(r1, r2) && eqStr(opt1, opt2);
      case _ : false;
    }
  }
  
  public static function selectCIdentValue (c:Constant):Option<String> return switch (c) 
  {
    case CIdent(s): Some(s);
    default: None;
  }
  
}

#end