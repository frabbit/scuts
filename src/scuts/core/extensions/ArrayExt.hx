package scuts.core.extensions;

import scuts.core.macros.Lazy;
import scuts.core.types.Option;
import scuts.core.types.Ordering;
import scuts.core.types.Tup2;
import scuts.Scuts;

using scuts.core.extensions.FunctionExt;
using scuts.core.extensions.IntExt;
using scuts.core.extensions.DynamicExt;




class ArrayExt
{

  /**
   * Concatenates all Some X values in a and returns a new list containing only X values.
   */
  public static function catOptions <X>(a:Array<Option<X>>):Array<X>
  {
    var res = [];
    
    for (e in a) 
    {
      switch (e) {
        case Some(v): res.push(v);
        case None:
      }
    }
    return res;
  }
  
  /**
   * Returns an Array that contains all elements from a which are not elements of b.
   * If a contains duplicates, the resulting Array contains duplicates.
   */
  public static function difference <T>(a:Array<T>, b:Array<T>, eq:T->T->Bool) {
    var res = [];
    for (e in a) {
      if (!any(b, function (x) return eq(x, e))) res.push(e);
    }
    return res;
  }
  
  /**
   * Returns an Array that contains all elements from a which are also elements of b.
   * If a contains duplicates, the resulting Array contains duplicates.
   */
  public static function intersect <T>(a:Array<T>, b:Array<T>, eq:T->T->Bool) 
  {
    var res = [];
    for (e in a) {
      if (any(b, function (x) return eq(x, e))) res.push(e);
    }
    return res;
  }
  
  /**
   * Returns an Array that contains all elements from a which are also elements of b.
   * If a contains duplicates, so will the result.
   */
  public static function union <T>(a:Array<T>, b:Array<T>, eq:T->T->Bool) 
  {
    var res = [];
    for (e in a) {
      res.push(e);
    }
    for (e in b) {
      if (!any(res, function (x) return eq(x, e))) res.push(e);
    }
    return res;
  }
  
  /**
   * Checks if a1 and a2 are equal, the elements are compared by eqElem.
   */
  public static function eq <T>(a1:Array<T>, a2:Array<T>, eqElem:T->T->Bool)
  {
    if (a1.length != a2.length) return false;
    for ( i in 0...a1.length) {
      if (!eqElem(a1[i], a2[i])) return false;
    }
    return true;
  }
  /**
   * Checks if a1 and a2 are equal, the elements are compared by eqElem.
   */
  public static function shuffle <T>(arr:Array<T>):Array<T> 
  {
    var res = [];
    var cp = arr.copy();
    while (cp.length > 0) {
      var randIndex = Math.floor(Math.random()*cp.length);
      res.push(cp.splice(randIndex,1)[0]);
    }
    return res;
  }
  
  public static function toIntHash <T>(arr:Array<T>, key:T->Int):IntHash<T> {
    var h = new IntHash();
    for (a in arr) {
      h.set(key(a), a);
    }
    return h;
  }
  
  // override Iterable for performance
  public static inline function dropToArray<T>(a:Array<T>, num:Int):Array<T> {
    return drop(a, num);
  }
  /**
   * Returns true if all elements of a satisfy the predicate pred.
   */
  public static function all <T>(a:Array<T>, pred:T->Bool) 
  {
    var s = true;
    for (e in a) if (!pred(e)) 
    {
      s = false;
      break;
    }
    
    return s;
  }
  
  /**
   * Returns true if any of the elements of a satisfy the predicate pred.
   */
  public static function any <T>(a:Array<T>, pred:T->Bool) 
  {
    for (e in a) if (pred(e)) 
    {
      return true;
    }
    return false;
  }
  
  /**
   * Returns a new Array containing all elements of a except the first num elements.
   */
  public static function drop<T>(a:Array<T>, num:Int):Array<T>
  {
    var res = [];
    var i = 0;
    while (i < num && i < a.length) {
      i++;
    }
    while (i < a.length) {
      res.push(a[i]);
      i++;
    }
    return res;
    
  }
  /**
   * Returns a new array based on a, containing all elements of a starting from the first where the predicate f holds.
   */
  public static function dropWhileWithIndex<T>(a:Array<T>, f:T->Int->Bool):Array<T>
  {
    var res = [];
    var i = 0;
    while (i < a.length && f(a[i], i)) {
      i++;
    }
    while (i < a.length) {
      res.push(a[i]);
      i++;
    }
    return res;
    
  }
  
  public static function dropWhile<T>(a:Array<T>, f:T->Bool):Array<T>
  {
    var res = [];
    var i = 0;
    while (i < a.length && f(a[i])) {
      i++;
    }
    while (i < a.length) {
      res.push(a[i]);
      i++;
    }
    return res;
    
  }
  
  public static inline function filter <A> (a:Array<A>, filter:A->Bool):Array<A>
  {
    var res = [];
    for ( e in a) {
      if (filter(e)) res.push(e);
    }
    return res;
  }
  public static function filterWithIndex <A> (a:Array<A>, filter:A->Int->Bool):Array<A>
  {
    var res = [];
    for ( i in 0...a.length) {
      var e = a[i];
      if (filter(e, i)) res.push(e);
    }
    return res;
  }
  
  public static function firstOption<T>(a:Array<T>):Option<T> 
  {
    return if (a.length == 0) None else Some(a[0]);
  }
  
  public static function first<T>(a:Array<T>):T
  {
    return if (a.length == 0) Scuts.error("Array a has no first element") else a[0];
  }
  public static function flatMap < S, T > (w:Array<S>, f:S->Array<T>):Array<T>
  {
    var res = [];
    for (i in w) {
      for (j in f(i)) {
        res.push(j);
      }
    }
    return res;
  }
  public static function flatten <T>(a:Array<Array<T>>):Array<T>
  {
    var res = [];
    for (a1 in a) {
      for (e in a1) {
        res.push(e);
      }
    }
    return res;
  }
  public static inline function forEach<T>(a:Array<T>, f:T->Void):Void 
  {
    for (e in a) {
      f(e);
    }
  }
  
  public static function intersperse < T > (a:Array<T>, b:T):Array<T> 
  {
    return if (a.length == 0) {
      [];
    } else {
      var res = [a[0]];
      for ( i in 1...a.length) 
      {
        res.push(b);
        res.push(a[i]);
      }
      res;
    }
  }
  
  public static function foldRight<A,B>(arr:Array<A>, f:A->B->B, acc:B):B
  {
    var rev = reverseCopy(arr);
    for (i in 0...rev.length) 
    {
      acc = f(rev[i], acc);
    }
    return acc;
  }
  
  public static function foldRightWithIndex<A,B>(arr:Array<A>, f:A->B->Int->B, acc:B):B
  {
    var rev = reverseCopy(arr);
    for (i in 0...rev.length) 
    {
      acc = f(rev[i], acc, rev.length -1 -i);
    }
    return acc;
  }
  
  public static function foldLeft<A,B>(arr:Array<A>, f:B->A->B, acc:B):B
  {
    for (i in 0...arr.length) 
    {
      acc = f(acc, arr[i]);
    }
    return acc;
  }
  
  public static function foldLeftWithIndex<A,B>(arr:Array<A>, f:B->A->Int->B, acc:B):B
  {
    for (i in 0...arr.length) 
    {
      acc = f(acc, arr[i], i);
    }
    return acc;
  }
  
  public static function last<T>(arr:Array<T>):T
  {
    return 
      if (arr.length == 0) Scuts.error("cannot get last from empty array")
      else arr[arr.length - 1];
  }
  
  public static function lastOption<T>(arr:Array<T>):Option<T>
  {
    return if (arr.length == 0) None else Some(arr[arr.length - 1]);
  } 
  public static inline function map < A, B > (arr:Array<A>, f:A->B):Array<B> 
  {
    return IterableExt.mapToArray(arr, f);
  }
  
  public static function mapWithIndex < A, B > (arr:Array<A>, f:A->Int->B):Array<B> 
  {
    var r = [];
    for (i in 0...arr.length) {
      r.push(f(arr[i], i));
    }
    return r;
  }
  
  public static function reduceLeftWithIndexToString <T>(a:Array<T>, f:String->T->Int->String):String
  {
    return reduceLeftWithIndex(a, f, Std.string);
  }
  
  public static function reduceRightWithIndexToString <T>(a:Array<T>, f:T->String->Int->String):String
  {
    return reduceRightWithIndex(a, f, Std.string);
  }
  
  public static function reduceLeftToString <T>(a:Array<T>, f:String->T->String):String
  {
    return reduceLeft(a, f, Std.string);
  }
  
  public static function reduceRightToString <T>(a:Array<T>, f:T->String->String):String
  {
    return reduceRight(a, f, Std.string);
  }
  
  public static function reduceLeft <T,S>(a:Array<T>, f:S->T->S, first:T->S):S
  {
    if (a.length == 0) Scuts.error("Cannot reduce an empty Array");
    
    var acc = first(a[0]);
    for (i in 1...a.length) {
      acc = f(acc, a[i]);
    }
    return acc;
  }
  
  public static function reduceLeftWithIndex <T,S>(a:Array<T>, f:S->T->Int->S, first:T->S):S
  {
    if (a.length == 0) throw "Cannot reduce an empty Array";
    
    var acc = first(a[0]);
    for (i in 1...a.length) {
      acc = f(acc, a[i],i);
    }
    return acc;
  }
  
  
  
  public static function equals <T>(a1:Array<T>, a2:Array<T>, eqT:T->T->Bool) {
    var equalsElements = Lazy.expr({
      var eq = true;
      for (i in 0...a1.length) {
        if (!eqT(a1[i], a2[i])) {
          eq = false;
          break;
        }
      }
      eq;
    });
    
    return a1.length == a2.length
      && equalsElements();
  }
  
  
  public static function some <T>(arr:Array<T>, e:T->Bool):Option<T> {
    for (i in arr) {
      if (e(i)) return Some(i);
    }
    return None;
  }
  
  public static function someWithIndex <T>(arr:Array<T>, p:T->Bool):Option<Tup2<T, Int>> {
    for (i in 0...arr.length) {
      var elem = arr[i];
      if (p(elem)) return Some(Tup2.create(elem, i));
    }
    return None;
  }
  
  public static function someMappedWithIndex <A,B>(arr:Array<A>, map:A->B, p:B->Bool):Option<Tup2<B, Int>> {
    for (i in 0...arr.length) {
      var elem = arr[i];
      var mapped = map(elem);
      
      if (p(mapped)) return Some(Tup2.create(mapped, i));
    }
    return None;
  }
  
  
  
  
  public static function reduceRight <T,S>(a:Array<T>, f:T->S->S, first:T->S):S
  {
    if (a.length == 0) throw "Cannot reduce an empty Array";
    
    var a1 = reverseCopy(a);
    
    var acc = first(a1[0]);
    for (i in 1...a1.length) {
      acc = f(a1[i], acc);
    }
    return acc;
    
  }
  
  public static function reduceRightWithIndex <T,S>(a:Array<T>, f:T->S->Int->S, first:T->S):S
  {
    if (a.length == 0) throw "Cannot reduce an empty Array";
    
    var a1 = reverseCopy(a);
    
    var acc = first(a1[0]);
    for (i in 1...a1.length) {
      acc = f(a1[i], acc, a1.length - i);
    }
    return acc;
  }
  
  public static function reverseCopy <A> (a:Array<A>):Array<A>
  {
    var c = a.length;
    var res = [];
    for (e in a) {
      res[--c] = e;
    }
    return res;
  }
  
  public static inline function size<T>(arr:Array<T>):Int
  {
    return arr.length;
  } 
  
  
  public static function nub <T> (a:Array<T>, eq:T->T->Bool) 
  {
    var r = [];
    for (e in a) {
      if (!any(r, function (x) return eq(x,e))) r.push(e);
    }
    return r;
  }
  
  public static function sortToBy<T>(a:Array<T>, ?f:T->T->Ordering):Array<T> 
  {
    var res = a.copy();
    res.sort(function (a, b) return switch (f(a,b)) {
      case LT: -1;
      case EQ: 0;
      case GT: 1;
    });
    return res;
  }
  
  public static function take<T> (it:Array<T>, numElements:Int):Array<T> 
  {
    var res = [];
    
    for (i in 0...it.length) {
      if (i == numElements) break;
      res.push(it[i]);
    }
    return res;
  }
  
  public static function toArrayOption <T>(a:Array<T>):Array<Option<T>> 
  {
    var res = [];
    
    for (e in a) {
      res.push(DynamicExt.toOption(e));
    }
    
    return res;
  }
  
  public static function toOption <T>(arr:Array<T>):Option<Array<T>> 
  {
    return if (arr.length == 0) None else Some(arr);
  }
  
  public static function zipWith < A, B, C > (arr1:Array<A>, arr2:Array<B>, f:A->B->C):Array<C>
  {
    var min = arr1.length.min(arr2.length);
    var res = [];
    for (i in 0...min) {
      res.push(f(arr1[i], arr2[i]));
    }
    return res;
  }
  
  
  
  public static function zipWithWhileC < A, B, C > (arr1:Array<A>, arr2:Array<B>, f:A->B->C, cond:C->Bool):Array<C>
  {
    var min = arr1.length.min(arr2.length);
    var res = [];
    
    for (i in 0...min) 
    {
      var v = f(arr1[i], arr2[i]);
      if (cond(v))
        res.push(f(arr1[i], arr2[i]));
      else
        break;
    } 
    return res;
  }
  
  public static function zipFoldLeftWhile<A,B,C> (arr1:Array<A>, arr2:Array<B>, f:C->A->B->C, cond:C->Bool, init:C):C
  {
    var min = arr1.length.min(arr2.length);
    
    var res = init;
    for (i in 0...min) {
      if (cond(res))
        res = f(res, arr1[i], arr2[i])
      else 
        break;
    }
    return res;
  }
  
  public static function zipFoldLeft<A,B,C> (arr1:Array<A>, arr2:Array<B>, f:C->A->B->C, init:C):C
  {
    var min = arr1.length.min(arr2.length);
    
    var res = init;
    for (i in 0...min) {
      res = f(res, arr1[i], arr2[i]);
    }
    return res;
  }
  
  public static function zipWith2 < A, B, C, D > (arr1:Array<A>, arr2:Array<B>, arr3:Array<C>, f:A->B->C->D):Array<D>
  {
    var min = arr1.length.min(arr2.length).min(arr3.length);
    var res = [];
    for (i in 0...min) {
      res.push(f(arr1[i], arr2[i], arr3[i]));
    }
    return res;
  }
  
  public static function zip < A, B, C > (arr1:Array<A>, arr2:Array<B>):Array<Tup2<A,B>>
  {
    var min = arr1.length.min(arr2.length);
    var res = [];
    for (i in 0...min) {
      res.push(Tup2.create(arr1[i], arr2[i]));
    }
    return res;
  }
  
  public static function insertElemFront <A> (a:Array<A>, e:A):Array<A> 
  {
    var cp = a.copy();
    cp.unshift(e);
    return cp;
  }
  
  public static function insertElemBack <A> (a:Array<A>, e:A):Array<A> 
  {
    var cp = a.copy();
    cp.push(e);
    return cp;
  }
  
  public static function insertElemAt <A> (a:Array<A>, e:A, index:Int):Array<A> 
  {
    var cp = a.copy();
    cp.insert(index, e);
    return cp;
  }
  
  public static function replaceElemAt <A> (a:Array<A>, e:A, index:Int):Array<A> 
  {
    var res = [];
    for (i in 0...a.length) {
      if (i == index) res.push(e)
      else res.push(a[i]);
    }
    return res;
  }
  
  public static function removeElem <A> (a:Array<A>, e:A, ?equals:A->A->Bool):Array<A> {
    equals = equals.nullGetOrElseConst(function (x1, x2) return x1 == x2);
    var res = [];
    for (i in a) {
      if (!equals(i, e)) res.push(i);  
    }
    return res;
  }
  
  public static function removeElemAt <A> (a:Array<A>, at:Int):Array<A> {
    var res = [];
    for (i in 0...a.length) {
      if (i != at) res.push(a[i]);
    }
    return res;
  }
  
  public static function removeLast <A> (a:Array<A>):Array<A> 
  {
    return if (a.length > 0) {
      var res = a.copy();
      res.pop();
      res;
    } else {
      a;
    }
  }
  public static function removeFirst <A> (a:Array<A>):Array<A> 
  {
    return if (a.length > 0) {
      var res = a.copy();
      res.shift();
      res;
    } else {
      a;
    }
  }
  
  
}
