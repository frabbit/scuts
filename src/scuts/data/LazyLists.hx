package scuts.data;

import scuts.Assert;
import scuts.core.extensions.Arrays;
import scuts.core.types.Option;
import scuts.core.types.Tup2;
import scuts.core.macros.Lazy;
//import scuts.macros.P;
import scuts.Scuts;
import scuts.data.LazyList;
using scuts.core.extensions.Iterators;
using scuts.core.extensions.Options;

private typedef LL<T> = LazyList<T>;

class LazyListIter<T> 
{
  var v:Null<T>;
  var hasNextTrue:Bool;
  var l:LL<T>;
  
  public function new (l:LL<T>) {
    this.l = l;
    v = null;
    hasNextTrue = false;
  }
  public function hasNext () 
  {
    hasNextTrue = hasNextTrue || switch (l()) {
      case LazyNil: hasNextTrue = false;
      case LazyCons(e, tail): 
        v = e;
        l = tail;
        hasNextTrue = true;
    }
    return hasNextTrue;
  }

  public function next () {
    if (!hasNext()) {
      Scuts.error("Iterator has no value left");
    }
    hasNextTrue = false;
    return v;
  }
}

private typedef A = Arrays;

class LazyLists {
  
  static var EMPTY_LIST = function () return LazyNil;
  
  public static function fromArray <T> (arr:Array<T>):LL<T> {
    var cp = arr.copy();
    return fromArrayAsView(cp, 0, cp.length);
  }
  
  public static function isEmpty <T> (l:LL<T>):Bool 
  {
    return switch (l()) { case LazyNil:true; default: false;}
  }
  
  public static function toArray <T> (l:LL<T>):Array<T> 
  {
    var res = [];
    var loop = true;
    while (loop) {
      var e = l();
      switch (e) {
        case LazyNil: loop = false;
        case LazyCons(e, tail):
          res.push(e);
          l = tail;
      }
    }
    return res;
  }
  
  public static inline function fromIterable <T> (it:Iterable<T>):LL<T> {
    return fromIterator(it.iterator());
  }
  
  public static inline function fromIterator <T> (it:Iterator<T>):LL<T> {
    return fromArrayAsView(it.toArray());
  }
  
  public static inline function iterator <T> (l:LL<T>):Iterator<T> {
    
    return new LazyListIter(l);
    
  }
  
  public static function reverseCopy <T> (l:LL<T>):LL<T> 
  {
    var a = toArray(l);
    var rev = Arrays.reverseCopy(a);
    return fromArrayAsView(rev);
    
  }
  
  public static function foldLeft <A,B> (list:LL<A>, f:B->A->B, acc:B):B 
  {
    return A.foldLeft(toArray(list),f, acc);
  }
  
  public static function foldRight <A,B> (list:LL<A>, f:A->B->B, acc:B):B 
  {
    return A.foldRight(toArray(list), f, acc);
  }
  
  public static function foldLeftWithIndex <A,B> (list:LL<A>, f:B->A->Int->B, acc:B):B 
  {
    return A.foldLeftWithIndex(toArray(list), f, acc);
  }
  
  public static function foldRightWithIndex <A,B> (list:LL<A>, f:A->B->Int->B, acc:B):B 
  {
    return A.foldRightWithIndex(toArray(list), f, acc);
  }
  
  public static function foldLeft1 <A,B> (list:LL<A>, f:A->A->A):A 
  {
    
    var a = toArray(list);
    Assert.assertTrue(a.length > 0);
    var init = a[0];
    for (i in 1...a.length) {
      init = f(init, a[i]);
    }
    return init;
  }
  
  public static function toString <T> (list:LL<T>, ?s:T->String):String {
    var toString = s == null ? Std.string : s;
    return foldLeftWithIndex(list, function (acc, el, i) return acc + ((i>0) ? ", " : "") + toString(el), "[") + "]";
  }
  
  public static function fromArrayAsView <T> (arr:Array<T>, index:Int = 0, to:Int = -1):LL<T> {
    to = (to == -1) ? arr.length : to;
    Assert.assertTrue(to <= arr.length);
    return Lazy.expr({
      Assert.assertTrue(to <= arr.length);
      if (index < to) {
        LazyCons(arr[index], fromArrayAsView(arr, index+1, to));
      } else {
        LazyNil;
      }
    });
  }
  
  public static function take <T> (l:LL<T>, num:Int):LL<T> {
    Assert.assertTrue(num >= 0);
    return Lazy.expr({
      if (num-1 < 0) {
        LazyNil;
      } else {
        switch (l()) {
          case LazyNil: LazyNil;
          case LazyCons(e, tail): LazyCons(e, take(tail, num-1));
        }
      }
    });
  }
  
  public static function drop <T> (l:LL<T>, num:Int):LL<T> {
    return Lazy.expr({
      var res = l();
      while (--num >= 0) {
        switch (res) {
          case LazyNil:
            break;
          case LazyCons(e, tail): 
            res = tail();
        }
      }
      res;
    });
  }
  
  public static function insertElemAt <T> (l:LL<T>, el:T, at:Int):LL<T> {
    #if debug Assert.assertTrue(size(l) >= at, "Position " + at + " must be between 0 and list size (" + size(l) + ")"); #end
    return insertElemAt1(l, el, at);
  }
  static function insertElemAt1 <T> (l:LL<T>, el:T, at:Int):LL<T> {
    return Lazy.expr({
      if (at == 0) {
        LazyCons(el, l);
      } else {
        switch (l()) {
          case LazyNil: LazyNil;
          case LazyCons(e, tail): LazyCons(e, insertElemAt1(tail, el, at-1));
        }
      }
    });
  }
  
  public static function takeWhile <T> (l:LL<T>, f:T->Bool):LL<T> {
    return Lazy.expr({
      switch (l()) {
          case LazyNil: LazyNil;
          case LazyCons(e, tail): 
            if (f(e)) {
              LazyCons(e, takeWhile(tail, f));
            } else {
              LazyNil;
            }
        }
      });
  }
  
  public static function dropWhile <T> (l:LL<T>, f:T->Bool):LL<T> {

    return Lazy.expr({
      var res = LazyNil;
      var loop = true;
      while (loop) {
        switch (l()) {
          case LazyNil: loop = false;
          case LazyCons(e, tail): 
            if (!f(e)) {
              l = tail;
            } else {
              res = LazyCons(e, dropWhile(l, f));
              loop = false;
            }
        }
      }
      res;
      }
    );
  }
  
  /**
   * Warning: This operation has a complexity of O(n)
   */
  public static function last <T> (l:LL<T>):T {
    return switch (lastOption(l)) {
      case Some(v): v;
      case None: Scuts.error("Cannot extract last value from Empty List");
    }
  }
  
  /**
   * Warning: This operation has a complexity of O(n)
   */
  public static function lastOption <T> (l:LL<T>):Option<T> {
    var val = null;
    var isSet = false;
    var loop = true;
    while (loop) {
      switch (l()) {
        case LazyNil: loop = false;
        case LazyCons(e, tail):
          val = e;
          isSet = true;
          l = tail;
      }
    }
    return if (isSet) Some(val) else None;
  }
  
  public static function first <T> (l:LL<T>):T {
    return switch (l()) {
      case LazyNil: Scuts.error("Cannot extract first value from Empty List");
      case LazyCons(e, tail): e;
    }
  }
  
  public static function firstOption <T> (l:LL<T>):Option<T> {
    return switch (l()) {
      case LazyNil: None;
      case LazyCons(e, tail): Some(e);
    }
  }
  
  public static function zip <A,B>(a:LL<A>, b:LL<B>):LL<Tup2<A,B>>
  {
    return Lazy.expr({
      switch (a()) {
        case LazyNil: LazyNil;
        case LazyCons(e1, tail1):
          switch (b()) {
            case LazyNil: LazyNil;
            case LazyCons(e2, tail2):
              LazyCons(Tup2.create(e1,e2), zip(tail1, tail2));
          }
      }
    });
  }
  
  public static function zipWith <A,B,C>(a:LL<A>, b:LL<B>, f:A->B->C):LL<C>
  {
    return Lazy.expr({
      switch (a()) {
        case LazyNil: LazyNil;
        case LazyCons(e1, tail1):
          switch (b()) {
            case LazyNil: LazyNil;
            case LazyCons(e2, tail2):
              LazyCons(f(e1,e2), zipWith(tail1, tail2, f));
          }
      }
    });
  }
  
  public static inline function mkEmpty <T> ():LL<T> {
    return EMPTY_LIST; 
  }
  
  public static function mkOne <T>(e:T):LL<T> {
    return Lazy.expr(LazyCons(e, mkEmpty()));
  }
  
  public static function mkOneThunk <T>(e:Void->T):LL<T> {
    #if debug
    Assert.assertEquals(e(), e(), "Thunk should always return the same value");
    #end
    return Lazy.expr(LazyCons(e(), mkEmpty()));
  }
  
  public static function cons <T>(l:LL<T>, el:T):LL<T> {
    return concat(mkOne(el), l);
  }
  
  public static function consThunk <T>(l:LL<T>, el:Void->T):LL<T> {
    return concat(mkOneThunk(el), l);
  }
  
  public static function append <T>(l:LL<T>, el:T):LL<T> {
    return concat(l, mkOne(el));
  }
  
  public static function appendThunk <T>(l:LL<T>, el:Void->T):LL<T> {
    return concat(l, mkOneThunk(el));
  }
  
  public static function size <T>(l:LL<T>):Int 
  {
    var i = 0;
    var loop = true;
    while(loop) {
      switch (l()) {
        case LazyNil: loop = false;
        case LazyCons(e, tail):
          i++;
          l = tail;
      }
    }
    return i;
  }
  
  public static function map <S,T>(l:LL<T>, f:T->S):LL<S>
  {
    return Lazy.expr({
      switch (l()) {
        case LazyNil:           LazyNil;
        case LazyCons(e, tail): LazyCons(f(e), map(tail, f));
      }
    });
  }
  
  public static function concat <T>(l1:LL<T>, l2:LL<T>) {
    return Lazy.expr({
      switch (l1()) {
        case LazyNil: l2();
        case LazyCons(e, tail): LazyCons(e, concat(tail, l2));
      }
    });
  }
  
  public static function filter <T>(l:LL<T>, f:T->Bool) {
    return Lazy.expr({
      
      var ret = LazyNil;
      var loop = true;
      while (loop) {
        var c = l();
        switch (c) {
          case LazyNil: loop = false;
          case LazyCons(e, tail):
            if (f(e)) { 
              ret = LazyCons(e, filter(tail, f));
              loop = false;
            } else {
              l = tail;
            }
        }
      }
      ret;
    });
  }
  
  public static function flatMap <S, T>(l:LL<S>, f:S->LL<T>):LL<T>
  {
    return flatten(map(l,f));
  }
  
  public static function flatten <S,T>(l:LL<LL<T>>):LL<T>
  {
    return Lazy.expr({
      switch (l()) {
        case LazyNil: LazyNil;
        case LazyCons(e, tail): 
          switch (e()) {
            case LazyNil:
              LazyNil;
            case LazyCons(e2, tail2):
              LazyCons(e2, concat(tail2, flatten(tail)));
          }
      }
    });
  }
  
  public static function infinite <T>(start:T, next:T->T):LL<T>
  {
    return Lazy.expr(
      LazyCons(start, infinite(next(start), next))
    );
  }
  
  public static function infinitePlusOne (start:Int):LL<Int>
  {
    
    return Lazy.expr(
      LazyCons(start, infinitePlusOne(start + 1))
    );
  }
  
  public static function interval (from:Int, to:Int):LL<Int>
  {
    return Lazy.expr(
      if (from < to) 
        LazyCons(from, interval(from + 1, to))
      else
        LazyNil
    );
  }
  /*
  static function evens <T>(l:LL<T>):LL<T>
  {
    function evens1 (l, i) {
      return 
        switch (l()) {
          case LazyNil: LazyNil;
          case LazyCons(e, tail):
            if (i % 2 == 0) LazyCons(e, Lazy.expr(evens1(tail, i+1)));
            else evens1(tail, i+1);
        }
    }
    return Lazy.expr(evens1(l, 0));
  }
  
  static function odds <T>(l:LL<T>):LL<T>
  {
    function odds1 (l, i) {
      return 
        switch (l()) {
          case LazyNil: LazyNil;
          case LazyCons(e, tail):
            if (i % 2 == 1) LazyCons(e, Lazy.expr(odds1(tail, i+1)));
            else odds1(tail, i+1);
        }
    }
    return Lazy.expr(odds1(l, 0));
  }
  
  static function cleave <T>(l:LL<T>):Tup2<LL<T>, LL<T>>
  {
    return Tup2.create(evens(l), odds(l));
  }
  
  static function merge <T>(l1:LL<T>, l2:LL<T>, o:Ord<T>):LL<T>
  {
    /*
    P.match({
      xxs < l1 & yys < l2;
      (LazyNil & _) = y;
      (_ & LazyNil) | (x > 2) = x;
      (LazyCons(x, xs) & LazyCons(y, ys)) 
        | (ord.lessOrEq(x, y)) = Cons(x, merge(xs, yys))
        | _ = Cons(y, merge(xxs, ys));
        
      
    });
    
    P.match(
      return switch (a | b) 
      {
        case (x <= LazyNil | _)  : x;
        case (_ | y <= LazyCons) : y;
          
        case (xxs <= LazyNil(x, xs) | yys <= LazyCons(y, ys)):
          (x <= y)  = Cons(x, merge(xs, yys));
          (x > 5)   = b;
          _         = b + 2;
        default: 
          
      }
    );
    
    
    var xxs = l1;
    var yys = l2;
    switch (yys()) {
      case LazyNil: LazyNil;
        xxs;
      case LazyCons(y, ys):
        switch (xxs()) {
          case LazyNil: x:
        }
        switch (yys()) {
          case LazyNil: x;
          case LazyCons(y, ys):
            // xxs yys
            if (ord.lessOrEq(
            
            
          
          
        }
    }
   
    return null;
    
  }
  public static function mergeSort <T>(l:LazyList<T>, ord:Ord<T>):LazyList<T> {
   
    return null;
  }
  */
  
  
  
}