package hots.instances;

import hots.classes.Arrow;
import hots.classes.ArrowAbstract;
import hots.classes.Monad;
import hots.In;
import hots.instances.KleisliCategory;
import hots.Of;
import hots.of.KleisliOf;

import scuts.core.Tup2;
import scuts.Scuts;

using scuts.core.Functions;

private typedef B = hots.box.KleisliBox;

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
      var f1 = B.unbox(f);
      return m.flatMap(m.pure(t), function (t) 
      {
        var d = f1(t._1);
        return m.map(d, function (c) return Tup2.create(c,t._2)); 
      });
    };
  }
}
