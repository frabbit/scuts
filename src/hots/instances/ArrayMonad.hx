package hots.instances;

import hots.classes.MonadAbstract;
import hots.In;
import hots.of.ArrayOf;
import scuts.core.extensions.Arrays;


class ArrayMonad extends MonadAbstract<Array<In>>
{
  public function new (app) super(app)
  
  override public function flatMap<A,B>(x:ArrayOf<A>, f: A->ArrayOf<B>):ArrayOf<B> 
  {
    return Arrays.flatMap(x, f);
  }
}
