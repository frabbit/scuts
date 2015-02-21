package scuts.ht.instances.std;
import scuts.ht.classes.Functor;

using scuts.core.Ios;


class IoFunctor implements Functor<Io<_>>
{
  public function new () {}

  public function map<A,B>(x:Io<A>, f:A->B):Io<B>
  {
    return Ios.map(x, f);
  }
}


