package hots.classes;
import hots.Of;
import scuts.Scuts;

using scuts.core.extensions.Functions;



 //class Comonad w where 
 // (=>>) :: w a -> (w a -> b) -> w b haskell extract :: w a -> a 
 
/*
 extend f  = fmap f . duplicate
  duplicate = extend id
 
  */
@:tcAbstract class CoPointedAbstract<W> implements CoPointed<W> 
{
  
  var f:Functor<W>;
  
  public function new (f:Functor<W>) {
    this.f = f;
  }

  //public function extract <A>(f:Of<W,A>):A return Scuts.abstractMethod()
  
  // delegation of Extend
  
  @:final public inline function copure <A>(v:A):Of<W,A> return Scuts.abstractMethod()
  
  
  
  // delegation of Functor
  
  @:final public inline function map<A,B>(val:Of<W,A>, fn:A->B):Of<W,B> return f.map(val,fn)
}