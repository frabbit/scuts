package scuts.core;

import scuts.core.Ordering;
import scuts.core.Option;
import scuts.Scuts;

import scuts.core.Tup2;
import scuts.core.Tup3;

class Iterables 
{
  
  
  public static function toArray<T>(i:Iterable<T>) 
  {
    return Arrays.fromIterable(i);
  }
  
  public static function any<T>(iter:Iterable<T>, f:T->Bool):Bool 
  {
    return Iterators.any(iter.iterator(), f);
  }
  
  public static function all<T>(iter:Iterable<T>, f:T->Bool):Bool 
  {
    return Iterators.all(iter.iterator(), f);
  }
  
  public static function map<A,B>(iter:Iterable<A>, f:A->B):Iterable<B> 
  {
    var r = [];
    for (i in iter) r.push(f(i));
    return r;
  }
  
  public static function and(iter:Iterable<Bool>):Bool 
  {
    for (i in iter) if (!i) return false;
    return true;
  }
  
  public static function or(iter:Iterable<Bool>):Bool 
  {
    for (i in iter) if (i) return true;
    return false;
  }
  
  public static function cons<A>(iter:Iterable<A>, e:A):Iterable<A>
  {
    return Arrays.cons(Arrays.fromIterable(iter), e);
  }
  
  public static function head<A>(iter:Iterable<A>):A
  {
    var it = iter.iterator();
    return if (it.hasNext()) {
      it.next();
    } else {
      Scuts.error("Cannot extract head from empty Iterable");
    }
  }
  
  public static function headOption<A>(iter:Iterable<A>):Option<A>
  {
    var it = iter.iterator();
    return if (it.hasNext()) {
      Some(it.next());
    } else {
      None;
    }
  }
  
  public static function reversed<A>(iter:Iterable<A>):Iterable<A>
  {
    var r = [];
    for ( i in iter) {
      r.unshift(i);
    }
    return r;
  }
  
  public static function tail<A>(iter:Iterable<A>):Iterable<A>
  {
    var it = iter.iterator();
    return if (it.hasNext()) {
      {
        iterator : function () {
          var it = iter.iterator();
          it.next();
          return it;
        }
      }
    } else {
      Scuts.error("Cannot extract tail from empty Iterable");
    }
  }
  
  public static function tailOption<A>(iter:Iterable<A>):Option<Iterable<A>>
  {
    var it = iter.iterator();
    return if (it.hasNext()) {
      Some( {
        iterator : function () {
          var it = iter.iterator();
          it.next();
          return it;
        }
      });
    } else {
      None;
    }
  }
  
  
  public static function elemAt<A>(iter:Iterable<A>, pos:Int):A
  {
    var cur = 0;
    
    for (i in iter) {
      if (cur++ == pos) {
        return i;
      }
    }
    return Scuts.error("invalid position: " + pos);
  }
  
  public static function dropToArray<T>(a:Iterable<T>, num:Int):Array<T>
  {
    var res = [];
    var iter = a.iterator();
    var i = 0;
    while (i < num && iter.hasNext()) 
    {
      iter.next();
      i++;
    }
    while (iter.hasNext()) 
    {
      res.push(iter.next());
    }
    return res;
    
  }
  
  public static function dropToList<T>(a:Iterable<T>, num:Int):List<T>
  {
    var res = new List();
    var iter = a.iterator();
    var i = 0;
    
    while (i < num && iter.hasNext()) 
    {
      iter.next();
      i++;
    }
    while (iter.hasNext()) 
    {
      res.add(iter.next());
    }
    return res;
    
  }
  
  public static function dropWhileToArrayWithIndex<T>(a:Iterable<T>, f:T->Int->Bool):Array<T>
  {
    var res = [];
    var iter = a.iterator();
    var i = 0;
    
    while (iter.hasNext()) 
    {
      var cur = iter.next();
      
      if (!f(cur, i)) 
      {
        res.push(cur);
        break;
      }
      i++;
    }
    while (iter.hasNext()) 
    {
      res.push(iter.next());
    }
    return res;
    
  }
  
  public static function dropWhileToArray<T>(a:Array<T>, f:T->Bool):Array<T>
  {
    var res = [];
    var iter = a.iterator();
    while (iter.hasNext()) 
    {
      var cur = iter.next();
      
      if (!f(cur)) 
      {
        res.push(cur);
        break;
      }
    }
    while (iter.hasNext()) 
    {
      res.push(iter.next());
    }
    return res;
  }
  
  public static inline function elem < T > (it:Iterable<T>, e:T) 
  {
    return Iterators.elem(it.iterator(), e);
  }
  
  public static function filterToArray <A> (it:Iterable<A>, filter:A->Bool)
  {
    return Iterators.filterToArray(it.iterator(), filter);
  }
  
  public static function filterToList <A> (it:Iterable<A>, filter:A->Bool)
  {
    return Iterators.filterToList(it.iterator(), filter);
  }
  public static function findIndex<T>(iter:Iterable<T>, f:T->Bool):Option<Int>
  {
    return Iterators.findIndex(iter.iterator(), f);
  }
  
  public static function foldRight <A,B>(iter:Iterable<A>, f:A->B->B, acc:B):B
  {
    return Iterators.foldRight(iter.iterator(), f, acc);
  }
  
  public static function foldLeft <A,B>(iter:Iterable<A>, f:B->A->B, acc:B):B
  {
    return Iterators.foldLeft(iter.iterator(), f, acc);
  }
  
  #if (!macro && scuts_multithreaded)
  public static function foldLeftParallel <A,B>(iter:Iterable<A>, f:B->A->B, acc:B):B
  {
    return Iterators.foldLeftParallel(iter.iterator(), f, acc);
  }
  #end
  
  public static function foldLeftWithIndex <A,B>(iter:Iterable<A>, f:B->A->Int->B, acc:B):B
  {
    return Iterators.foldLeftWithIndex(iter.iterator(), f, acc);
  }
  
  public static function foldRightWithIndex <A,B>(iter:Iterable<A>, f:A->B->Int->B, acc:B):B
  {
    return Iterators.foldRightWithIndex(iter.iterator(), f, acc);
  }
  
  public static function each<T>(a:Iterable<T>, f:T->Void):Iterable<T> 
  {
    Iterators.each(a.iterator(), f);
    return a;
  }
  
  public static function last<T>(iter:Iterable<T>):T
  {
    return Iterators.last(iter.iterator());
  }
  
  public static function mapToList < A, B > (iterable:Iterable<A>, f:A->B):List<B> 
  {
    var r = new List();
    for (i in iterable) 
    {
      r.add(f(i));
    }
    return r;
  }
  
  public static function mapToIterator < A, B > (iterable:Iterable<A>, f:A->B):Iterator<B> 
  {
    return Iterators.map(iterable.iterator(), f);
  }
  
  public static function mapToIteratorWithIndex < A, B > (iterable:Iterable<A>, f:A->Int->B):Iterator<B> 
  {
    return Iterators.mapWithIndex(iterable.iterator(), f);
  }
  
  public static function mapToArray < A, B > (iterable:Iterable<A>, f:A->B):Array<B> 
  {
    var r = [];
    for (i in iterable) 
    {
      r.push(f(i));
    }
    return r;
  }
  
  public static function mapToListWithIndex < A, B > (iterable:Iterable<A>, f:A->Int->B):List<B> 
  {
    var r = new List();
    var index = 0;
    for (e in iterable) 
    {
      r.add(f(e, index));
      index++;
    }
    return r;
  }
  
  
  public static function mapToArrayWithIndex < A, B > (iterable:Iterable<A>, f:A->Int->B):Iterable<B> 
  {
    var r = [];
    var index = 0;
    for (i in iterable) 
    {
      r.push(f(i, index++));
    }
    return r;
  }
  
  public static inline function maximumBy <T>(it:Iterable<T>, f:T->T->Ordering):T 
  {
    return Iterators.maximumBy(it.iterator(), f);
  }
  
  public static inline function maximumByOption <T>(it:Iterable<T>, f:T->T->Ordering):Option<T> 
  {
    return Iterators.maximumByOption(it.iterator(), f);
  }
  
   public static inline function minimumBy <T>(it:Iterable<T>, f:T->T->Ordering):T 
  {
    return Iterators.minimumBy(it.iterator(), f);
  }
  
  public static inline function size<T>(iter:Iterable<T>):Int
  {
    return Iterators.size(iter.iterator());
  }
  
  public static function sum <A>(iter:Iterable<A>, f:A->Int):Int
  {
    return Iterators.sum(iter.iterator(), f);
  }
  public static function sumFloat <A>(iter:Iterable<A>, f:A->Float):Float
  {
    return Iterators.sumFloat(iter.iterator(), f);
  }
  
  public static function take<T> (it:Iterable<T>, numElements:Int):Iterable<T> 
  {
    var res = [];
    var i = 0;
    for (e in it) 
    {
      if (i++ == numElements) break;
      res.push(e);
    }
    return res;
  }
  
  public static function zipWith < A, B, C > (arr1:Iterable<A>, arr2:Iterable<B>, f:A->B->C):Iterable<C>
  {
    var it1 = arr1.iterator(), it2 = arr2.iterator();
    var res = [];
    
    while (it1.hasNext() && it2.hasNext()) 
    {
      res.push(f(it1.next(), it2.next()));
    }
    
    return res;
  }
  
  public static function zipWith3 < A, B, C, D > (arr1:Iterable<A>, arr2:Iterable<B>, arr3:Iterable<C>, f:A->B->C->D):Iterable<D>
  {
    var it1 = arr1.iterator(), it2 = arr2.iterator(), it3 = arr3.iterator();
    var res = [];
    
    while (it1.hasNext() && it2.hasNext() && it3.hasNext()) 
    {
      res.push(f(it1.next(), it2.next(), it3.next()));
    }
    return res;
  }
  
  public static function zip < A, B, C > (arr1:Iterable<A>, arr2:Iterable<B>):Iterable<Tup2<A,B>>
  {
    var it1 = arr1.iterator(), it2 = arr2.iterator();
    var res = [];
    
    while (it1.hasNext() && it2.hasNext()) 
    {
      res.push(Tup2.create(it1.next(), it2.next()));
    }
    return res;
  }
  
  public static function zip3 < A, B, C, D > (arr1:Iterable<A>, arr2:Iterable<B>, arr3:Iterable<C>):Iterable<Tup3<A,B,C>>
  {
    var it1 = arr1.iterator(), it2 = arr2.iterator(), it3 = arr3.iterator();
    var res = [];
    
    while (it1.hasNext() && it2.hasNext() && it3.hasNext()) 
    {
      res.push(Tup3.create(it1.next(), it2.next(), it3.next()));
    }
    
    return res;
  }
}