package hots.instances;


import hots.classes.Monoid;
import hots.classes.MonoidAbstract;

import scuts.core.types.Tup2;

class Tup2MonoidImpl<A,B> extends MonoidAbstract<Tup2<A,B>>
{
  private var m1:Monoid<A>;
  private var m2:Monoid<B>;
  
  public function new (m1:Monoid<A>, m2:Monoid<B>) {
    this.m1 = m1;
    this.m2 = m2;
  }
  
  override public inline function append (a:Tup2<A,B>, b:Tup2<A,B>):Tup2<A,B> 
  {
    return Tup2.create(m1.append(a._1, b._1), m2.append(a._2, b._2));
  }
  
  override public inline function empty ():Tup2<A,B> 
  {
    return Tup2.create(m1.empty(), m2.empty());
  }
}

typedef Tup2Monoid = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(Tup2MonoidImpl)]>;