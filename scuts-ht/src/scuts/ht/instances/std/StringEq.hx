package scuts.ht.instances.std;

import scuts.ht.classes.Eq;
import scuts.ht.classes.EqAbstract;

import scuts.core.Strings;



class StringEq extends EqAbstract<String> 
{
  public function new () {}
  
  override public inline function eq (a:String, b:String):Bool return Strings.eq(a,b);
}

