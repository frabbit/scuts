package hots.instances;


//import haxe.macro.Expr;
import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.classes.Semigroup;
import hots.extensions.OptionOfExt;
import scuts.core.types.Option;

using hots.macros.Box;



class OptionMonoid<X> extends MonoidAbstract<Option<X>>
{
  
  public function new (semi:Semigroup<X>) super(OptionSemigroup.get(semi))
  
  
  override public inline function empty ():Option<X> {
    return None;
  }
}
