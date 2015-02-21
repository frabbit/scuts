package scuts.ht.instances.std;

import scuts.ht.classes.Bind;

import scuts.core.Ios;





class IoBind implements Bind<Io<_>>
{
  public function new () {}

  public function flatMap<A,B>(val:Io<A>, f: A->Io<B>):Io<B>
  {
    return Ios.flatMap(val, f);
  }
}