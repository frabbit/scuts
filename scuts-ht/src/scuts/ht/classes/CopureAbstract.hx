package scuts.ht.classes;
import scuts.ht.core.Of;
import scuts.Scuts;

using scuts.core.Functions;



 //class Comonad w where
 // (=>>) :: w a -> (w a -> b) -> w b haskell extract :: w a -> a

/*
 extend f  = fmap f . duplicate
  duplicate = extend id

  */
class CopureAbstract<W> implements Copure<W>
{

  var f:Functor<W>;

  public function new (f:Functor<W>) {
    this.f = f;
  }

  //public function extract <A>(f:W<A>):A return Scuts.abstractMethod()

  // delegation of Extend

  public inline function copure <A>(v:A):W<A> return Scuts.abstractMethod();



  // delegation of Functor

  public inline function map<A,B>(val:W<A>, fn:A->B):W<B> return f.map(val,fn);
}