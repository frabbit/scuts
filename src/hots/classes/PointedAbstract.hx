package hots.classes;

import hots.Of;
import scuts.Scuts;


class PointedAbstract<F> implements Pointed<F>
{
  var functor:Functor<F>;
  
  public function new (functor:Functor<F>) 
  {
    this.functor = functor;
  }
  public function pure <A>(v:A):Of<F,A> return Scuts.abstractMethod()
  
  // delegation Functor
  
  public function map<A,B>(of:Of<F,A>, f:A->B):Of<F,B> return functor.map(of,f)
  
}

















