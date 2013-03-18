package scuts.ht.classes;
import scuts.ht.instances.std.DualSemigroup;
import scuts.ht.instances.std.EndoSemigroup;
import scuts.ht.core.Of;
import scuts.ht.instances.Monoids.dualMonoid;
import scuts.ht.instances.Semigroups.dualSemigroup;
import scuts.ht.instances.Monoids.endoMonoid;

import scuts.ht.core.Of;
import scuts.Scuts;
import scuts.core.Options;
import scuts.ht.classes.Monoid;

using scuts.core.Functions;




// minimal implementation foldRight or foldMap

class FoldableAbstract<F> implements Foldable<F>
{

  public function fold <A>(x:Of<F,A>, mon:Monoid<A>):A
  {
    return foldMap(x, Scuts.id, mon);
  }
  
  /**
   * 
   */
  public function foldMap <A,B>(x:Of<F,A>, f:A->B, mon:Monoid<B>):B
  {
    var newF = mon.append.curry().compose(f).uncurry();
    return foldRight(x, mon.zero(), newF);
  }
  
  /**
   * 
   * Haskell Implementation: foldl f z t = appEndo (getDual (foldMap (Dual . Endo . flip f) t)) z
   */
  public function foldLeft <A,B>(of:Of<F,B>, b:A, f:A->B->A):A
  {
    var f : B->(A->A)       = f.flip().curry();
    var mon : Monoid<A->A>  = dualMonoid(endoMonoid());

    return foldMap(of, f, mon)(b);
  }

  /**
   * Haskell Implementation: foldr f z t = appEndo (foldMap (Endo . f) t) z
   */
  public function foldRight <A,B>(x:Of<F,A>, b:B, f:A->B->B):B
  {
    var x = foldMap(x, f.curry(), endoMonoid());
    
    return x(b);
  }
  
  public function foldLeft1 <A>(x:Of<F,A>, f:A->A->A):A
  {
    var mf = function (o:Option<A>, y) return switch (o) {
      case None: Some(y);
      case Some(x): Some(f(x,y));
    }
    
    var foldRes = foldLeft(x, None, mf);
    
    return switch (foldRes) 
    {
      case None: Scuts.error("foldLeft1: Cannot fold over an empty Foldable Value");
      case Some(f): f;
    }
  }
  
  public function foldRight1 <A>(x:Of<F,A>, f:A->A->A):A
  {
    var mf = function (x:A, o:Option<A>) return switch (o) 
    {
      case None: Some(x);
      case Some(y): Some(f(x,y));
    }

    var foldRes = foldRight(x, None, mf);
    
    return switch (foldRes) 
    {
      case None: Scuts.error("foldRight1: Cannot fold over an empty Foldable Value");
      case Some(f): f;
    }
  }
  
  
}