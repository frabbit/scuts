package scuts1.instances.std;

import scuts1.classes.Eq;
import scuts1.classes.EqAbstract;

import scuts.core.Strings;



class StringEq extends EqAbstract<String> 
{
  public function new () {}
  
  override public inline function eq (a:String, b:String):Bool return Strings.eq(a,b);
}

