package hots.instances;

import hots.classes.MonadAbstract;
import hots.In;
import hots.of.OptionOf;
import scuts.core.extensions.Options;
import scuts.core.types.Option;



class OptionMonad extends MonadAbstract<Option<In>>
{
  public function new (app) super(app)
  
  override public function flatMap<A,B>(x:OptionOf<A>, f: A->OptionOf<B>):OptionOf<B> 
  {
    return Options.flatMap(x, f);
  }
}