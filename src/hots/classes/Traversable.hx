package hots.classes;
import hots.wrapper.MTVal;
import hots.wrapper.MVal;
import hots.classes.Foldable;
import scuts.Scuts;

/**
 * ...
 * @author 
 */

interface Traversable<T> 
{

  // constraints
  public function getFunctor():Functor<T>;
  public function getFoldable ():Foldable<T>;

  // functions
  public function sequence <M,A> (val:MTVal<T,M,A>, monad:Monad<M>):MTVal<M,T,A>;
  
  public function sequenceA <F,A> (val:MTVal<T,F,A>, app:Applicative<F>):MVal<F, MVal<T,A>>;
  
  public function traverse <F,A,B> (f:A->MVal<F,B>, v:MVal<T,A>, app:Applicative<F>):MVal<F, MVal<T,B>>;
  
  public function mapM <M,A,B> (f:A->MVal<M,B>, v:MVal<T,A>, monad:Monad<M>):MVal<M, MVal<T,B>>;
  
}

class TraversableDefault<T> 
{
  var fu:Functor<T>;
  var fo:Foldable<T>;
  
  public inline function getFunctor():Functor<T> return fu
  public inline function getFoldable ():Foldable<T> return fo
  
  public function new (functor:Functor<T>, foldable:Foldable<T>) {
    this.fu = functor;
    this.fo = foldable;
  }
  
  public function sequence <M,A> (val:MTVal<T,M,A>, monad:Monad<M>):MTVal<M,T,A> {
    return mapM(Scuts.id, val, monad);
  }
  
  public function sequenceA <F,A> (val:MTVal<T,F,A>, app:Applicative<F>):MVal<F, MVal<T,A>> {
    return traverse(Scuts.id, val, app);
  }
  
  public function traverse <F,A,B> (f:A->MVal<F,B>, v:MVal<T,A>, app:Applicative<F>):MVal<F, MVal<T,B>> {
    return sequenceA(getFunctor().map(f,v), app);
  }
  
  public function mapM <M,A,B> (f:A->MVal<M,B>, v:MVal<T,A>, monad:Monad<M>):MVal<M, MVal<T,B>> return Scuts.abstractMethod()
  
  public function map<A,B>(f:A->B, val:MVal<T,A>):MVal<T,B> return Scuts.abstractMethod()
  
}