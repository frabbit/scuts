package scuts.mcore.extensions;

import haxe.macro.Type;
import scuts.core.extensions.Strings;

using scuts.core.extensions.Strings;
using scuts.core.extensions.Bools;
using scuts.core.extensions.Arrays;
class ClassTypes 
{

  public static function eq(t1:ClassType, t2:ClassType) 
  {
    return t1.module.eq(t2.module)
        && t1.name.eq(t2.name)
        && t1.isExtern.eq(t2.isExtern)
        && t1.isInterface.eq(t2.isInterface)
        && t1.isPrivate.eq(t2.isPrivate)
        && t1.pack.eq(t2.pack, Strings.eq);
  }
  
}