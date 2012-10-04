package scuts.mcore.extensions;

#if macro

import haxe.macro.Expr;

class Accesses 
{

  public static function eq (a:Access, b:Access):Bool 
  {
    return switch (a) {
      case AInline:   switch (b) { case AInline:   true; default: false;}
      case ADynamic:  switch (b) { case ADynamic:  true; default: false;}
      case AStatic:   switch (b) { case AStatic:   true; default: false;}
      case APublic:   switch (b) { case APublic:   true; default: false;}
      case APrivate:  switch (b) { case APrivate:  true; default: false;}
      case AOverride: switch (b) { case AOverride: true; default: false;}
    }
  }
  
}

#end