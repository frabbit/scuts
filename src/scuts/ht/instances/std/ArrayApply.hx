package scuts.ht.instances.std;

import scuts.ht.classes.Apply;
import scuts.ht.core.In;
import scuts.ht.classes.Applicative;
import scuts.ht.instances.std.ArrayOf;

using scuts.ht.syntax.Arrays;

class ArrayApply implements Apply<Array<In>>
{
  public function new () {}
  
  public function apply<B,C>(f:ArrayOf<B->C>, v:ArrayOf<B>):ArrayOf<C> 
  {
    var res = [];
    
    for (f1 in f.unbox()) for (v1 in v.unbox()) res.push(f1(v1));
    return res;
  }
}
