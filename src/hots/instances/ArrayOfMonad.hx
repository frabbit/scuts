package hots.instances;
import hots.classes.Monad;
import hots.classes.MonadAbstract;
import hots.In;
import scuts.core.extensions.ArrayExt;

using hots.macros.Box;

class ArrayOfMonad extends MonadAbstract<Array<In>>
{
  
  public function new () super(ArrayOfApplicative.get())
  
  override public function flatMap<A,B>(fa:ArrayOf<A>, f: A->ArrayOf<B>):ArrayOf<B> 
  {
    return ArrayExt.flatMap(fa.unbox(), f.unboxF()).box();
  }
    
}
