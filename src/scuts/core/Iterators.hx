package scuts.core;

import scuts.core.Ordering;
import scuts.core.Option;

import scuts.core.Functions;
using scuts.core.Functions;




class Iterators 
{

  public static function toArray<T> (iter:Iterator<T>):Array<T>
  {
    var res = [];
    for (i in iter) {
      res.push(i);
    }
    return res;
  }
  
  
  public static function any<T>(iter:Iterator<T>, f:T->Bool):Bool
  {
    for (e in iter) {
      if (f(e)) return true;
    }
    return false;
  }
  
  public static function all<T>(iter:Iterator<T>, f:T->Bool):Bool
  {
    for (e in iter) {
      if (!f(e)) return false;
    }
    return true;
  }
  public static function drop<T>(a:Iterator<T>, num:Int):Iterator<T>
  {
    var res = [];
    var i = 0;
    var cur;
    
    return {
      hasNext : function () {
        while (i < num && a.hasNext()) {
          a.next();
          i++;
        }
        if (i < num) i = num;
        return a.hasNext();
      },
      next : function () {
        return a.next();
      }
    }
  }
  public static function elem < T > (it:Iterator<T>, e:T) {
    for ( e1 in it)  {
      if (e1 == e) return true;
    }
    return false;
  }
  
  public static function filter <A> (it:Iterator<A>, filter:A->Bool):Iterator<A>
  {
    // lazy
    var n = null;
    return 
    {
      next : function () 
      {
        var e = n;
        n = null;
        return e;
      },
      hasNext : function () 
      {
        if (n == null) 
        {
          for (i in it) 
          {
            if (filter(i)) 
            {
              n = i;
              break;
            }
          }
        }
        return n != null;
      }
    };
  }
  
  public static function filterToArray <A> (it:Iterator<A>, filter:A->Bool):Array<A>
  {
    var res = [];
    // TODO cast can be solved with type parameter constraints
    return cast doFilter(it, filter, res);
  }
  
  static function doFilter < A > (it:Iterator<A>, filter:A->Bool, cont: { function push (a:A):Dynamic; } ) {
    for (e in it) 
    {
      if (filter(e)) cont.push(e);
    }
    return cont;
  }
  
  public static function filterToList <A> (it:Iterator<A>, filter:A->Bool):List<A>
  {
    var res = new List();
    // TODO cast can be solved with type parameter constraints
    return cast doFilter(it, filter, res); 
  }
  public static function findIndex<T>(iter:Iterator<T>, f:T->Bool):Option<Int>
  {
    var z = 0;
    for (i in iter) 
    {
      if (f(i)) return Some(z);
      z++;
    }
    return None;
  }
  
  public static function flatMap < S, T > (w:Iterator<S>, f:S->Iterator<T>):Iterator<T>
  {
    var inInner = false;
    var outer = w;
    var inner:Iterator<T> = null;
    
    var res = 
    {
      hasNext : null,
      next : function () return inner.next()
    }
    var outerF = null;
    var innerF = null;
    outerF = function () {
      
      if (outer.hasNext()) 
      {
        var val = outer.next();
        inner = f(val);
        res.hasNext = innerF;
        return innerF();
      } 
      else return false;
    }
    innerF = function () 
    {
      if (inner.hasNext()) return true
      else                 return outerF();
      
    }
    
    res.hasNext = outerF;
    
    return res;
  }
  
  public static function foldRight<A,B>(iter:Iterator<A>, f:A->B->B, acc:B):B
  {
    return foldLeft(reversed(iter), Function2s.flip(f), acc);
  }
  
  public static function foldRightWithIndex<A,B>(iter:Iterator<A>, f:A->B->Int->B, acc:B):B
  {
    return foldLeftWithIndex(reversed(iter), Function3s.flip(f), acc);
  }
  
  /*
   * foldl<A,B>(iter:Iterator<A>, f:B->A->B, acc:B):B
   */
  public static function foldLeft<A,B>(iter:Iterator<A>, f:B->A->B, acc:B):B
  {
    for (e in iter) {
      acc = f(acc, e);
    }
    return acc;
    
  }
  
  
  public static function foldLeftWithIndex<A,B>(iter:Iterator<A>, f:B->A->Int->B, acc:B):B
  {
    var i = 0;
    
    for (e in iter) acc = f(acc, e, i++);
    
    return acc;
  }
  
  public static function each <T>(a:Iterator<T>, f:T->Void):Void 
  {
    for (e in a) f(e);
  }
  
  public static function intersperse < T > (a:Iterator<T>, b:T):Iterator<T> 
  {
    var i = 0;
    
    return 
    {
      hasNext : function () return a.hasNext(),
      next : function () 
      {
        return if (i++ % 2 == 0) a.next() else b;
      }
    }
  }
  
  public static function last<T>(iter:Iterator<T>):T
  {
    if (!iter.hasNext()) throw "cannot get last from empty iterable";
    var last = iter.next();
    
    for (e in iter) last = e;
    
    return last;
  } 
  public static function lastOption<T>(arr:Iterator<T>):Option<T>
  {
    return if (!arr.hasNext()) None else Some(arr.next());
  } 
  
  public static function map < A, B > (it:Iterator<A>, f:A->B):Iterator<B> 
  {
    return 
    {
      hasNext : function () return it.hasNext(),
      next :    function () return f(it.next())
    }
  }
  
  public static function mapWithIndex < A, B > (it:Iterator<A>, f:A->Int->B):Iterator<B> 
  {
    var index = 0;
    
    return 
    {
      hasNext : function () return it.hasNext(),
      next :    function () return f(it.next(), index++)
    }
  }
  
  public static function mapToList < A, B > (it:Iterator<A>, f:A->B):List<B> 
  {
    var r = new List();
    
    for (e in it) r.push(f(e));
    
    return r;
  }
  
  public static function mapToListWithIndex < A, B > (it:Iterator<A>, f:A->Int->B):List<B> 
  {
    var r = new List();
    var i = 0;
    
    for (e in it) r.push(f(e, i++));
    
    return r;
  }
  
  public static function mapToArray < A, B > (it:Iterator<A>, f:A->B):Array<B> 
  {
    var r = [];
    
    for (e in it) r.push(f(e));
    
    return r;
  }
  
  public static function mapToArrayWithIndex < A, B > (it:Iterator<A>, f:A->Int->B):Array<B> 
  {
    var r = [];
    var i = 0;
    
    for (e in it) r.push(f(e, i++));
    
    return r;
  }
  
  public static function maximumBy <T>(it:Iterator<T>, f:T->T->Ordering):T 
  {
    if (!it.hasNext()) throw "cannot find maximum on empty list";
    
        
    function compare (cur, max) return switch (f(cur, max)) 
    {
      case LT: max;
      case EQ: max;
      case GT: cur;
    }
    
    return foldLeft(it, compare, it.next());
  }
  public static function maximumByOption <T>(it:Iterator<T>, f:T->T->Ordering):Option<T> 
  {
    return 
      if (!it.hasNext()) None
      else 
      {
        function compare(cur, max) return switch (f(cur, max)) 
        {
          case LT: max;
          case EQ: max;
          case GT: cur;
        }
        Some(foldLeft(it, compare, it.next()));
      }
  }
  
  public static function minimumBy <T>(it:Iterator<T>, f:T->T->Ordering):T 
  {
    if (!it.hasNext()) throw "cannot find maximum on empty list";
    
    function compare (cur, max) return switch (f(cur, max)) 
    {
      case LT: cur;
      case EQ: max;
      case GT: max;
    }
    
    return foldLeft(it, compare, it.next());
  }
  
  public static function reduceLeft <T,S>(a:Iterator<T>, f:S->T->S, first:T->S):S
  {
    if (!a.hasNext()) throw "Cannot reduce an empty Iterator";
    
    var acc = first(a.next());
    
    for (e in a) acc = f(acc, e);
    
    return acc;
  }
  
  public static function reduceLeftWithIndex <T,S>(a:Iterator<T>, f:S->T->Int->S, first:T->S):S
  {
    if (!a.hasNext()) throw "Cannot reduce an empty Iterator";
    
    var acc = first(a.next());
    var i = 1;
    
    for (e in a) 
    {
      acc = f(acc, e,i);
      i++;
    }
    return acc;
  }
  
  
  public static function reduceRight <T,S>(a:Iterator<T>, f:T->S->S, first:T->S):S
  {
    return Arrays.reduceLeft(reversedToArray(a), f.flip(), first);
  }
  
  public static function reduceRightWithIndex <T,S>(a:Iterator<T>, f:T->S->Int->S, first:T->S):S
  {
    return Arrays.reduceLeftWithIndex(reversedToArray(a), f.flip(), first);
  }
  
  // reverse on Iterators is slow, because it builds up a new 
  // iterable
  public static inline function reversed <A> (a:Iterator<A>):Iterator<A>
  {
    return reversedToArray(a).iterator();
  }
  
  public static function reversedToArray <A> (a:Iterator<A>):Array<A>
  {
    var res = [];
    
    for (e in a) res.push(e);
    
    return Arrays.reversed(res);
  }
  
  public static function size<T>(iter:Iterator<T>):Int
  {
    var s = 0;
    
    for (e in iter) s++;

    return s;
  } 
  
  public static function sum <A>(iter:Iterator<A>, f:A->Int):Int
  {
    return Iterators.foldLeft(iter, function(a,v) return a + f(v), 0);
  }
  public static function sumFloat <A>(iter:Iterator<A>, f:A->Float):Float
  {
    return Iterators.foldLeft(iter, function(a,v) return a + f(v), 0);
  }
  
  
}