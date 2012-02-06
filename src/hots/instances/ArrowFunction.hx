package hots.instances;
import hots.boxing.BoxCatFunction1;
import hots.classes.Arrow;
import hots.wrapper.CVal;
import scuts.core.types.Tup2;
import hots.wrapper.Mark;

using scuts.core.extensions.Function1Ext;


private typedef B = BoxCatFunction1;
 

// Arrow of Functions
class ArrowFunction extends ArrowDefault<MarkFunction>
{
  override public function id <A>(a:A):CValFunction<A, A> {
    return B.box(function (a) return a);
  }
  /**
   * aka (.)
   */
  override public function dot <A,B,C>(f:CValFunction<B, C>, g:CValFunction<A, B>):CValFunction<A, C> {
    var f1 = B.unbox(f);
    var g1 = B.unbox(g);
    return B.box(f1.compose(g1));
  }
  
  override public function arr <B,C>(f:B->C):CValFunction<B, C> {
    return B.box(f);
  }
  
  override public function first <B,C,D>(f:CValFunction<B,C>):CValFunction<Tup2<B,D>, Tup2<C,D>> {
    return arr(function (t:Tup2<B,D>) return Tup2.create(B.unbox(f)(t._1), t._2));
  }
  
  
}