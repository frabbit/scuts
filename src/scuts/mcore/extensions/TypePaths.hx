package scuts.mcore.extensions;

#if macro

import haxe.macro.Expr;
import scuts.core.Arrays;
import scuts.core.Strings;

class TypePaths 
{

  public static function eq (a:TypePath, b:TypePath):Bool 
  {
    return Strings.eq(a.name,b.name)
        && Arrays.eq(a.pack, b.pack, Strings.eq)
        && ((a.sub == null && b.sub == null) || Strings.eq(a.sub, b.sub))
        && Arrays.eq(a.params, b.params, TypeParams.eq);
  }
  
}

#end