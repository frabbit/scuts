package scuts.mcore.extensions;

#if macro

import haxe.macro.Expr;
import scuts.core.Arrays;
import scuts.core.Strings;
import scuts.core.Option;
import scuts.mcore.extensions.Accesses;
using scuts.core.Options;
using scuts.core.Arrays;
using scuts.core.Iterables;

class Fields 
{
  public static function eq (a:Field, b:Field):Bool 
  {
    return Strings.eq(a.name,b.name)
        && ((a.doc == null && b.doc == null) || Strings.eq(a.doc, b.doc))
        && Arrays.eq(a.access, b.access, Accesses.eq)
        && FieldTypes.eq(a.kind, b.kind)
        && Positions.eq(a.pos, b.pos)
        && Metadatas.eq(a.meta, b.meta);
  }
  
  public static function isStatic (f:Field):Bool 
  {
    return f.access.elem(Access.AStatic);
  }
  
  public static function isInline (f:Field):Bool 
  {
    return f.access.elem(Access.AInline);
  }
  
  public static function isPublic (f:Field):Bool 
  {
    return f.access.elem(Access.APublic);
  }
}

#end