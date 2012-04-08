package hots.classes;
import hots.Of;
import scuts.Scuts;

using scuts.core.extensions.FunctionExt;



 //class Comonad w where 
 // (=>>) :: w a -> (w a -> b) -> w b haskell extract :: w a -> a 
 
/*
 extend f  = fmap f . duplicate
  duplicate = extend id
 
  */
@:tcAbstract class CoMonadAbstract<W> implements CoMonad<W> 
{
  var p:CoPointed<W>;
  public function new (p:CoPointed<W>) {
    this.p = p;
  }

  public function cojoin <A>(f:Of<W,A>):Of<W, Of<W, A>> return Scuts.abstractMethod()
  
  
  
  // delegation of CoPointed
  
  @:final public inline function copure <A>(v:A):Of<W,A> return p.copure(v)
  
  // delegation of Functor
  
  @:final public inline function map<A,B>(f:A->B, val:Of<W,A>):Of<W,B> return p.map(f, val)
}