package scuts.ht.classes;
import scuts.ht.core.Of;



interface Cojoin<W> extends Functor<W>
{
  public function cojoin<A>(f:Of<W,A>):Of<W, Of<W, A>>;
}