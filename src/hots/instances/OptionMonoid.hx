package hots.instances;


//import haxe.macro.Expr;
import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.extensions.OptionOfExt;
import scuts.core.types.Option;

using hots.macros.Box;



class OptionMonoid<X> extends MonoidAbstract<Option<X>>
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
