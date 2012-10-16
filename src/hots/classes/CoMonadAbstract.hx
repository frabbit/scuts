package hots.classes;
import hots.Of;
import scuts.Scuts;

using scuts.core.Functions;



 //class Comonad w where 
 // (=>>) :: w a -> (w a -> b) -> w b haskell extract :: w a -> a 
 
/*
 extend f  = fmap f . duplicate
  duplicate = extend id
 
  */
class CoMonadAbstract<W> implements CoMonad<W> 
{
  var p:CoPointed<W>;
  
  public function new (p:CoPointed<W>) 
  {
    this.p = p;
  }

  public function cojoin <A>(f:Of<W,A>):Of<W, Of<W, A>> return Scuts.abstractMethod()
  
  
  
  // delegation of CoPointed
  
  public inline function copure <A>(v:A):Of<W,A> return p.copure(v)
  
  // delegation of Functor
  
  public inline function map<A,B>(val:Of<W,A>, f:A->B):Of<W,B> return p.map(val, f)
}