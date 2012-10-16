package scuts.mcore.extensions;

import haxe.macro.Context;
import haxe.macro.Expr;
import scuts.mcore.Convert;
import scuts.mcore.Make;
import scuts.mcore.Parse;

using scuts.core.Dynamics;

class Strings 
{

  public static function parse(s:String, ?context:Dynamic, ?pos:Position) 
  {
    return Parse.parse(s, context, pos);
  }
  
  public static function parseToType(s:String, ?context:Dynamic, ?pos:Position) 
  {
    return Parse.parseToType(s, context, pos);
  }
  
  public static function asConstIdent(s:String, ?pos:Position) 
  {
    return Make.constIdent(s, pos);
  }
  
  public static function toType(s:String, ?pos:Position) 
  {
    var p = pos.nullGetOrElseConst(Context.currentPos());
    return Context.parse("{v: " + s + " = null; s}", p);
  }
  
}