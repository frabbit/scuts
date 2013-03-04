package scuts1.instances.std;


import scuts1.classes.Bind;
import scuts1.classes.Monad;
import scuts1.core.In;
import scuts1.instances.std.EitherOf;
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
