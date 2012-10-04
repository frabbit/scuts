package hots.instances;


import hots.classes.Monad;
import hots.classes.MonadAbstract;
import hots.In;
import hots.of.EitherOf;
import scuts.core.extensions.Eithers;
import scuts.core.types.Either;

import scuts.core.extensions.Eithers;

class EitherRightMonad<L> extends MonadAbstract<RightProjection<L,In>> 
{
  
  public function new (app) 
  {
    super(app);
  }
  
  override public function flatMap<R,RR>(x:RightProjectionOf<L,R>, f: R->RightProjectionOf<L,RR>):RightProjectionOf<L,RR> 
  {
    return RightProjections.flatMap(x, f);
  }
}
