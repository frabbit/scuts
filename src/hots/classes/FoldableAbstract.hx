package hots.classes;
import hots.Of;

import hots.Of;
import scuts.Scuts;
import scuts.core.types.Option;
import hots.classes.Monoid;

using scuts.core.extensions.Functions;


import hots.instances.DualMonoid;
import hots.instances.EndoMonoid;


// minimal implementation foldRight or foldMap
@:tcAbstract 
class FoldableAbstract<F> implements Foldable<F>
{
  
  public function fold <A>(of:Of<F,A>, mon:Monoid<A>):A
  {
    return foldMap(of, mon, Scuts.id);
  }
  
  /**
   * Haskell Signature: Monoid b => (a -> b) -> f a -> b
   */
  public function foldMap <A,B>(of:Of<F,A>, mon:Monoid<B>, f:A->B ):B
  {
    var newF = mon.append.curry().compose(f).uncurry();
    return foldRight(of, mon.empty(), newF);
  }
  
  /**
   * Haskell Signature: (a -> b -> a) -> a -> f b -> A 
   * Haskell Implementation: foldl f z t = appEndo (getDual (foldMap (Dual . Endo . flip f) t)) z
   */
  public function foldLeft <A,B>(of:Of<F,B>, b:A, f:A->B->A):A
  {
    var f : B->(A->A)       = f.flip().curry();
    var mon : Monoid<A->A>  = DualMonoid.get(EndoMonoid.get());

    return foldMap(of, mon, f)(b);
  }

  /**
   * Haskell Implementation: foldr f z t = appEndo (foldMap (Endo . f) t) z
   */
  public function foldRight <A,B>(of:Of<F,A>, b:B, f:A->B->B):B
  {
    var x = foldMap(of, EndoMonoid.get() ,f.curry());
    
    return x(b);
  }
  
  public function foldLeft1 <A>(of:Of<F,A>, f:A->A->A):A
  {
    var mf = function (o:Option<A>, y) return switch (o) {
      case None: Some(y);
      case Some(x): Some(f(x,y));
    }
    
    var foldRes = foldLeft(of, None, mf);
    
    return switch (foldRes) 
    {
      case None: Scuts.error("foldLeft1: Cannot fold over an empty Foldable Value");
      case Some(f): f;
    }
  }
  
  public function foldRight1 <A>(of:Of<F,A>, f:A->A->A):A
  {
    var mf = function (x:A, o:Option<A>) return switch (o) 
    {
      case None: Some(x);
      case Some(y): Some(f(x,y));
    }

    var foldRes = foldRight(of, None, mf);
    
    return switch (foldRes) 
    {
      case None: Scuts.error("foldRight1: Cannot fold over an empty Foldable Value");
      case Some(f): f;
    }
  }
  
  
}