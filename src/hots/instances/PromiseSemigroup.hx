package hots.instances;


import hots.classes.Semigroup;
import hots.classes.SemigroupAbstract;
import scuts.core.types.Promise;
import scuts.macros.Do;

using scuts.core.extensions.Promises;

class PromiseSemigroup<X> extends SemigroupAbstract<Promise<X>>
{
  var semi:Semigroup<X>;
  
  public function new (semi:Semigroup<X>) this.semi = semi
  
  override public function append (a:Promise<X>, b:Promise<X>):Promise<X> 
  {
    return Do.run(
      x1 <= a, 
      x2 <= b, 
      return semi.append(x1,x2)
    );
  }
 
}
