package hots.instances;
using scuts.core.extensions.Function1Ext;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;


class DualMonoidImpl<T> extends MonoidAbstract<T>
{
  var monoid:Monoid<T>;
  
  public function new (m:Monoid<T>) 
    this.monoid = m
  
  override public inline function append (a:T, b:T):T {
    return monoid.append(b, a);
  }
  
  override public inline function empty ():T {
    return monoid.empty();
  }
}

typedef DualMonoid = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(DualMonoidImpl)]>;