package hots.classes;
import hots.TC;
import scuts.Scuts;



interface Monoid<A> implements Semigroup<A>, implements TC
{
  public function empty ():A;
  
  //public function concatArray (v:Array<A>):A;
}

