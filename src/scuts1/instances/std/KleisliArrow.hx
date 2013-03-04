package scuts1.instances.std;

import scuts1.classes.Arrow;
import scuts1.classes.ArrowAbstract;
import scuts1.classes.Monad;
import scuts1.core.In;
import scuts1.instances.std.KleisliCategory;
import scuts1.core.Of;
import scuts1.instances.std.KleisliOf;

import scuts.core.Tuples;
import scuts.Scuts;

using scuts.core.Functions;



class KleisliArrow<M> extends ArrowAbstract<In->Of<M,In>>
{
  var m:Monad<M>;
  
  public function new (m:Monad<M>, cat) 
  {
    super(cat);
    this.m = m;
  }
  
  override public function arr <B,C>(f:B->C):KleisliOf<M,B, C> 
  {
    return m.pure.compose(f);
  }
  
  override public function first <B,C,D>(f:KleisliOf<M,B,C>):KleisliOf<M, Tup2<B,D>, Tup2<C,D>> 
  {
    return function (t:Tup2<B,D>) 
    {
      var f1 = f.unbox();
      return m.flatMap(m.pure(t), function (t) 
      {
        var d = f1(t._1);
        return m.map(d, function (c) return Tup2.create(c,t._2)); 
      });
    };
  }
}
