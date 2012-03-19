package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;
import scuts.core.types.Either;

class EitherEq<A,B> extends EqAbstract<Either<A,B>> {

  var eqA:Eq<A>;
  var eqB:Eq<B>;
  
  public function new (eqA:Eq<A>, eqB:Eq<B>) 
  {
    this.eqA = eqA;
    this.eqB = eqB;
  }
  
  override public function eq (a:Either<A,B>, b:Either<A,B>):Bool 
  {
    return switch (a) {
      case Left(l1):
        switch (b) { case Left(l2): eqA.eq(l1, l2); default: false;}
      case Right(r1):
        switch (b) { case Right(r2): eqB.eq(r1, r2); default: false;}
    }
  }
  
}
