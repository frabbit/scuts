package hots.instances;


import haxe.macro.Expr;
import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.extensions.OptionOfExt;
import scuts.core.types.Option;

using hots.instances.OptionBox;




class OptionMonoid
{
  static var hash:Hash<Monoid<Dynamic>> = new Hash();
  
  @:macro public static function get <S>(monoid:haxe.macro.Expr.ExprRequire<Monoid<S>>):haxe.macro.Expr {
    return getM(monoid);
  }
  #if macro
  public static function getM <S>(monoid:Expr):haxe.macro.Expr {
    return hots.macros.TypeClasses.forType([monoid], "Hash<hots.classes.Monoid<Dynamic>>", "hots.instances.OptionMonoidImpl", "hots.instances.OptionMonoid");
  }
  #end

}

//typedef OptionMonoid = haxe.macro.MacroType<[hots.macros.TypeClasses.get(OptionMonoidImpl)]>;


class OptionMonoidImpl<X> extends MonoidAbstract<Option<X>>
{
  var monoid:Monoid<X>;
  
  public function new (monoid:Monoid<X>) this.monoid = monoid
  
  override public inline function append (a:Option<X>, b:Option<X>):Option<X> {
    return OptionOfExt.concat(a.box(), b.box(), monoid).unbox();
  }
  override public inline function empty ():Option<X> {
    return None;
  }
}

typedef OptionMonoidProvider = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(hots.instances.OptionMonoidImpl)]>;
