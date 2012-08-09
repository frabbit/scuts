package hots.instances;

import hots.classes.Semigroup;
import hots.classes.SemigroupAbstract;
import hots.instances.EitherSemigroup;
import scuts.core.extensions.Eithers;
import scuts.core.types.Either;

using scuts.core.extensions.Eithers;

class EitherSemigroup<L,R> extends SemigroupAbstract<Either<L,R>> 
{
  private var semiL:Semigroup<L>;
  private var semiR:Semigroup<R>;

  public function new (semiL:Semigroup<L>, semiR:Semigroup<R>) 
  {
    this.semiL = semiL;
    this.semiR = semiR;
  }
  
  override public function append(a1:Either<L,R>, a2:Either<L,R>):Either<L,R> 
  {
    return Eithers.append(a1, a2, semiL.append, semiR.append);
  }

}
