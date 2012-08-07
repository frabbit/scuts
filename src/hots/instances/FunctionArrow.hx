package hots.instances;
import hots.box.FunctionBox;
import hots.In;
import hots.classes.ArrowAbstract;
import scuts.core.types.Tup2;
import hots.instances.FunctionCategory;
using scuts.core.extensions.Functions;

private typedef B = FunctionBox;
 
// Arrow of Functions
class FunctionArrow extends ArrowAbstract<In->In>
{
  public function new () {
    super(FunctionCategory.get());
  }
  
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
