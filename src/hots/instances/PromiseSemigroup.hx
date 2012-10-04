package hots.instances;


import hots.classes.Semigroup;
import hots.classes.SemigroupAbstract;
import scuts.core.types.Promise;


using scuts.core.extensions.Promises;

class PromiseSemigroup<X> extends SemigroupAbstract<Promise<X>>
{
  var semi:Semigroup<X>;
  
  public function new (semi:Semigroup<X>) this.semi = semi
  
  override public function append (a:Promise<X>, b:Promise<X>):Promise<X> 
  {
    return a.zipWith(b, semi.append);
    
  }
 
}
