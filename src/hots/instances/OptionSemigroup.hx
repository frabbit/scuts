package hots.instances;

import hots.classes.Semigroup;

import scuts.core.Options;
import scuts.core.Option;

class OptionSemigroup<X> implements Semigroup<Option<X>>
{
  var semi:Semigroup<X>;
  
  public function new (semi) 
  {
    this.semi = semi;
  }
  
  public inline function append (a1:Option<X>, a2:Option<X>):Option<X> 
  {
    return Options.append(a1, a2, semi.append);
  }
}
