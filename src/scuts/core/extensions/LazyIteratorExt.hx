package scuts.core.extensions;
import scuts.core.types.LazyIterator;

import scuts.core.types.Option;

import scuts.core.types.Ordering;

using scuts.core.extensions.DynamicExt;



class LazyIteratorExt 
{

  public static function cons<T>(l:LazyIterator<T>, t:T):LazyIterator<T> 
  {
    return function () {
      var first = true;
      var iter:LazyIterator<T> = {
        var v = null;
        var isSet = false;
        function () {
          if (isSet) return v;
          
          isSet = true;
          return v = l();
        }
      }
      return {
        hasNext : function () {
          return first || { iter().hasNext();};
        },
        next: function () {
          return if (first) {first = false; t;} else iter().next();
        }
      }
    }
  }
  
  public static function any<T>(iter:LazyIterator<T>, f:T->Bool):Bool
  {
    return IteratorExt.any(iter(), f);
  }
  public static function drop<T>(a:LazyIterator<T>, num:Int):LazyIterator<T>
  {
    return function () return IteratorExt.drop(a(), num);
  }
  
  public static inline function elem < T > (it:LazyIterator<T>, e:T) {
    return IteratorExt.elem(it(), e);
  }
  
  public static function filter < A > (it:LazyIterator<A>, filter:A->Bool):LazyIterator<A>
  {
    return function () return IteratorExt.filter(it(), filter);
  }
  public static function findIndex<T>(iter:LazyIterator<T>, f:T->Bool):Option<Int>
  {
    return IteratorExt.findIndex(iter(), f);
  }
  
  public static function flatMap < S, T > (w:LazyIterator<S>, f:S->LazyIterator<T>):LazyIterator<T> {
    return function () {
      var inInner = false;
      var outer = null;
      var inner:Iterator<T> = null;
      
      var res = {
        hasNext : null,
        next : function () return inner.next()
      }
      var outerF = null;
      var innerF = null;
      
      outerF = function () {
        if (outer == null) outer = w();
        if (outer.hasNext()) {
          var val = outer.next();
          inner = f(val)();
          res.hasNext = innerF;
          return innerF();
        } else {
          return false;
        }
      }
      innerF = function () {
        if (inner.hasNext()) {
          return true;
        } else {
          return outerF();
        }
      }
      
      res.hasNext = outerF;
      return res;
    }
  }
  
  public static function flatten < T > (v:LazyIterator<LazyIterator<T>>):LazyIterator<T> {
    
    return function () {
      
      var inInner = false;
      var outer = null;
      var inner:Iterator<T> = null;
      
      var res = {
        hasNext : null,
        next : function () return inner.next()
      }
      var outerF = null;
      var innerF = null;
      
      outerF = function () {
        if (outer == null) outer = v();
        if (outer.hasNext()) {
          var val = outer.next();
          inner = val();
          res.hasNext = innerF;
          return innerF();
        } else {
          return false;
        }
      }
      innerF = function () {
        if (inner.hasNext()) {
          return true;
        } else {
          return outerF();
        }
      }
      
      res.hasNext = outerF;
      return res;
    }
    
  }
  
  public static function foldRight<A,B>(iter:LazyIterator<A>, f:A->B->B, acc:B):B
	{
		return IteratorExt.foldRight(iter(), f, acc);
	}
	
	public static function foldRightWithIndex<A,B>(iter:LazyIterator<A>, f:A->B->Int->B, acc:B):B
	{
		return IteratorExt.foldRightWithIndex(iter(), f, acc);
	}
	/*
   * foldl<A,B>(iter:Iterator<A>, f:B->A->B, acc:B):B
   */
	public static function foldLeft<A,B>(iter:LazyIterator<A>, f:B->A->B, acc:B):B
	{
		return IteratorExt.foldLeft(iter(), f, acc);
		
	}
	
	public static function foldLeftWithIndex < A, B > (iter:LazyIterator<A>, f:B->A->Int->B, acc:B):B
  {
    return IteratorExt.foldLeftWithIndex(iter(), f, acc);
  }
  
  public static function intersperse < T > (a:LazyIterator<T>, b:T):LazyIterator<T> 
  {
    return function () return IteratorExt.intersperse(a(), b);
  }
  
  public static function last<T>(iter:LazyIterator<T>):T
  {
    return IteratorExt.last(iter());
  } 
  
  public static function map < A, B > (it:LazyIterator<A>, f:A->B):LazyIterator<B> 
	{
    return function () return IteratorExt.map(it(), f);
	}
  
  public static function mapWithIndex < A, B > (it:LazyIterator<A>, f:A->Int->B):LazyIterator<B> 
	{
    return function () return IteratorExt.mapWithIndex(it(), f); 
	}
  
  public static inline function maximumBy <T>(it:LazyIterator<T>, f:T->T->Ordering):T 
  {
    return IteratorExt.maximumBy(it(), f);
  }
  
  public static inline function minimumBy <T>(it:LazyIterator<T>, f:T->T->Ordering):T 
  {
    return IteratorExt.minimumBy(it(), f);
  }
  
  public static function size<T>(iter:LazyIterator<T>):Int
  {
    return IteratorExt.size(iter());
  } 
  
  public static function take<T>(iter:LazyIterator<T>, numElements:Int):LazyIterator<T>
  {
    return function () return IteratorExt.take(iter(), numElements);
  }
  
}