package hots.instances;
import hots.In;
import hots.classes.ArrowAbstract;
import hots.of.FunctionOfOf;
import scuts.core.Tup2;
import hots.instances.FunctionCategory;
using scuts.core.Functions;

private typedef B = hots.box.FunctionBox;
 
// Arrow of Functions
class FunctionArrow extends ArrowAbstract<In->In>
{
  public function new (cat) super(cat)
  
  /**
   * @inheritDoc
   */
  override public inline function arr <B,C>(f:B->C):FunctionOfOf<B, C> 
  {
    return B.asArrow(f);
  }
  /**
   * the first function
   */
  override public function first <B,C,D>(f:FunctionOfOf<B,C>):FunctionOfOf<Tup2<B,D>, Tup2<C,D>> 
  {
    return arr(function (t:Tup2<B,D>) return Tup2.create(B.runArrow(f)(t._1), t._2));
  }
    
}
