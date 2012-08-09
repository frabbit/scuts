package hots.instances;
import hots.Identity;
import hots.instances.ArrayOfApplicative;
import hots.classes.Monad;
import hots.classes.MonadAbstract;
import hots.In;
import hots.Objects;
import scuts.core.extensions.Arrays;


using hots.box.ArrayBox;

class ArrayOfMonad extends MonadAbstract<Array<In>>
{
  
  public function new (app) super(app)
  
  override public function flatMap<A,B>(of:ArrayOf<A>, f: A->ArrayOf<B>):ArrayOf<B> 
  {

    return Arrays.flatMap(of.unbox(), f.unboxF()).box();
    /*
    var x =  of.flatMap(f);
    $type(x);
    return x;
    */
  }
    
}
