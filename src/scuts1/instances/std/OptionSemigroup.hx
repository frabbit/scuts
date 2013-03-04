package scuts1.instances.std;

import scuts1.classes.Semigroup;

import scuts.core.Options;


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
