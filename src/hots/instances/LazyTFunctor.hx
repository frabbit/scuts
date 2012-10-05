package hots.instances;
import hots.classes.Functor;
import hots.In;
import hots.Of;
import hots.of.LazyTOf;

class LazyTFunctor<M> implements Functor<Void->Of<M,In>>
{
  var functorT:Functor<M>;
  
  public function new(f:Functor<M>) 
  {
    this.functorT = f;
  }
  
  public function map <A,B>(x:LazyTOf<M, A>, f:A->B):LazyTOf<M,B>
  {
    var z:Void->Of<M,A> = x;
    return function () return functorT.map(z(), f);
    
    //return r;
  }
  
}