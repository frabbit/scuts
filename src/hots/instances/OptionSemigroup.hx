package hots.instances;

import hots.classes.Monoid;
import hots.classes.MonoidAbstract;
import hots.classes.Semigroup;
import hots.classes.SemigroupAbstract;
import scuts.core.extensions.Options;
import scuts.core.types.Option;

class OptionSemigroup<X> extends SemigroupAbstract<Option<X>>
{
  var semi:Semigroup<X>;
  
  public function new (semi) 
  {
    this.semi = semi;
  }
  
  override public inline function append (a1:Option<X>, a2:Option<X>):Option<X> 
  {
    return Options.append(a1, a2, semi.append);
  }
  
}
