package hots.instances;
import hots.instances.ArrayOfApplicative;
import hots.classes.Monad;
import hots.classes.MonadAbstract;
import hots.extensions.ArrayOfs;
import hots.In;
import scuts.core.extensions.Arrays;


using hots.box.ArrayBox;

class ArrayOfMonad extends MonadAbstract<Array<In>>
{
  
  public function new () super(ArrayOfApplicative.get())
  
  override public function flatMap<A,B>(of:ArrayOf<A>, f: A->ArrayOf<B>):ArrayOf<B> 
  {
    return ArrayOfs.flatMap(of, f);
  }
    
}
