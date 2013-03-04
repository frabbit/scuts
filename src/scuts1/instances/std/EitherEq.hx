package scuts1.instances.std;

import scuts1.classes.Eq;
import scuts1.classes.EqAbstract;
import scuts.core.Eithers;


class EitherEq<A,B> extends EqAbstract<Either<A,B>> 
{

  var eqA:Eq<A>;
  var eqB:Eq<B>;
  
  public function new (eqA:Eq<A>, eqB:Eq<B>) 
  {
    this.eqA = eqA;
    this.eqB = eqB;
  }
  
  override public function eq (a:Either<A,B>, b:Either<A,B>):Bool
  {
    return Eithers.eq(a, b, eqA.eq, eqB.eq);
  }
}
