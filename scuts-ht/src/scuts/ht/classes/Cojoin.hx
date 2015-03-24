package scuts.ht.classes;



interface Cojoin<W> extends Functor<W>
{
  public function cojoin<A>(f:W<A>):W<W<A>>;
}