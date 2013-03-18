package scuts.ht.instances.std;
import scuts.ht.core.In;
import scuts.ht.classes.ArrowAbstract;
import scuts.ht.instances.std.FunctionOfOf;
import scuts.core.Tuples;
import scuts.ht.instances.std.FunctionCategory;
using scuts.core.Functions;


 
// Arrow of Functions
class FunctionArrow extends ArrowAbstract<In->In>
{
  public function new (cat) super(cat);
  
  /**
   * @inheritDoc
   */
  override public inline function arr <B,C>(f:B->C):FunctionOfOf<B, C> 
  {
    return f;
  }
  /**
   * the first function
   */
  override public function first <B,C,D>(f:FunctionOfOf<B,C>):FunctionOfOf<Tup2<B,D>, Tup2<C,D>> 
  {
    return arr(function (t:Tup2<B,D>) return Tup2.create(f.unbox()(t._1), t._2));
  }
    
}
