package scuts1.instances.std;

import scuts1.classes.Apply;
import scuts1.core.In;
import scuts1.classes.Applicative;
import scuts1.instances.std.ArrayOf;

using scuts1.syntax.Arrays;

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
