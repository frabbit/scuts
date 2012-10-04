package scuts.mcore.extensions;

#if macro

import haxe.macro.Type;

class MethodKinds 
{

  public static function eq(v1:MethodKind, v2:MethodKind) return switch (v1) 
  {
    case MethDynamic: switch (v2) { case MethDynamic: true; default: false; }
    case MethInline:  switch (v2) { case MethInline:  true; default: false; }
    case MethMacro:   switch (v2) { case MethMacro:   true; default: false; }
    case MethNormal:  switch (v2) { case MethNormal:  true; default: false; }
  }
  
}

#end