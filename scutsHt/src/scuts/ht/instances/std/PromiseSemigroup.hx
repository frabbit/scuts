package scuts.ht.instances.std;


import scuts.ht.classes.Semigroup;



using scuts.core.Promises;

class PromiseSemigroup<X> implements Semigroup<PromiseD<X>>
{
  var semi:Semigroup<X>;
  
  public function new (semi:Semigroup<X>) this.semi = semi;
  
  public function append (a:PromiseD<X>, b:PromiseD<X>):PromiseD<X> 
  {
    return a.zipWith(b, semi.append);
    
  }
 
}
