package scuts.mcore.extensions;

import haxe.macro.Type;
import scuts.core.extensions.StringExt;

using scuts.core.extensions.StringExt;
using scuts.core.extensions.BoolExt;
using scuts.core.extensions.ArrayExt;
using scuts.mcore.extensions.TypeExt;
class DefTypeExt 
{

  public static function eq(t1:DefType, t2:DefType) 
  {
    return t1.module.eq(t2.module)
        && t1.name.eq(t2.name)
        && t1.isExtern.eq(t2.isExtern)
        && t1.isPrivate.eq(t2.isPrivate)
        && t1.pack.eq(t2.pack, StringExt.eq)
        && t1.type.eq(t2.type);
  }
  
}