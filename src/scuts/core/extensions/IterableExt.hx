package scuts.core.extensions;

import scuts.core.types.Ordering;
import scuts.core.types.Option;

import scuts.core.types.Tup2;
import scuts.core.types.Tup3;

class IterableExt 
{
  public static function toLazyIterator<T>(i:Iterable<T>) 
  {
    return function () return i.iterator();
  }
  
  public static function any<T>(iter:Iterable<T>, f:T->Bool):Bool 
  {
    return IteratorExt.any(iter.iterator(), f);
  }
  
  public static function dropToArray<T>(a:Iterable<T>, num:Int):Array<T>
  {
    var res = [];
    var iter = a.iterator();
    var i = 0;
    while (i < num && iter.hasNext()) {
      
      iter.next();
      i++;
    }
    while (iter.hasNext()) {
      res.push(iter.next());
    }
    return res;
    
  }
  
  public static function dropToList<T>(a:Iterable<T>, num:Int):List<T>
  {
    var res = new List();
    var iter = a.iterator();
    var i = 0;
    while (i < num && iter.hasNext()) {
      
      iter.next();
      i++;
    }
    while (iter.hasNext()) {
      res.add(iter.next());
    }
    return res;
    
  }
  
  public static function dropWhileToArrayWithIndex<T>(a:Iterable<T>, f:T->Int->Bool):Array<T>
  {
    var res = [];
    var iter = a.iterator();
    var i = 0;
    while (iter.hasNext()) {
      
      var cur = iter.next();
      
      if (!f(cur, i)) {
        res.push(cur);
        break;
      }
      i++;
    }
    while (iter.hasNext()) {
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
      
      if (!f(cur)) {
        res.push(cur);
        break;
      }
    }
    while (iter.hasNext()) {
      res.push(iter.next());
    }
    return res;
  }
  
  public static inline function elem < T > (it:Iterable<T>, e:T) {
    return IteratorExt.elem(it.iterator(), e);
  }
  
  public static function filterToArray <A> (it:Iterable<A>, filter:A->Bool)
	{
		return IteratorExt.filterToArray(it.iterator(), filter);
	}
	
	public static function filterToList <A> (it:Iterable<A>, filter:A->Bool)
	{
		return IteratorExt.filterToList(it.iterator(), filter);
	}
  public static function findIndex<T>(iter:Iterable<T>, f:T->Bool):Option<Int>
  {
    return IteratorExt.findIndex(iter.iterator(), f);
  }
  
  public static function foldRight <A,B>(iter:Iterable<A>, f:A->B->B, acc:B):B
	{
		return IteratorExt.foldRight(iter.iterator(), f, acc);
	}
	public static function foldLeft <A,B>(iter:Iterable<A>, f:B->A->B, acc:B):B
	{
		return IteratorExt.foldLeft(iter.iterator(), f, acc);
	}
  #if (!macro && scuts_multithreaded)
  public static function foldLeftParallel <A,B>(iter:Iterable<A>, f:B->A->B, acc:B):B
	{
		return IteratorExt.foldLeftParallel(iter.iterator(), f, acc);
	}
  #end
	
	public static function foldLeftWithIndex <A,B>(iter:Iterable<A>, f:B->A->Int->B, acc:B):B
	{
		return IteratorExt.foldLeftWithIndex(iter.iterator(), f, acc);
	}
	public static function foldRightWithIndex <A,B>(iter:Iterable<A>, f:A->B->Int->B, acc:B):B
	{
		return IteratorExt.foldRightWithIndex(iter.iterator(), f, acc);
	}
  public static function forEach<T>(a:Iterable<T>, f:T->Void):Void 
  {
    IteratorExt.forEach(a.iterator(), f);
  }
  
  public static function last<T>(iter:Iterable<T>):T
  {
    return IteratorExt.last(iter.iterator());
  }
  
  public static function mapToList < A, B > (iterable:Iterable<A>, f:A->B):List<B> 
	{
		var r = new List();
		for (i in iterable) {
			r.add(f(i));
		}
		return r;
	}
  
  public static function mapToIterator < A, B > (iterable:Iterable<A>, f:A->B):Iterator<B> 
	{
		return IteratorExt.map(iterable.iterator(), f);
	}
  
  public static function mapToIteratorWithIndex < A, B > (iterable:Iterable<A>, f:A->Int->B):Iterator<B> 
	{
		return IteratorExt.mapWithIndex(iterable.iterator(), f);
	}
  
	public static function mapToArray < A, B > (iterable:Iterable<A>, f:A->B):Array<B> 
	{
		var r = [];
		for (i in iterable) {
			r.push(f(i));
		}
		return r;
	}
	
	public static function mapToListWithIndex < A, B > (iterable:Iterable<A>, f:A->Int->B):List<B> 
	{
		var r = new List();
    var index = 0;
		for (e in iterable) {
			r.add(f(e, index));
      index++;
		}
		return r;
	}
	
	
	public static function mapToArrayWithIndex < A, B > (iterable:Iterable<A>, f:A->Int->B):Iterable<B> 
	{
		var r = [];
    var index = 0;
		for (i in iterable) {
			r.push(f(i, index++));
		}
		return r;
	}
  
  public static inline function maximumBy <T>(it:Iterable<T>, f:T->T->Ordering):T 
  {
    return IteratorExt.maximumBy(it.iterator(), f);
  }
  
  public static inline function maximumByOption <T>(it:Iterable<T>, f:T->T->Ordering):Option<T> 
  {
    return IteratorExt.maximumByOption(it.iterator(), f);
  }
  
   public static inline function minimumBy <T>(it:Iterable<T>, f:T->T->Ordering):T 
  {
    return IteratorExt.minimumBy(it.iterator(), f);
  }
  
  public static inline function size<T>(iter:Iterable<T>):Int
  {
    return IteratorExt.size(iter.iterator());
  }
  
  public static function sum <A>(iter:Iterable<A>, f:A->Int):Int
	{
		return IteratorExt.sum(iter.iterator(), f);
	}
	public static function sumFloat <A>(iter:Iterable<A>, f:A->Float):Float
	{
		return IteratorExt.sumFloat(iter.iterator(), f);
	}
  
  public static function take<T> (it:Iterable<T>, numElements:Int):Iterable<T> 
	{
		var res = [];
		var i = 0;
		for (e in it) {
			if (i++ == numElements) break;
      res.push(e);
			
			
		}
		return res;
	}
  
  public static function zipWith < A, B, C > (arr1:Iterable<A>, arr2:Iterable<B>, f:A->B->C):Iterable<C>
	{
    var it1 = arr1.iterator(), it2 = arr2.iterator();
    var res = [];
		while (it1.hasNext() && it2.hasNext()) {
      res.push(f(it1.next(), it2.next()));
    }
		
		return res;
	}
  
  public static function zipWith2 < A, B, C, D > (arr1:Iterable<A>, arr2:Iterable<B>, arr3:Iterable<C>, f:A->B->C->D):Iterable<D>
	{
    var it1 = arr1.iterator(), it2 = arr2.iterator(), it3 = arr3.iterator();
    var res = [];
		while (it1.hasNext() && it2.hasNext() && it3.hasNext()) {
      res.push(f(it1.next(), it2.next(), it3.next()));
    }
		return res;
	}
	
	public static function zip < A, B, C > (arr1:Iterable<A>, arr2:Iterable<B>):Iterable<Tup2<A,B>>
	{
    var it1 = arr1.iterator(), it2 = arr2.iterator();
		var res = [];
		while (it1.hasNext() && it2.hasNext()) {
      res.push(Tup2.create(it1.next(), it2.next()));
    }
		return res;
	}
  
  public static function zip2 < A, B, C, D > (arr1:Iterable<A>, arr2:Iterable<B>, arr3:Iterable<C>):Iterable<Tup3<A,B,C>>
	{
    var it1 = arr1.iterator(), it2 = arr2.iterator(), it3 = arr3.iterator();
		var res = [];
		while (it1.hasNext() && it2.hasNext() && it3.hasNext()) {
      res.push(Tup3.create(it1.next(), it2.next(), it3.next()));
    }
    
		return res;
	}
}