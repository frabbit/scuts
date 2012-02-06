package hots.instances;
using scuts.core.extensions.Function1Ext;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;

import scuts.Scuts;

#if (macro || display)
import hots.macros.TypeClasses;
import haxe.macro.Expr;
#end


class DualMonoid
{
  static var hash:Hash<Monoid<Dynamic>> = new Hash();
  
  @:macro public static function get <S>(mon:ExprRequire<Monoid<S>>):Expr {
    return TypeClasses.forType([mon], "Hash<Monoid<Dynamic>>", "hots.instances.DualMonoidImpl", "hots.instances.DualMonoid");
  }
  
}

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