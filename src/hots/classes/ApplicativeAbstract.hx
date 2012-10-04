package hots.classes;


import hots.classes.Pure;
import hots.Of;
import scuts.Scuts;



class ApplicativeAbstract<M> implements Applicative<M>
{

  // superclasses/constraints
  var _pure:Pure<M>;
  var functor:Functor<M>;
  
  function new (pure:Pure<M>, func:Functor<M>) { 
    this._pure = pure; 
    this.functor = func;
  }
  
  // functions 
  
  /**
   * @see <a href="Applicative.html">hots.classes.Applicative</a>
   */
  public function apply<A,B>(f:Of<M,A->B>, of:Of<M,A>):Of<M,B> return Scuts.abstractMethod()
  
  /**
   * @see <a href="Applicative.html">hots.classes.Applicative</a>
   */
  public function thenRight<A,B>(of1:Of<M,A>, of2:Of<M,B>):Of<M,B> return of2
  
  /**
   * @see <a href="Applicative.html">hots.classes.Applicative</a>
   */
  public function thenLeft<A,B>(of1:Of<M,A>, of2:Of<M,B>):Of<M,A> return of1

  // delegation of functor
  
  /**
   * @see <a href="Functor.html">hots.classes.Functor</a>
   */
  public inline function map<A,B>(of:Of<M,A>, f:A->B):Of<M,B> return functor.map(of, f)
  
  // delegation of pure
  /**
   * @see <a href="Pure.html">hots.classes.Pure</a>
   */
  public inline function pure<A>(x:A):Of<M,A> return _pure.pure(x)
}
