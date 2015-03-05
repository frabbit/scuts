package scuts.ds;

import scuts.ht.classes.Eq;
import scuts.ht.classes.Ord;

using scuts.ds.RBTrees;
import scuts.ds.RBTrees;
using scuts.core.Options;

// based on http://matt.might.net/articles/implementation-of-immutable-purely-functional-okasaki-red-black-tree-maps-in-scala/


// package data.pure.map


// /*** Okasaki-style red-black tree maps. ***/

// // Based on:
// // http://www.eecs.usma.edu/webs/people/okasaki/jfp99.ps

// /*

//  Red-black trees are binary search trees obeying two key invariants:

//  (1) Any path from a root node to a leaf node contains the same number
//      of black nodes. (A balancing condition.)

//  (2) Red nodes always have black children.

//  */


// private object RBTreeItems {
//   class Color
//   case object R extends Color // Red.
//   case object B extends Color // Black.
// }

// import RBTreeItems._


// /* Internally, a map is a tree node; there is no wrapper. */

// abstract class RBSet[K, V] (implicit cmp : K => Ordered[K]) {

//   /* We could have required that K be <: Ordered[K], but this is
//   actually less general than requiring an implicit parameter that can
//   convert K into an Ordered[K].

//   For example, Int is not compatible with Ordered[Int].  This would
//   make it unusable with this map; however, it's simple to define an
//   injector from Int into Ordered[Int].

//   In fact, the standard prelude already defines just such an implicit:
//   intWrapper. */

//   // blacken: Turn a node black.
//   protected def blacken (n : RBSet[K,V])  : RBSet[K,V] = {
//     n match {
//       case L() => n
//       case T(_,l,k,v,r) => T(B,l,k,v,r)
//     }
//   }

//   // balance: Balance a tree with balanced subtrees.
//   protected def balance (c : Color) (l : RBSet[K,V]) (k : K) (v : Option[V]) (r : RBSet[K,V]) : RBSet[K,V] = {
//     (c,l,k,v,r) match {
//       case (B,T(R,T(R,a,xK,xV,b),yK,yV,c),zK,zV,d) => T(R,T(B,a,xK,xV,b),yK,yV,T(B,c,zK,zV,d))
//       case (B,T(R,a,xK,xV,T(R,b,yK,yV,c)),zK,zV,d) => T(R,T(B,a,xK,xV,b),yK,yV,T(B,c,zK,zV,d))
//       case (B,a,xK,xV,T(R,T(R,b,yK,yV,c),zK,zV,d)) => T(R,T(B,a,xK,xV,b),yK,yV,T(B,c,zK,zV,d))
//       case (B,a,xK,xV,T(R,b,yK,yV,T(R,c,zK,zV,d))) => T(R,T(B,a,xK,xV,b),yK,yV,T(B,c,zK,zV,d))
//       case (c,a,xK,xV,b) => T(c,a,xK,xV,b)
//     }
//   }

//   // modWith: Helper method; top node could be red.
//   private[map] def modWith (k : K, f : (K, Option[V]) => Option[V]) : RBSet[K,V]

//   // modifiedWith: Insert, update and delete all in one.
//   def modifiedWith (k : K, f : (K, Option[V]) => Option[V]) : RBSet[K,V] =
//     blacken(modWith(k,f))

//   // get: Retrieve a value for a key.
//   def get(k : K) : Option[V]

//   // insert: Insert a value at a key.
//   def insert (k : K, v : V) = modifiedWith (k, (_,_) => Some(v))

//   // remove: Delete a key.
//   def remove (k : K) = modifiedWith (k, (_,_) => None)
// }


// // A leaf node.
// private case class L[K, V] (implicit cmp : K => Ordered[K]) extends RBSet[K,V]  {
//   def get(k : K) : Option[V] = None

//   private[map] def modWith (k : K, f : (K, Option[V]) => Option[V]) : RBSet[K,V] = {
//     T(R, this, k, f(k,None), this)
//   }
// }


// // A tree node.
// private case class T[K, V](c : Color, l : RBSet[K,V], k : K, v : Option[V], r : RBSet[K,V]) (implicit cmp : K => Ordered[K]) extends RBSet[K,V] {
//   def get(k : K) : Option[V] = {
//     if (k < this.k) l.get(k) else
//     if (k > this.k) r.get(k) else
//     v
//   }

//   private[map] def modWith (k : K, f : (K, Option[V]) => Option[V]) : RBSet[K,V] = {
//     if (k <  this.k) (balance (c) (l.modWith(k,f)) (this.k) (this.v) (r)) else
//     if (k == this.k) (T(c,l,k,f(this.k,this.v),r)) else
//     (balance (c) (l) (this.k) (this.v) (r.modWith(k,f)))
//   }
// }


// // A helper object.
// object RBSet {

//   // empty: Converts an orderable type into an empty RBSet.
//   def empty[K <: Ordered[K], V] : RBSet[K,V] = L()((k : K) => k)

//   // apply: Assumes an implicit conversion.
//   def apply[K, V](args : (K,V)*)(implicit cmp : K => Ordered[K]) : RBSet[K,V] = {
//     var currentMap : RBSet[K,V] = L()
//     for ((k,v) <- args) {
//       currentMap = currentMap.insert(k,v)
//     }
//     currentMap
//   }
// }

using scuts.core.Options;
using scuts.core.Tuples;
import scuts.core.Tuples.*;
using scuts.core.Functions;
using scuts.ds.ImLists;


abstract RBSet<V>(RBTree<V,Bool>) {
  private inline function new (x) this = x;

  @:allow(scuts.ds.RBSets)
  @:to static inline function toRBTree <K,V>(x:RBTree<V,Bool>): RBTree<V, Bool> return x;
  @:allow(scuts.ds.RBSets)
  @:from static inline function fromRBTree <K,V>(x:RBTree<V, Bool>): RBSet<V> return new RBSet(x);
}


class RBSets {

  public static function asImList <V>(rb:RBSet<V>):ImList<V>
  {
    return foldRight(rb, ImLists.mkEmpty(), function (v,a) return a.cons(v));
  }

  public static function eq <V>(s1:RBSet<V>, s2:RBSet<V>, eqV:Eq<V>):Bool
  {
    var l1 = asImList(s1);
    var l2 = asImList(s2);


    return l1.eq(l2, eqV);

  }

  public static function foldLeft <A,V>(rb:RBSet<V>, init:A, f:A->V->A):A
  {
    return rb.foldLeft(init, function (a,v,b) {
      return if (b) f(a,v) else a;

    });
  }

  public static function foldRight <A,V>(rb:RBSet<V>, init:A, f:V->A->A):A
  {
    return rb.foldRight(init, function (v,b,a) {
      return if (b) f(v,a) else a;
    });
  }

  public static function insert <V>(rb:RBSet<V>, v : V, ord:Ord<V>)
  {
    return RBTrees.modifiedWith(rb, v, function (_) return true, ord);
  }

  public static function union <V>(s1:RBSet<V>, s2:RBSet<V>, ord:Ord<V>)
  {
    return foldLeft(s2, s1, insert.bind(_,_, ord));
  }

  public static function intersection <V>(s1:RBSet<V>, s2:RBSet<V>, ord:Ord<V>)
  {
    return foldLeft(s1, empty(), function (r, x) {
      return if (exists(s2, x, ord)) insert(r, x, ord) else r;
    });

  }

  public static function difference <V>(s1:RBSet<V>, s2:RBSet<V>, ord:Ord<V>)
  {
    return foldLeft(s1, empty(), function (r, x) {
      return if (!exists(s2, x, ord)) insert(r, x, ord) else r;
    });

  }

  // remove: Delete a key.
  public static function remove <V>(rb:RBSet<V>, v : V, ord:Ord<V>)
  {
    return RBTrees.modifiedWith(rb, v, function (_) return false, ord);
  }

  public static function exists <V>(rb:RBSet<V>, v : V, ord:Ord<V>)
  {
    return RBTrees.get(rb, v, ord).getOrElseConst(false);
  }

  public static function empty<V>() : RBSet<V>
  {
    return RBTrees.empty();
  }


}
