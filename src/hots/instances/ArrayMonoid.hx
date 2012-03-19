package hots.instances;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;




class ArrayMonoidImpl<T> extends MonoidAbstract<Array<T>>
{
  public function new () {}
  
  override public inline function append (a:Array<T>, b:Array<T>):Array<T> {
    return a.concat(b);
  }
  override public inline function empty ():Array<T> {
    return [];
  }

}

//typedef ArrayMonoid = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(ArrayMonoidImpl)]>;
