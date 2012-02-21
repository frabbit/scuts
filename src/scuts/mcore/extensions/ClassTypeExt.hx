package scuts.mcore.extensions;

import haxe.macro.Type;

class ClassTypeExt 
{

  public static function equals(t1:ClassType, t2:ClassType) 
  {
    return t1.module == t2.module
        && t1.name == t2.name;
  }
  
}