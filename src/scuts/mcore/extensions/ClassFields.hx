package scuts.mcore.extensions;

#if macro

import haxe.macro.Context;
import haxe.macro.Type;
import scuts.core.Arrays;
import scuts.core.Bools;
import scuts.core.Strings;

using scuts.core.Strings;

class ClassFields 
{

  public static function eq(v1:ClassField, v2:ClassField) 
  {
    function eqParam (a,b) return Strings.eq(a.name, b.name) && Types.eq(a.t, b.t);
    
    var exprEq = ((v1.expr == null && v2.expr == null) || (v1.expr != null && v2.expr != null));
    
    return exprEq
      && Bools.eq(v1.isPublic, v2.isPublic)
      && FieldKinds.eq(v1.kind, v2.kind)
      && Metadatas.eq(v1.meta.get(), v2.meta.get())
      && Strings.eq(v1.name, v2.name)
      && Arrays.eq(v1.params, v2.params, eqParam)
      && Positions.eq(v1.pos, v2.pos)
      && Types.eq(v1.type, v2.type);
  }
  
}

#end