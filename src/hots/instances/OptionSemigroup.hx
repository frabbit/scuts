package hots.instances;


//import haxe.macro.Expr;
import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.classes.Semigroup;
import hots.classes.SemigroupAbstract;
import hots.extensions.OptionOfs;
import scuts.core.types.Option;

using hots.macros.Box;



class OptionSemigroup<X> extends SemigroupAbstract<Option<X>>
{
  var semi:Semigroup<X>;
  
  public function new (semi:Semigroup<X>) this.semi = semi
  
  override public inline function append (a1:Option<X>, a2:Option<X>):Option<X> 
  {
    return OptionOfs.concat(a1.box(), a2.box(), semi).unbox();
  }
  
}
