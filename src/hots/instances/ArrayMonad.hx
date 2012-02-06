package hots.instances;
import hots.classes.Monad;
import hots.classes.MonadAbstract;
import hots.In;
import scuts.core.extensions.ArrayExt;

using hots.instances.ArrayBox;


class ArrayMonad {
  
  static var instance:ArrayMonadImpl;
  
  public static function get ()
  {
    if (instance == null) instance = new ArrayMonadImpl();
    return instance;
  }
}

private class ArrayMonadImpl extends MonadAbstract<Array<In>>
{
  
  public function new () super(ArrayApplicative.get())
  
  override public function flatMap<A,B>(fa:ArrayOf<A>, f: A->ArrayOf<B>):ArrayOf<B> 
  {
    return ArrayExt.flatMap(fa.unbox(), f.unboxF()).box();
  }
    
}