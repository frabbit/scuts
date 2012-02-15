package hots.classes;

import hots.Of;
import scuts.Scuts;


@:tcAbstract class PointedAbstract<F> implements Pointed<F>
{
  var functor:Functor<F>;
  
  public function new (functor:Functor<F>) {
    this.functor = functor;
  }
  public function pure <A>(v:A):Of<F,A> return Scuts.abstractMethod()
  public function map<A,B>(f:A->B, val:Of<F,A>):Of<F,B> return functor.map(f,val)
  
}

















