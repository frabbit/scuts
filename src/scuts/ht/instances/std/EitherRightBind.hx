package scuts.ht.instances.std;


import scuts.ht.classes.Bind;
import scuts.ht.classes.Monad;
import scuts.ht.core.In;
import scuts.ht.instances.std.EitherOf;
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
