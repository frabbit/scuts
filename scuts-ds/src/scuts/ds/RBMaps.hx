package scuts.ds;

import scuts.ht.classes.Eq;
import scuts.ht.classes.Ord;


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

// abstract class RBMap[K, V] (implicit cmp : K => Ordered[K]) {

//   /* We could have required that K be <: Ordered[K], but this is
//   actually less general than requiring an implicit parameter that can
//   convert K into an Ordered[K].

//   For example, Int is not compatible with Ordered[Int].  This would
//   make it unusable with this map; however, it's simple to define an
//   injector from Int into Ordered[Int].

//   In fact, the standard prelude already defines just such an implicit:
//   intWrapper. */

//   // blacken: Turn a node black.
//   protected def blacken (n : RBMap[K,V])  : RBMap[K,V] = {
//     n match {
//       case L() => n
//       case T(_,l,k,v,r) => T(B,l,k,v,r)
//     }
//   }

//   // balance: Balance a tree with balanced subtrees.
//   protected def balance (c : Color) (l : RBMap[K,V]) (k : K) (v : Option[V]) (r : RBMap[K,V]) : RBMap[K,V] = {
//     (c,l,k,v,r) match {
//       case (B,T(R,T(R,a,xK,xV,b),yK,yV,c),zK,zV,d) => T(R,T(B,a,xK,xV,b),yK,yV,T(B,c,zK,zV,d))
//       case (B,T(R,a,xK,xV,T(R,b,yK,yV,c)),zK,zV,d) => T(R,T(B,a,xK,xV,b),yK,yV,T(B,c,zK,zV,d))
//       case (B,a,xK,xV,T(R,T(R,b,yK,yV,c),zK,zV,d)) => T(R,T(B,a,xK,xV,b),yK,yV,T(B,c,zK,zV,d))
//       case (B,a,xK,xV,T(R,b,yK,yV,T(R,c,zK,zV,d))) => T(R,T(B,a,xK,xV,b),yK,yV,T(B,c,zK,zV,d))
//       case (c,a,xK,xV,b) => T(c,a,xK,xV,b)
//     }
//   }

//   // modWith: Helper method; top node could be red.
//   private[map] def modWith (k : K, f : (K, Option[V]) => Option[V]) : RBMap[K,V]

//   // modifiedWith: Insert, update and delete all in one.
//   def modifiedWith (k : K, f : (K, Option[V]) => Option[V]) : RBMap[K,V] =
//     blacken(modWith(k,f))

//   // get: Retrieve a value for a key.
//   def get(k : K) : Option[V]

//   // insert: Insert a value at a key.
//   def insert (k : K, v : V) = modifiedWith (k, (_,_) => Some(v))

//   // remove: Delete a key.
//   def remove (k : K) = modifiedWith (k, (_,_) => None)
// }


// // A leaf node.
// private case class L[K, V] (implicit cmp : K => Ordered[K]) extends RBMap[K,V]  {
//   def get(k : K) : Option[V] = None

//   private[map] def modWith (k : K, f : (K, Option[V]) => Option[V]) : RBMap[K,V] = {
//     T(R, this, k, f(k,None), this)
//   }
// }


// // A tree node.
// private case class T[K, V](c : Color, l : RBMap[K,V], k : K, v : Option[V], r : RBMap[K,V]) (implicit cmp : K => Ordered[K]) extends RBMap[K,V] {
//   def get(k : K) : Option[V] = {
//     if (k < this.k) l.get(k) else
//     if (k > this.k) r.get(k) else
//     v
//   }

//   private[map] def modWith (k : K, f : (K, Option[V]) => Option[V]) : RBMap[K,V] = {
//     if (k <  this.k) (balance (c) (l.modWith(k,f)) (this.k) (this.v) (r)) else
//     if (k == this.k) (T(c,l,k,f(this.k,this.v),r)) else
//     (balance (c) (l) (this.k) (this.v) (r.modWith(k,f)))
//   }
// }


// // A helper object.
// object RBMap {

//   // empty: Converts an orderable type into an empty RBMap.
//   def empty[K <: Ordered[K], V] : RBMap[K,V] = L()((k : K) => k)

//   // apply: Assumes an implicit conversion.
//   def apply[K, V](args : (K,V)*)(implicit cmp : K => Ordered[K]) : RBMap[K,V] = {
//     var currentMap : RBMap[K,V] = L()
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

using scuts.ds.RBTrees;

import scuts.ds.RBTrees.Color;



private abstract RBMap<K,V>(RBTree<K,Option<V>>)
{
  private inline function new (x) this = x;

  @:allow(scuts.ds.RBMaps)
  @:to static inline function toRBTree <K,V>(x:RBTree<K, Option<V>>): RBTree<K, Option<V>> return x;
  @:allow(scuts.ds.RBMaps)
  @:from static inline function fromRBTree <K,V>(x:RBTree<K, Option<V>>): RBMap<K, V> return new RBMap(x);
}




class RBMaps {


  public static function keysAsImList <K,V>(rb:RBMap<K,V>):ImList<K>
  {
    return foldRight(rb, ImLists.mkEmpty(), function (k,_,a) return a.cons(k));
  }

  public static function valuesAsImList <K,V>(rb:RBMap<K,V>):ImList<V>
  {
    return foldRight(rb, ImLists.mkEmpty(), function (_,v,a) return a.cons(v));
  }

  public static function asImList <K,V>(rb:RBMap<K,V>):ImList<Tup2<K,V>>
  {
    return foldRight(rb, ImLists.mkEmpty(), function (k,v,a) return a.cons(tup2(k,v)));
  }

  public static function eq <K,V>(rb1:RBMap<K,V>, rb2:RBMap<K,V>, eqK:Eq<K>, eqV:Eq<V>):Bool
  {
    var l1 = asImList(rb1);
    var l2 = asImList(rb2);

    return l1.eq(l2, scuts.ht.instances.Eqs.tup2Eq(eqK, eqV));

  }

  public static function foldLeft <K,A,V>(rb:RBMap<K,V>, init:A, f:A->K->V->A):A
  {
    return rb.foldLeft(init, function (a,k,v) {
      return switch (v) {
        case Some(v1): f(a,k,v1);
        case None: a;
      }
    });
  }

  public static function foldRight <K,A,V>(rb:RBMap<K,V>, init:A, f:K->V->A->A):A
  {
    return rb.foldRight(init, function (k,v,a) {
      return switch (v) {
        case Some(v1): f(k,v1,a);
        case None: a;
      }
    });
  }

  // // modWith: Helper method; top node could be red.
  // public  static function modWith <K,V>(rb:RBMap<K,V>, k : K, f : Tup2<K, Option<V>> -> Option<V>, ord:Ord<K>) : RBMap<K,V>
  // {
  //   return switch (rb.toRBTree()) {
  //     case Leaf: Node(R, Leaf, k, f.untupled()(k, None), Leaf);
  //     case Node(c,l,k1,v,r):
  //       if (ord.less(k,k1)) RBTrees.balance(c, modWith(l, k,f, ord), k1, v, r) else
  //       if (ord.eq(k,k1)) Node(c,l,k,f.untupled()(k1, v),r) else
  //       RBTrees.balance(c, l, k1, v, modWith(r,k,f,ord));

  //   }
  // }


  // // modifiedWith: Insert, update and delete all in one.
  // public static function modifiedWith <K,V>(rb:RBMap<K,V>, k : K, f : Tup2<K, Option<V>> -> Option<V>, ord:Ord<K>) : RBMap<K,V>
  // {
  //   return RBTrees.blacken(modWith(rb, k,f, ord));
  // }


  // get: Retrieve a value for a key.
  public static function get <K,V>(rb:RBMap<K, V>, k : K, ord:Ord<K>) : Option<V>
  {
    return RBTrees.get(rb, k, ord).flatten();
  }

  // insert: Insert a value at a key.
  public static function insert <K,V>(rb:RBMap<K, V>, k : K, v : V, ord:Ord<K>)
  {
  	return RBTrees.modifiedWith(rb, k, function (_) return Some(v), ord);
  }

  // remove: Delete a key.
  public static function remove <K,V>(rb:RBMap<K, V>, k : K, ord:Ord<K>)
  {
    return RBTrees.modifiedWith(rb, k, function (_) return None, ord);
  }

  public static function empty<K, V>() : RBMap<K,V>
  {
  	return RBTrees.empty();
  }

  /*

  private static function deleteNode <K,V>(rb:RBMap<K,V>, key:K, ord:Ord<K>) {
    return switch (rb) {
      case Node(c,l,k,v,r):
        if (ord.less(key, k))    bubble(c, deleteNode(l,ord), k, v, r) else
        if (ord.greater(key, k)) removeNode(rb) else
        bubble(c, l, k, v, deleteNode(r,ord));

      case Leaf: rb;
    }
  }

  public static function removeNode <K,V>(rb:RBMap<K,V>, or) {
    switch (rb) {
      case Node(R,Leaf, _, _,Leaf):Leaf;
      case Node(B,Leaf, _, _,Leaf):BBLeaf;
    }

  }

  public static function bubble <K,V>(rb:RBMap<K,V>, c:Color, l:RBMap<K,V>, k:K, v:V, r:RBMap<K,V>) {

  }

  public static function removeMaxNode <K,V>(rb:RBMap<K,V>) {

  }

  private static function redden <K,V>(n : RBMap<K,V>):RBMap<K,V>
  {
      return switch (n) {
        case Leaf: throw "Can't redden a Leaf";
        //case BBLeaf: throw "Can't redden a Leaf";
        case Node(_,l,k,v,r): Node(R,l,k,v,r);
      }
  }
  */




}

// REMOVAL OF NODES NOT YET IMPLEMENTED, TAKE A LOOK AT THIS RACKET IMPLEMENTATION


/*
; A purely functional sorted-map library.

; Provides logarithmic insert, update, get & delete.

; Based on Okasaki's red-black trees
; with purely functional red-black delete.

; Author: Matthew Might
; Site:   http://matt.might.net/
; Page:   http://matt.might.net/articles/red-black-delete/

(module sorted-map racket/base

(require racket/match)

; This provides more than necessary.
; Oh well.
(provide (all-defined-out))

; Syntactic sugar for define forms
; with match as their body:
(define-syntax define/match
  (syntax-rules ()
    [(_ (id name) clause ...)
     ; =>
     (define (id name)
       (match name clause ...))]))

(define-syntax define/match*
  (syntax-rules ()
    [(_ (id name ...) clause ...)
     ; =>
     (define (id name ...)
       (match* (name ...)
               clause ...))]))

; A form for matching the result of a comparison:
(define-syntax switch-compare
  (syntax-rules (= < >)
    [(_ (cmp v1 v2)
        [< action1 ...]
        [= action2 ...]
        [> action3 ...])
     ; =>
     (let ((dir (cmp v1 v2)))
       (cond
         [(< dir 0) action1 ...]
         [(= dir 0) action2 ...]
         [(> dir 0) action3 ...]))]))



; Struct definition for sorted-map:
(define-struct sorted-map (compare))

;  Internal nodes:
(define-struct (T sorted-map)
  (color left key value right))

;  Leaf nodes:
(define-struct (L sorted-map) ())

;  Double-black leaf nodes:
(define-struct (BBL sorted-map) ())


; Color manipulators.

; Turns a node black.
(define/match (blacken node)
  [(T cmp _ l k v r)  (T cmp 'B l k v r)]
  [(BBL cmp)          (L cmp)]
  [(L _)              node])

; Turns a node red.
(define/match (redden node)
  [(T cmp _ l k v r)   (T cmp 'R l k v r)]
  [(L _)               (error "Can't redden leaf.")])


; Color arithmetic.
(define/match (black+1 color-or-node)
  [(T cmp c l k v r)  (T cmp (black+1 c) l k v r)]
  [(L cmp)            (BBL cmp)]
  ['-B 'R]
  ['R  'B]
  ['B  'BB])

(define/match (black-1 color-or-node)
  [(T cmp c l k v r)  (T cmp (black-1 c) l k v r)]
  [(BBL cmp)          (L cmp)]
  ['R   '-B]
  ['B    'R]
  ['BB   'B])



; Creates an empty map:
(define (sorted-map-empty compare)
  (L compare))


;; Custom patterns.

; Matches internal nodes:
(define-match-expander T!
  (syntax-rules ()
    [(_)            (T _ _ _ _ _ _)]
    [(_ l r)        (T _ _ l _ _ r)]
    [(_ c l r)      (T _ c l _ _ r)]
    [(_ l k v r)    (T _ _ l k v r)]
    [(_ c l k v r)  (T _ c l k v r)]))

; Matches leaf nodes:
(define-match-expander L!
  (syntax-rules ()
    [(_)     (L _)]))

; Matches black nodes (leaf or internal):
(define-match-expander B
  (syntax-rules ()
    [(_)              (or (T _ 'B _ _ _ _)
                          (L _))]
    [(_ cmp)          (or (T cmp 'B _ _ _ _)
                          (L cmp))]
    [(_ l r)          (T _ 'B l _ _ r)]
    [(_ l k v r)      (T _ 'B l k v r)]
    [(_ cmp l k v r)  (T cmp 'B l k v r)]))

; Matches red nodes:
(define-match-expander R
  (syntax-rules ()
    [(_)              (T _ 'R _ _ _ _)]
    [(_ cmp)          (T cmp 'R _ _ _ _)]
    [(_ l r)          (T _ 'R l _ _ r)]
    [(_ l k v r)      (T _ 'R l k v r)]
    [(_ cmp l k v r)  (T cmp 'R l k v r)]))

; Matches negative black nodes:
(define-match-expander -B
  (syntax-rules ()
    [(_)                (T _ '-B _ _ _ _)]
    [(_ cmp)            (T cmp '-B _ _ _ _)]
    [(_ l k v r)        (T _ '-B l k v r)]
    [(_ cmp l k v r)    (T cmp '-B l k v r)]))

; Matches double-black nodes (leaf or internal):
(define-match-expander BB
  (syntax-rules ()
    [(_)              (or (T _ 'BB _ _ _ _)
                          (BBL _))]
    [(_ cmp)          (or (T cmp 'BB _ _ _ _)
                          (BBL _))]
    [(_ l k v r)      (T _ 'BB l k v r)]
    [(_ cmp l k v r)  (T cmp 'BB l k v r)]))

(define/match (double-black? node)
  [(BB) #t]
  [_    #f])



; Turns a black-balanced tree with invalid colors
; into a black-balanced tree with valid colors:
(define (balance-node node)
  (define cmp (sorted-map-compare node))
  (match node
    [(or (T! (or 'B 'BB) (R (R a xk xv b) yk yv c) zk zv d)
         (T! (or 'B 'BB) (R a xk xv (R b yk yv c)) zk zv d)
         (T! (or 'B 'BB) a xk xv (R (R b yk yv c) zk zv d))
         (T! (or 'B 'BB) a xk xv (R b yk yv (R c zk zv d))))
     ; =>
     (T cmp (black-1 (T-color node)) (T cmp 'B a xk xv b) yk yv (T cmp 'B c zk zv d))]

    [(BB a xk xv (-B (B b yk yv c) zk zv (and d (B))))
     ; =>
     (T cmp 'B (T cmp 'B a xk xv b) yk yv (balance cmp 'B c zk zv (redden d)))]

    [(BB (-B (and a (B)) xk xv (B b yk yv c)) zk zv d)
     ; =>
     (T cmp 'B (balance cmp 'B (redden a) xk xv b) yk yv (T cmp 'B c zk zv d))]

    [else     node]))

(define (balance cmp c l k v r)
  (balance-node (T cmp c l k v r)))


; Moves to a location in the map and
; peformes an update with the function:
(define (sorted-map-modify-at node key f)

  (define (internal-modify-at node key f)
    (match node
      [(T cmp c l k v r)
       ; =>
       (switch-compare (cmp key k)
        [<  (balance cmp c (internal-modify-at l key f) k v r)]
        [=  (T cmp c l k (f k v) r)]
        [>  (balance cmp c l k v (internal-modify-at r key f))])]

      [(L cmp)
       ; =>
       (T cmp 'R node key (f key #f) node)]))

  (blacken (internal-modify-at node key f)))


; Inserts an element into the map
(define (sorted-map-insert node key value)
  (sorted-map-modify-at node key (lambda (k v) value)))


; Inserts several elements into the map:
(define (sorted-map-insert* node keys values)
  (if (or (not (pair? keys))
          (not (pair? values)))
      node
      (sorted-map-insert*
       (sorted-map-insert node (car keys) (car values))
       (cdr keys) (cdr values))))


; Coverts a sorted map into a tree:
(define/match (sorted-map-to-tree node)
  [(L!)             'L]
  [(T! c l k v r)   `(,c ,(sorted-map-to-tree l) ,k ,v ,(sorted-map-to-tree r))]
  [else              node])


; Converts a sorted map into an alist:
(define (sorted-map-to-alist node)

  (define (sorted-map-prepend-as-alist node alist)
    (match node
      [(T! l k v r)
       ; =>
       (sorted-map-prepend-as-alist
        l
        (cons (cons k v)
              (sorted-map-prepend-as-alist r alist)))]

      [(L _)
       ; =>
       alist]))

  (sorted-map-prepend-as-alist node '()))


; Tests whether this map is a submap of another map:
(define (sorted-map-submap? map1 map2 #:by [by equal?])
  (define amap1 (sorted-map-to-alist map1))
  (define amap2 (sorted-map-to-alist map2))
  (define cmp   (sorted-map-compare map1))

  (define (compare-alists amap1 amap2)
    (match* (amap1 amap2)
      [(`((,k1 . ,v1) . ,rest1)
        `((,k2 . ,v2) . ,rest2))
       ; =>
       (let ((dir (cmp k1 k2)))
         (cond
           [(< dir 0) #f]
           [(= dir 0) (and (by v1 v2) (compare-alists rest1 rest2))]
           [else      (compare-alists amap1 rest2)]))]

      [('() '())   #t]

      [(_ '())     #f]

      [('() _)     #t]))

  (compare-alists amap1 amap2))


; Gets an element from a sorted map:
(define (sorted-map-get node key)
  (match node
    [(L!)    #f]

    [(T cmp c l k v r)
     ; =>
     (switch-compare (cmp key k)
       [<   (sorted-map-get l key)]
       [=   v]
       [>   (sorted-map-get r key)])]))


; Returns the size of the sorted map:
(define (sorted-map-size smap)
  (match smap
    [(T! l r)   (+ 1 (sorted-map-size l)
                     (sorted-map-size r))]
    [(L!)           0]))


; Returns the maxium (key . value) pair:
(define/match (sorted-map-max node)
  [(T! _ k v (L!))   (cons k v)]
  [(T! _     r)      (sorted-map-max r)])


; Performs a check to see if both invariants are met:
(define (sorted-map-is-legal? node)

  ; Calculates the max black nodes on path:
  (define/match (max-black-height node)
    [(T! c l r)
     ; =>
     (+ (if (eq? c 'B) 1 0) (max (max-black-height l)
                                 (max-black-height r)))]

    [(L!)     1])

  ; Calculates the min black nodes on a path:
  (define/match (min-black-height node)
    [(T! c l r)
     ; =>
     (+ (if (eq? c 'B) 1 0) (min (min-black-height l)
                                 (min-black-height r)))]

    [(L!)     1])

  ; Is this tree black-balanced?
  (define (black-balanced? node)
    (= (max-black-height node)
       (min-black-height node)))

  ; Does this tree contain a red child of red?
  (define/match (no-red-red? node)
    [(or (B l r)
         (R (and l (B)) (and r (B))))
     ; =>
     (and (no-red-red? l) (no-red-red? r))]

    [(L!)    #t]
    [else    #f])

  (let ((colored?  (no-red-red? node))
        (balanced? (black-balanced? node)))
    (and colored? balanced?)))


; Deletes a key from this map:
(define (sorted-map-delete node key)

  (define cmp (sorted-map-compare node))

  ; Finds the node to be removed:
  (define/match (del node)
    [(T! c l k v r)
     ; =>
     (switch-compare (cmp key k)
       [<   (bubble c (del l) k v r)]
       [=   (remove node)]
       [>   (bubble c l k v (del r))])]

    [else     node])

  ; Removes this node; it might
  ; leave behind a double-black node:
  (define/match (remove node)
    ; Leaves are easiest to kill:
    [(R (L!) (L!))     (L cmp)]
    [(B (L!) (L!))     (BBL cmp)]

    ; Killing a node with one child;
    ; parent or child is red:
    [(or (R child (L!))
         (R (L!)  child))
     ; =>
     child]

    [(or (B (R l k v r) (L!))
         (B (L!) (R l k v r)))
     ; =>
     (T cmp 'B l k v r)]

    ; Killing a black node with one black child:
    [(or (B (L!) (and child (B)))
         (B (and child (B)) (L!)))
     ; =>
     (black+1 child)]

    ; Killing a node with two sub-trees:
    [(T! c (and l (T!)) (and r (T!)))
     ; =>
     (match-let (((cons k v) (sorted-map-max l))
                 (l*         (remove-max l)))
       (bubble c l* k v r))])

  ; Kills a double-black, or moves it to the top:
  (define (bubble c l k v r)
    (cond
      [(or (double-black? l) (double-black? r))
       ; =>
       (balance cmp (black+1 c) (black-1 l) k v (black-1 r))]

      [else (T cmp c l k v r)]))

  ; Removes the max node:
  (define/match (remove-max node)
    [(T!   l     (L!))  (remove node)]
    [(T! c l k v r   )  (bubble c l k v (remove-max r))])

  ; Delete the key, and color the new root black:
  (blacken (del node)))

)
*/