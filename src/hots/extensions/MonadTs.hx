package hots.extensions;
import hots.box.OptionBox;
import hots.classes.Monad;
import hots.Implicit;
import hots.In;
import hots.instances.OptionTOf;
import hots.Of;
import hots.OfOf;
import scuts.core.types.Option;

private typedef IMonad<X> = Implicit<Monad<X>>;

class MonadTs 
{

  public static function optionT<M,T>(o:Of<M, Option<T>>):OptionTOf<M,T>
  {
    return OptionBox.boxT(o);
  }
  
  public static function liftOptionT<M,T>(o:X->Option<T>):X->OptionTOf<M,T>
  {
    return OptionBox.boxT(o);
  }
  
  public static function runOptionT<M,T>(o:OptionTOf<M,T>):Of<M, Option<T>>
  {
    return OptionBox.unboxT(o);
  }
  
}