package scuts.mcore.extensions;

import haxe.macro.Context;
import haxe.macro.Type;
import scuts.core.extensions.ArrayExt;
import scuts.core.extensions.BoolExt;
import scuts.core.extensions.StringExt;

using scuts.core.extensions.StringExt;

class ClassFieldExt 
{

  public static function eq(v1:ClassField, v2:ClassField) 
  {
    // TODO Currently there is no way to compare TypedExpr
    return ((v1.expr == null && v2.expr == null) || (v1.expr != null && v2.expr != null))
      && BoolExt.eq(v1.isPublic, v2.isPublic)
      && FieldKindExt.eq(v1.kind, v2.kind)
      && MetadataExt.eq(v1.meta.get(), v2.meta.get())
      && v1.name.eq(v2.name)
      && ArrayExt.eq(v1.params, v2.params, function (a,b) return StringExt.eq(a.name, b.name) && TypeExt.eq(a.t, b.t))
      && PositionExt.eq(v1.pos, v2.pos)
      && TypeExt.eq(v1.type, v2.type);
  }
  
}