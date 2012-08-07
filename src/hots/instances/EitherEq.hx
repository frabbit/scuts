package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;
import scuts.core.extensions.Eithers;
import scuts.core.types.Either;

class EitherEq<A,B> extends EqAbstract<Either<A,B>> {

  var eqA:Eq<A>;
  var eqB:Eq<B>;
  
  public function new (eqA:Eq<A>, eqB:Eq<B>) 
  {
    this.eqA = eqA;
    this.eqB = eqB;
  }
  
  override public function eq (a:Either<A,B>, b:Either<A,B>):Bool return switch (a) 
  {
    return Eithers.eq(a, b, eqA.eq, eqB.eq);
  }

  
}
