package hots.classes;
import hots.Of;

import hots.Of;
import scuts.Scuts;
import scuts.core.types.Option;
import hots.classes.Monoid;

using scuts.core.extensions.Function1Ext;
using scuts.core.extensions.Function2Ext;
using scuts.core.extensions.Function3Ext;

import hots.instances.DualMonoid;
import hots.instances.EndoMonoid;


// minimal implementation foldRight or foldMap
@:tcAbstract class FoldableAbstract<F> implements Foldable<F>
{
  
  public function fold <A>(mon:Monoid<A>, val:Of<F,A>):A {
    return foldMap(Scuts.id, mon, val);
  }
  
  /**
   * Haskell Signature: Monoid b => (a -> b) -> f a -> b
   */
  public function foldMap <A,B>(f:A->B, mon:Monoid<B>, val:Of<F,A>):B {
    var newF = mon.append.curry().compose(f).uncurry();
    return foldRight(newF, mon.empty(), val);
  }
  
  /**
   * Haskell Signature: (a -> b -> a) -> a -> f b -> A 
   */
  public function foldLeft <A,B>(f:A->B->A, b:A, val:Of<F,B>):A {
    //  foldl f z t = appEndo (getDual (foldMap (Dual . Endo . flip f) t)) z
    
    var f : B->(A->A)       = f.flip().curry();
    var mon : Monoid<A->A>  = DualMonoid.get(EndoMonoid.get());
    
    return foldMap(f, mon, val)(b);
    
  }
  
  public function foldRight <A,B>(f:A->B->B, b:B, val:Of<F,A>):B {
    //foldr f z t = appEndo (foldMap (Endo . f) t) z
    
    var x = foldMap( f.curry(), EndoMonoid.get(), val);
    
    return x(b);
  }
  
  public function foldLeft1 <A>(f:A->A->A, val:Of<F,A>):A 
  {
    var mf = function (o:Option<A>, y) {
      return switch (o) {
        case None: Some(y);
        case Some(x): Some(f(x,y));
      }
    }
    
    var foldRes = foldLeft(mf, None, val);
    
    return switch (foldRes) {
      case None: Scuts.error("foldLeft1: Cannot fold over an empty Foldable Value");
      case Some(f): f;
    }
  }
  
  public function foldRight1 <A>(f:A->A->A, val:Of<F,A>):A 
  {
    var mf = function (x:A, o:Option<A>) {
      return switch (o) {
        case None: Some(x);
        case Some(y): Some(f(x,y));
      }
    }
    
    var foldRes = foldRight(mf, None, val);
    
    return switch (foldRes) {
      case None: Scuts.error("foldRight1: Cannot fold over an empty Foldable Value");
      case Some(f): f;
    }
  }
  
  
}