package scuts.mcore.extensions;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)
import haxe.macro.Expr;
import scuts.core.extensions.Arrays;
import scuts.core.extensions.Strings;
import scuts.core.types.Option;
import scuts.mcore.extensions.AccessExt;
using scuts.core.extensions.Options;
using scuts.core.extensions.Arrays;
using scuts.core.extensions.Iterables;

class FieldExt 
{

  public static function eq (a:Field, b:Field):Bool 
  {
    return Strings.eq(a.name,b.name)
        && ((a.doc == null && b.doc == null) || Strings.eq(a.doc, b.doc))
        && Arrays.eq(a.access, b.access, AccessExt.eq)
        && FieldTypeExt.eq(a.kind, b.kind)
        && PositionExt.eq(a.pos, b.pos)
        && MetadataExt.eq(a.meta, b.meta);
        
  }
  
  public static function isStatic (f:Field):Bool {
    return f.access.elem(Access.AStatic);
  }
  
  public static function isInline (f:Field):Bool {
    return f.access.elem(Access.AInline);
  }
  
  public static function isPublic (f:Field):Bool {
    return f.access.elem(Access.APublic);
  }
  
  public static function isMethod (f:Field):Bool {
    return getMethod(f).isSome();
  }
  
  public static function flatCopy (f:Field):Field {
    return {
      access : f.access,
      doc: f.doc,
      kind: f.kind,
      meta: f.meta,
      name: f.name,
      pos: f.pos
    }
  }
  
  
  public static function getMethod (f:Field):Option<Function>
  {
    return switch (f.kind) {
      case FieldType.FFun(f):Some(f);
      case FieldType.FVar(_,_): None;
      case FieldType.FProp(_,_,_,_): None;
    }
  }
  
}

#end