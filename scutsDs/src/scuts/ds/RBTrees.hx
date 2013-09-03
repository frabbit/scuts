package scuts.ds;

using scuts.core.Functions;
using scuts.core.Options;
import scuts.core.Tuples.*;
using scuts.core.Tuples;
using scuts.ds.ImLists;
import scuts.ht.classes.Eq;
import scuts.ht.classes.Ord;
enum Color {
    R;
    B;
}

enum RBTree<K, V> {
    Leaf;
    Node(c:Color, l: RBTree<K,V>, k:K, v:V, r : RBTree<K,V>);
}


class RBTrees {
    public static function blacken <K,V>(n : RBTree<K,V>):RBTree<K,V> 
    {
        return switch (n) {
          case Leaf: n;
        //case BBLeaf: Leaf;
          case Node(_,l,k,v,r): Node(B,l,k,v,r);
        }
    }

  
    // balance: Balance a tree with balanced subtrees.
    public static function balance <K,V>(c : Color, l : RBTree<K,V>, k : K, v : V, r : RBTree<K,V>) : RBTree<K,V> 
    {
        return switch [c,l,k,v,r] 
        {
            case [B,Node(R,Node(R,a,xK,xV,b),yK,yV,c),zK,zV,d] : Node(R,Node(B,a,xK,xV,b),yK,yV,Node(B,c,zK,zV,d));
            case [B,Node(R,a,xK,xV,Node(R,b,yK,yV,c)),zK,zV,d] : Node(R,Node(B,a,xK,xV,b),yK,yV,Node(B,c,zK,zV,d));
            case [B,a,xK,xV,Node(R,Node(R,b,yK,yV,c),zK,zV,d)] : Node(R,Node(B,a,xK,xV,b),yK,yV,Node(B,c,zK,zV,d));
            case [B,a,xK,xV,Node(R,b,yK,yV,Node(R,c,zK,zV,d))] : Node(R,Node(B,a,xK,xV,b),yK,yV,Node(B,c,zK,zV,d));
            case [c,a,xK,xV,b] : Node(c,a,xK,xV,b);
        }
    }

    public static function foldLeft <K,A,V>(rb:RBTree<K,V>, init:A, f:A->K->V->A):A 
    {
        return switch (rb) {
          case Leaf: init;
          case Node(c,l,k1,v,r):
            var a1 = foldLeft(l, init, f);
            var a2 = f(a1, k1, v);
            
            return foldLeft(r, a2, f);
          
        }
    }

    public static function foldRight <K,A,V>(rb:RBTree<K,V>, init:A, f:K->V->A->A):A 
    {
        return switch (rb) {
          case Leaf: init;
          case Node(c,l,k1,v,r):
            var a1 = foldRight(r, init, f);
            var a2 = f(k1, v,a1);
            
            return foldRight(l, a2, f);
          
        }
    }
  
    public static function empty<K, V>() : RBTree<K,V> 
    {
        return Leaf;
    }


    public static function modWith <K,V>(rb:RBTree<K,V>, k : K, f : Tup2<K, Option<V>> -> V, ord:Ord<K>) : RBTree<K,V> 
    {
        return switch (rb) {
          case Leaf: Node(R, Leaf, k, f.untupled()(k, None), Leaf);
          case Node(c,l,k1,v,r):
            if (ord.less(k,k1)) balance(c, modWith(l, k,f, ord), k1, v, r) else
            if (ord.eq(k,k1)) Node(c,l,k,f.untupled()(k1, Some(v)),r) else
            balance(c, l, k1, v, modWith(r,k,f,ord));

        }
    } 


    // modifiedWith: Insert, update and delete all in one. 
    public static function modifiedWith <K,V>(rb:RBTree<K,V>, k : K, f : Tup2<K, Option<V>> -> V, ord:Ord<K>) : RBTree<K,V> 
    {
    return blacken(modWith(rb, k,f, ord));
    } 
  
    public static function asImList <K,V>(rb:RBTree<K,V>):ImList<Tup2<K,V>>
    {
        return foldRight(rb, ImLists.mkEmpty(), function (k,v,a) return a.cons(tup2(k,v)));
    }

    public static function eq <K,V>(rb1:RBTree<K,V>, rb2:RBTree<K,V>, eqK:Eq<K>, eqV:Eq<V>):Bool
    {
        var l1 = asImList(rb1);
        var l2 = asImList(rb2);



        return l1.eq(l2, scuts.ht.instances.Eqs.tup2Eq(eqK, eqV));

    }

    public static function get <K,V>(rb:RBTree<K, V>, k : K, ord:Ord<K>) : Option<V>
    {
        return switch (rb) {
          case Leaf: None;
          case Node(c,l,k1,v,r):
            if (ord.less(k,k1)) get(l, k, ord) else
            if (ord.greater(k, k1)) get(r,k, ord) else
            Some(v);
        }
    }

}