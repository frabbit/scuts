package hots.instances;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.extensions.ArrayOfExt;


using hots.extensions.ArrayOfExt;


class ArrayOfMonoidImpl<T> extends MonoidAbstract<ArrayOf<T>>
{
  public function new () {}
  
  override public inline function append (a:ArrayOf<T>, b:ArrayOf<T>):ArrayOf<T> {
    return a.concat(b);
  }
  override public inline function empty ():ArrayOf<T> {
    return ArrayOfExt.empty();
  }

}

typedef ArrayOfMonoid = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(ArrayOfMonoidImpl)]>;