package scuts.core;

import scuts.core.debug.Assert;
import scuts.core.Arrays;
import scuts.core.Option;
import scuts.core.Tup2;
import scuts.core.macros.Lazy;
//import scuts.macros.P;
import scuts.Scuts;
import scuts.core.LazyList;
using scuts.core.Iterators;
using scuts.core.Options;

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
  
  @:noUsing public static function fromArray <T> (arr:Array<T>):LL<T> 
  {
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
  
  @:noUsing public static inline function fromIterable <T> (it:Iterable<T>):LL<T> 
  {
    return fromIterator(it.iterator());
  }
  
  @:noUsing public static inline function fromIterator <T> (it:Iterator<T>):LL<T> 
  {
    return fromArrayAsView(it.toArray());
  }
  
  public static inline function iterator <T> (l:LL<T>):Iterator<T> 
  {
    return new LazyListIter(l);
  }
  
  public static function reversed <T> (l:LL<T>):LL<T> 
  {
    var a = toArray(l);
    var rev = Arrays.reversed(a);
    return fromArrayAsView(rev);
    
  }
  
  public static function foldLeft <A,B> (list:LL<A>, acc:B, f:B->A->B):B 
  {
    return A.foldLeft(toArray(list),acc, f);
  }
  
  public static function foldRight <A,B> (list:LL<A>, acc:B, f:A->B->B ):B 
  {
    return A.foldRight(toArray(list), acc, f);
  }
  
  public static function foldLeftWithIndex <A,B> (list:LL<A>, acc:B, f:B->A->Int->B):B 
  {
    return A.foldLeftWithIndex(toArray(list), acc, f);
  }
  
  public static function foldRightWithIndex <A,B> (list:LL<A>, acc:B, f:A->B->Int->B):B 
  {
    return A.foldRightWithIndex(toArray(list), acc, f);
  }
  
  public static function foldLeft1 <A,B> (list:LL<A>, f:A->A->A):A 
  {
    var a = toArray(list);
    Assert.isTrue(a.length > 0);
    var init = a[0];
    
    for (i in 1...a.length) 
    {
      init = f(init, a[i]);
    }
    return init;
  }
  
  public static function toString <T> (list:LL<T>, ?s:T->String):String 
  {
    var str = s == null ? Std.string : s;
    function f (acc, el, i) return acc + ((i>0) ? ", " : "") + str(el);
    
    return "LazyList[" + foldLeftWithIndex(list, "", f) + "]";
  }
  
  @:noUsing public static function fromArrayAsView <T> (arr:Array<T>, index:Int = 0, to:Int = -1):LL<T> 
  {
    var to1 = (to == -1) ? arr.length : to;
    Assert.isTrue(to1 <= arr.length);
    
    return Lazy.expr
    ({
      Assert.isTrue(to1 <= arr.length);
      
      if (index < to1) LazyCons(arr[index], fromArrayAsView(arr, index+1, to1));
      else             LazyNil;
    });
  }
  
  public static function take <T> (l:LL<T>, num:Int):LL<T> 
  {
    Assert.isTrue(num >= 0);
    
    return Lazy.expr
    ({
      if (num-1 < 0) LazyNil;
      else switch (l()) 
      {
        case LazyNil: LazyNil;
        case LazyCons(e, tail): LazyCons(e, take(tail, num-1));
      }
    });
  }
  
  public static function drop <T> (l:LL<T>, num:Int):LL<T> 
  {
    return Lazy.expr
    ({
      var res = l();
      while (--num >= 0) switch (res) 
      {
        case LazyNil:           break;
        case LazyCons(e, tail): res = tail();
      }
      res;
    });
  }
  
  public static function insertElemAt <T> (l:LL<T>, el:T, at:Int):LL<T> 
  {
    #if debug Assert.isTrue(size(l) >= at, "Position " + at + " must be between 0 and list size (" + size(l) + ")"); #end
    return insertElemAt1(l, el, at);
  }
  
  static function insertElemAt1 <T> (l:LL<T>, el:T, at:Int):LL<T> 
  {
    return Lazy.expr
    ({
      if (at == 0) LazyCons(el, l);
      else switch (l()) 
      {
        case LazyNil: LazyNil;
        case LazyCons(e, tail): LazyCons(e, insertElemAt1(tail, el, at-1));
      }
    });
  }
  
  public static function takeWhile <T> (l:LL<T>, f:T->Bool):LL<T> 
  {
    return Lazy.expr( switch (l()) 
    {
      case LazyNil: LazyNil;
      case LazyCons(e, tail): 
        if (f(e)) {
          LazyCons(e, takeWhile(tail, f));
        } else {
          LazyNil;
        }
    });
  }
  
  public static function dropWhile <T> (l:LL<T>, f:T->Bool):LL<T> 
  {
    return Lazy.expr
    ({
      var res = LazyNil;
      var loop = true;
      while (loop) switch (l()) 
      {
        case LazyNil: loop = false;
        case LazyCons(e, tail): 
          if (!f(e))
            l = tail;
          else
          {
            res = LazyCons(e, dropWhile(l, f));
            loop = false;
          }
      }
      res;
      }
    );
  }
  
  /**
   * Warning: This operation has a complexity of O(n)
   */
  public static function last <T> (l:LL<T>):T return switch (lastOption(l)) 
  {
    case Some(v): v;
    case None: Scuts.error("Cannot extract last value from Empty List");
  }
  
  /**
   * Warning: This operation has a complexity of O(n)
   */
  public static function lastOption <T> (l:LL<T>):Option<T> 
  {
    var val = null;
    var isSet = false;
    var loop = true;
    while (loop) switch (l()) 
    {
      case LazyNil: 
        loop = false;
      case LazyCons(e, tail):
        val = e;
        isSet = true;
        l = tail;
    }
    return if (isSet) Some(val) else None;
  }
  
  public static function first <T> (l:LL<T>):T return switch (l()) 
  {
    case LazyNil: Scuts.error("Cannot extract first value from Empty List");
    case LazyCons(e, tail): e;
  }
  
  public static function firstOption <T> (l:LL<T>):Option<T> return switch (l()) 
  {
    case LazyNil: None;
    case LazyCons(e, tail): Some(e);
  }
  
  public static function zip <A,B>(a:LL<A>, b:LL<B>):LL<Tup2<A,B>>
  {
    return Lazy.expr(switch (a()) 
    {
      case LazyNil: LazyNil;
      case LazyCons(e1, tail1): switch (b()) 
      {
        case LazyNil:             LazyNil;
        case LazyCons(e2, tail2): LazyCons(Tup2.create(e1,e2), zip(tail1, tail2));
      }
    });
  }
  
  public static function zipWith <A,B,C>(a:LL<A>, b:LL<B>, f:A->B->C):LL<C>
  {
    return Lazy.expr(switch (a()) 
    {
      case LazyNil: LazyNil;
      case LazyCons(e1, tail1): switch (b()) 
      {
        case LazyNil:             LazyNil;
        case LazyCons(e2, tail2): LazyCons(f(e1,e2), zipWith(tail1, tail2, f));
      }
    });
  }
  
  @:noUsing public static inline function mkEmpty <T> ():LL<T> 
  {
    return EMPTY_LIST; 
  }
  
  @:noUsing public static function mkOne <T>(e:T):LL<T> 
  {
    return Lazy.expr(LazyCons(e, mkEmpty()));
  }
  
  @:noUsing public static function mkOneThunk <T>(e:Void->T):LL<T> 
  {
    return Lazy.expr(LazyCons(e(), mkEmpty()));
  }
  
  public static function cons <T>(l:LL<T>, el:T):LL<T> 
  {
    return concat(mkOne(el), l);
  }
  
  public static function consThunk <T>(l:LL<T>, el:Void->T):LL<T> 
  {
    return concat(mkOneThunk(el), l);
  }
  
  public static function append <T>(a:LL<T>, b:LL<T>):LL<T> 
  {
    return concat(a, b);
  }
  
  public static function appendElem <T>(l:LL<T>, el:T):LL<T> 
  {
    return concat(l, mkOne(el));
  }
  
  public static function appendThunk <T>(l:LL<T>, el:Void->T):LL<T> 
  {
    return concat(l, mkOneThunk(el));
  }
  
  public static function size <T>(l:LL<T>):Int 
  {
    var i = 0;
    var loop = true;
    while (loop) switch (l()) 
    {
      case LazyNil: loop = false;
      case LazyCons(e, tail):
        i++;
        l = tail;
    }
    return i;
  }
  
  public static function map <S,T>(l:LL<T>, f:T->S):LL<S>
  {
    return Lazy.expr(switch (l()) 
    {
      case LazyNil:           LazyNil;
      case LazyCons(e, tail): LazyCons(f(e), map(tail, f));
    });
  }
  
  public static function concat <T>(l1:LL<T>, l2:LL<T>):LL<T> 
  {
    return Lazy.expr(switch (l1()) 
    {
      case LazyNil: l2();
      case LazyCons(e, tail): LazyCons(e, concat(tail, l2));
    });
  }
  
  public static function filter <T>(l:LL<T>, f:T->Bool) 
  {
    return Lazy.expr
    ({
      var ret = LazyNil;
      var loop = true;
      while (loop) switch (l()) 
      {
        case LazyNil: loop = false;
        case LazyCons(e, tail):
          if (f(e)) 
          { 
            ret = LazyCons(e, filter(tail, f));
            loop = false;
          }
          else l = tail;
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
    return Lazy.expr(switch (l()) 
    {
      case LazyNil: LazyNil;
      case LazyCons(e, tail): switch (e()) 
      {
        case LazyNil:             flatten(tail)();
        case LazyCons(e2, tail2): LazyCons(e2, concat(tail2, flatten(tail)));
      }
    });
  }
  
  @:noUsing public static function infinite <T>(start:T, next:T->T):LL<T>
  {
    return Lazy.expr
    (
      LazyCons(start, infinite(next(start), next))
    );
  }
  
  @:noUsing public static function infinitePlusOne (start:Int):LL<Int>
  {
    return Lazy.expr
    (
      LazyCons(start, infinitePlusOne(start + 1))
    );
  }
  
  @:noUsing public static function interval (from:Int, to:Int):LL<Int>
  {
    return Lazy.expr
    (
      if (from < to) LazyCons(from, interval(from + 1, to))
      else           LazyNil
    );
  }

}