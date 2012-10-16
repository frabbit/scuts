package scuts.mcore.extensions;

#if macro

import haxe.macro.Type;
import scuts.core.Strings;

using scuts.core.Strings;
using scuts.core.Bools;
using scuts.core.Arrays;
using scuts.mcore.extensions.Types;

class DefTypes 
{

  public static function eq(t1:DefType, t2:DefType) 
  {
    return t1.module.eq(t2.module)
        && t1.name.eq(t2.name)
        && t1.isExtern.eq(t2.isExtern)
        && t1.isPrivate.eq(t2.isPrivate)
        && t1.pack.eq(t2.pack, Strings.eq)
        && t1.type.eq(t2.type);
  }
  
}

#end