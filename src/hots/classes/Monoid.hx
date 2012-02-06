package hots.classes;
import hots.TC;
import scuts.Scuts;



interface Monoid<A> implements TC
{
  public function append (a:A, b:A):A;
  public function empty ():A;
  
  public function concatArray (v:Array<A>):A;
}

