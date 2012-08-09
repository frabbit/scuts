package hots.classes;

import scuts.Scuts;



interface Monoid<A> implements Semigroup<A>
{
  public function empty ():A;
  
  //public function concatArray (v:Array<A>):A;
  
  
  
}

