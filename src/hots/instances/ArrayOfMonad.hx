package hots.instances;
import hots.classes.Monad;
import hots.classes.MonadAbstract;
import hots.In;
import scuts.core.extensions.ArrayExt;

using hots.instances.ArrayBox;

private class ArrayOfMonadImpl extends MonadAbstract<Array<In>>
{
  
  public function new () super(ArrayOfApplicative.get())
  
  override public function flatMap<A,B>(fa:ArrayOf<A>, f: A->ArrayOf<B>):ArrayOf<B> 
  {
    return ArrayExt.flatMap(fa.unbox(), f.unboxF()).box();
  }
    
}

typedef ArrayOfMonad = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(ArrayOfMonadImpl)]>;