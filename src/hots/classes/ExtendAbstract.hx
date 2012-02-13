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
@:tcAbstract class ExtendAbstract<W> implements Extend<W> 
{
  var functor:Functor<W>;
  public function new (functor:Functor<W>) {
    this.functor = functor;
  }
  
  public function extend <A,B>(f:Of<W,A>->B ):Of<W,A>->Of<W,B> return map.curry()(f).compose(duplicate)
  
  public function duplicate<A,B>(val:Of<W,A>):Of<W, Of<W,A>> return extend(Scuts.id)(val)
  
  public inline function map<A,B>(f:A->B, val:Of<W,A>):Of<W,B> return functor.map(f, val)
}