package hots.instances;
import hots.classes.Monad;
import hots.classes.MonadAbstract;
import hots.extensions.ArrayOfExt;
import hots.In;
import scuts.core.extensions.ArrayExt;

using hots.box.ArrayBox;

class ArrayOfMonad extends MonadAbstract<Array<In>>
{
  
  public function new () super(ArrayOfApplicative.get())
  
  override public function flatMap<A,B>(of:ArrayOf<A>, f: A->ArrayOf<B>):ArrayOf<B> 
  {
    return ArrayOfExt.flatMap(of, f);
  }
    
}
