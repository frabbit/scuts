package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;

import scuts.core.extensions.Strings;



class StringEq extends EqAbstract<String> 
{
  public function new () {}
  
  override public inline function eq (a:String, b:String):Bool return Strings.eq(a,b)
}

