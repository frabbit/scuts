package hots.instances;


import hots.classes.Bind;
import hots.classes.Monad;
import hots.In;
import hots.of.EitherOf;
import scuts.core.Eithers;
import scuts.core.Either;

import scuts.core.Eithers;

class EitherRightBind<L> implements Bind<RightProjection<L,In>> 
{
  public function new () {}
  
  public function flatMap<R,RR>(x:RightProjectionOf<L,R>, f: R->RightProjectionOf<L,RR>):RightProjectionOf<L,RR> 
  {
    return RightProjections.flatMap(x, f);
  }
}
