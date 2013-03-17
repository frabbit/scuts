package scuts.ht.classes;
import scuts.ht.core.Of;



interface Cojoin<W>
{
  public function coJoin<A>(f:Of<W,A>):Of<W, Of<W, A>>;
}