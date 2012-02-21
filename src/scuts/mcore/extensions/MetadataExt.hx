package scuts.mcore.extensions;
import scuts.core.extensions.ArrayExt;
import scuts.core.extensions.StringExt;
import haxe.macro.Expr;

private typedef MetadataEntry = { name : String, params : Array<Expr>, pos : Position };

class MetadataEntryExt 
{
  public static inline function eq (a:MetadataEntry, b:MetadataEntry):Bool 
  {
    return StringExt.eq(a.name, b.name)
      && PositionExt.eq(a.pos, b.pos)
      && ArrayExt.eq(a.params, b.params, ExprExt.eq);
  }
  
}

class MetadataExt 
{

  public static inline function eq (a:Metadata, b:Metadata):Bool 
  {
    return ArrayExt.eq(a,b, MetadataEntryExt.eq);
  }
  
}