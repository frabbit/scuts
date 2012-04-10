package hots.instances;
import hots.box.FunctionBox;
import hots.In;
import hots.classes.ArrowAbstract;
import scuts.core.types.Tup2;

using scuts.core.extensions.FunctionExt;

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
  override public function arr <B,C>(f:B->C):FunctionOf<B, C> {
    return B.asArrow(f);
  }
  /**
   * the first function
   */
  override public function first <B,C,D>(f:FunctionOf<B,C>):FunctionOf<Tup2<B,D>, Tup2<C,D>> {
    return arr(function (t:Tup2<B,D>) return Tup2.create(B.runArrow(f)(t._1), t._2));
  }
  
  
}
