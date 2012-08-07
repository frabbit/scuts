package scuts.mcore.extensions;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)

import haxe.macro.Expr;
import scuts.core.extensions.Strings;
import scuts.mcore.Make;

private typedef AnonField = { field : String, expr : Expr };

class AnonFields
{
  public static function eq (a:AnonField, b:AnonField):Bool 
  {
    return Strings.eq(a.field, b.field) && Exprs.eq(a.expr, b.expr);
  }
  
  public static function next (cur:AnonField, field:String, expr:Expr):Array<AnonField>
  {
    return [cur, Make.anonField(field, expr)];
  }
}

class ArrayAnonObjFields 
{
  public static function addBack (cur:Array<AnonField>, field:String, expr:Expr):Array<AnonField>
  {
    return cur.concat([Make.anonField(field, expr)]);
  }
  
  public static function addFront (cur:Array<AnonField>, field:String, expr:Expr):Array<AnonField>
  {
    return [Make.anonField(field, expr)].concat(cur);
  }
  
  public static function toObjectDecl (cur:Array<AnonField>, ?pos:Position)
  {
    return Make.anon(cur, pos);
  }
  
}

#end