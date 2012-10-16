package scuts.mcore.extensions;

#if macro

import scuts.core.Arrays;
import scuts.core.Strings;
import haxe.macro.Expr;

private typedef MetadataEntry = { name : String, params : Array<Expr>, pos : Position };

class MetadataEntryExt 
{
  public static function eq (a:MetadataEntry, b:MetadataEntry):Bool 
  {
    return Strings.eq(a.name, b.name)
      && Positions.eq(a.pos, b.pos)
      && Arrays.eq(a.params, b.params, Exprs.eq);
  }
  
}

class Metadatas 
{

  public static function eq (a:Metadata, b:Metadata):Bool 
  {
    return Arrays.eq(a,b, MetadataEntryExt.eq);
  }
  
}

#end