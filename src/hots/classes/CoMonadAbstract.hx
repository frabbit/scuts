package hots.classes;
import hots.Of;
import scuts.Scuts;

using scuts.core.extensions.Function1Ext;
using scuts.core.extensions.Function2Ext;


 //class Comonad w where 
 // (=>>) :: w a -> (w a -> b) -> w b haskell extract :: w a -> a 
 
/*
 extend f  = fmap f . duplicate
  duplicate = extend id
 
  */
@:tcAbstract class CoMonadAbstract<W> implements CoMonad<W> 
{
  var ex:Extend<W>;
  public function new (extend:Extend<W>) {
    this.ex = extend;
  }

  public function extract <A>(f:Of<W,A>):A return Scuts.abstractMethod()
  
  // delegation of Extend
  
  @:final public inline function extend <A,B>(f:Of<W,A>->B ):Of<W,A>->Of<W,B> return ex.extend(f)
  
  @:final public inline function duplicate<A,B>(val:Of<W,A>):Of<W, Of<W,A>> return ex.duplicate(val)
  
  // delegation of Functor
  
  @:final public inline function map<A,B>(f:A->B, val:Of<W,A>):Of<W,B> return ex.map(f, val)
}