package scuts.mcore.extensions;

import haxe.macro.Expr;
import scuts.core.extensions.ArrayExt;
import scuts.core.extensions.StringExt;

class TypePathExt 
{

  public static function eq (a:TypePath, b:TypePath):Bool 
  {
    return StringExt.eq(a.name,b.name)
        && ArrayExt.eq(a.pack, b.pack, StringExt.eq)
        && ((a.sub == null && b.sub == null) || StringExt.eq(a.sub, b.sub))
        && ArrayExt.eq(a.params, b.params, TypeParamExt.eq);
  }
  
}