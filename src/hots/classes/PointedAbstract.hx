package hots.classes;

import hots.Of;
import scuts.Scuts;


class PointedAbstract<F> implements Pointed<F>
{
  var functor:Functor<F>;
  var _pure:Pure<F>;
  
  public function new (functor:Functor<F>, pureF:Pure<F>) 
  {
    this.functor = functor;
    this._pure = pureF;
  }
  
  public function pure <A>(v:A):Of<F,A> return _pure.pure(v)
  
  // delegation Functor
  
  public function map<A,B>(of:Of<F,A>, f:A->B):Of<F,B> return functor.map(of,f)
  
}

















