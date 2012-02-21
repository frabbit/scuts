package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;
import hots.macros.TypeClasses;
import scuts.core.extensions.StringExt;



class StringEqImpl extends EqAbstract<String> 
{
  public function new () {}
  
  override public inline function eq (a:String, b:String):Bool return StringExt.eq(a,b)
}


typedef StringEq = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(StringEqImpl)]>;