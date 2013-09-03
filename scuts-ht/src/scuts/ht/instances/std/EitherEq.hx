package scuts.ht.instances.std;

import scuts.ht.classes.Eq;
import scuts.ht.classes.EqAbstract;
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
