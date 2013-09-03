package scuts.ds;



import scuts.core.debug.Assert;
import scuts.core.Arrays;
import scuts.core.Tuples;
import scuts.core.Tuples.*;

import scuts.ht.classes.Ord;
import scuts.Scuts;
using scuts.ds.LazyLists;
using scuts.core.Iterators;
using scuts.core.Options;

abstract LazyList<T>(Void->LazyNode<T>) {

  public function new (x:Void->LazyNode<T>) {
    this = x;
  }

  public static function fromNode <T>(x:Void->LazyNode<T>):LazyList<T> {
    return new LazyList(x);
  }

  public function get <T>():LazyNode<T> {
    var x : Void->LazyNode<T> = cast this;
    return x();
  }
}

enum LazyNode<T> {
  LazyNil;
  LazyCons(e:T, tail:LazyList<T>);

}



private class LazyListIter<T> 
{
  var v:Null<T>;
  var hasNextTrue:Bool;
  var l:LazyList<T>;
  


  public function new (l:LazyList<T>) {
    this.l = l;
    v = null;
    hasNextTrue = false;
  }
  public function hasNext () 
  {
    hasNextTrue = hasNextTrue || switch (l.get()) {
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
  
  static var EMPTY_LIST = new LazyList(function () return LazyNil);



  public static function groupBy <T> (l:LazyList<T>, f:T->T->Bool):LazyList<LazyList<T>>
  {
    return asLL(function () return switch (l.get())
    {
      case LazyNil: LazyNil;
      case LazyCons(x, xs): 
        var r = span(xs, f.bind(x));
        var ys = r._1;
        var zs = r._2;
               
        LazyCons(cons(ys, x), groupBy(zs, f));
    });
  }
  
  public static function span <T> (l:LazyList<T>, f:T->Bool):Tup2<LazyList<T>, LazyList<T>>
  {
    return span1(l, mkEmpty(), f);
  } 

  static function span1 <T> (l:LazyList<T>, prefix:LazyList<T>, f:T->Bool):Tup2<LazyList<T>, LazyList<T>>
  {
    return switch (l.get()) {
      case LazyNil: tup2(prefix.reversed(), mkEmpty());
      case LazyCons(x, tail) if (f(x)): span1(tail, prefix.cons(x), f);
      case _: tup2(prefix.reversed(), l);
    }
  } 


  @:noUsing public static function replicate <X>(times:Int, v:X):LazyList<X>
  {
    var iterX = Iterators.map(0...times, function (_) return v);

    return fromIterator(iterX);
  }

  public static function catOptions <X>(a:LazyList<Option<X>>):LazyList<X>
  {
    return map(filter(a, Options.isSome), Options.extract);
  }

  static inline function asLL <T>(x:Void->LazyNode<T>):LazyList<T> 
  {
    var mem:Null<LazyNode<T>> = null;
    var f = function ():LazyNode<T> {
      if (mem == null) mem = x();
      return mem;
    }
    return LazyList.fromNode(f);
  }

  
  
  @:noUsing public static function fromArray <T> (arr:Array<T>):LazyList<T> 
  {
    var cp = arr.copy();
    return fromArrayAsView(cp, 0, cp.length);
  }
  
  public static function isEmpty <T> (l:LazyList<T>):Bool 
  {
    return switch (l.get()) { case LazyNil:true; default: false;}
  }
  
  public static function toArray <T> (l:LazyList<T>):Array<T> 
  {
    var res = [];
    var loop = true;
    while (loop) {
      var e = l.get();
      switch (e) {
        case LazyNil: loop = false;
        case LazyCons(e, tail):
          res.push(e);
          l = tail;
      }
    }
    return res;
  }
  
  @:noUsing public static inline function fromIterable <T> (it:Iterable<T>):LazyList<T> 
  {
    return fromIterator(it.iterator());
  }
  
  @:noUsing public static inline function fromIterator <T> (it:Iterator<T>):LazyList<T> 
  {
    return fromArrayAsView(it.toArray());
  }
  
  public static inline function iterator <T> (l:LazyList<T>):Iterator<T> 
  {
    return new LazyListIter(l);
  }
  
  public static function reversed <T> (l:LazyList<T>):LazyList<T> 
  {
    var a = toArray(l);
    var rev = Arrays.reversed(a);
    return fromArrayAsView(rev);
    
  }
  
  public static function foldLeft <A,B> (list:LazyList<A>, acc:B, f:B->A->B):B 
  {
    return A.foldLeft(toArray(list),acc, f);
  }
  
  public static function foldRight <A,B> (list:LazyList<A>, acc:B, f:A->B->B ):B 
  {
    return A.foldRight(toArray(list), acc, f);
  }
  
  public static function foldLeftWithIndex <A,B> (list:LazyList<A>, acc:B, f:B->A->Int->B):B 
  {
    return A.foldLeftWithIndex(toArray(list), acc, f);
  }
  
  public static function foldRightWithIndex <A,B> (list:LazyList<A>, acc:B, f:A->B->Int->B):B 
  {
    return A.foldRightWithIndex(toArray(list), acc, f);
  }
  
  public static function foldLeft1 <A,B> (list:LazyList<A>, f:A->A->A):A 
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
  
  public static function toString <T> (list:LazyList<T>, ?s:T->String):String 
  {
    var str = s == null ? Std.string : s;
    function f (acc, el, i) return acc + ((i>0) ? ", " : "") + str(el);
    
    return "LazyList[" + foldLeftWithIndex(list, "", f) + "]";
  }
  
  @:noUsing public static function fromArrayAsView <T> (arr:Array<T>, index:Int = 0, to:Int = -1):LazyList<T> 
  {
    var to1 = (to == -1) ? arr.length : to;
    Assert.isTrue(to1 <= arr.length);
    
    return asLL(function () return 
    ({
      Assert.isTrue(to1 <= arr.length);
      
        if (index < to1) LazyCons(arr[index], fromArrayAsView(arr, index+1, to1));
        else             LazyNil;
      
    }));
  }
  
  public static function take <T> (l:LazyList<T>, num:Int):LazyList<T> 
  {
    Assert.isTrue(num >= 0);
    
    return asLL(function () return 
    ({
      if (num-1 < 0) LazyNil;
      else switch (l.get()) 
      {
        case LazyNil: LazyNil;
        case LazyCons(e, tail): LazyCons(e, take(tail, num-1));
      }
    }));
  }
  
  public static function drop <T> (l:LazyList<T>, num:Int):LazyList<T> 
  {
    return asLL(function () return 
    ({
      var res = l.get();
      while (--num >= 0) switch (res) 
      {
        case LazyNil:           break;
        case LazyCons(_, tail): res = tail.get();
      }
      res;
    }));
  }
  
  public static function insertElemAt <T> (l:LazyList<T>, el:T, at:Int):LazyList<T> 
  {
    #if debug Assert.isTrue(size(l) >= at, "Position " + at + " must be between 0 and list size (" + size(l) + ")"); #end
    return insertElemAt1(l, el, at);
  }
  
  static function insertElemAt1 <T> (l:LazyList<T>, el:T, at:Int):LazyList<T> 
  {
    return asLL(function () return 
    ({
      if (at == 0) LazyCons(el, l);
      else switch (l.get()) 
      {
        case LazyNil: LazyNil;
        case LazyCons(e, tail): LazyCons(e, insertElemAt1(tail, el, at-1));
      }
    }));
  }
  
  public static function takeWhile <T> (l:LazyList<T>, f:T->Bool):LazyList<T> 
  {
    return asLL(function () return ( switch (l.get()) 
    {
      case LazyNil: LazyNil;
      case LazyCons(e, tail): 
        if (f(e)) {
          LazyCons(e, takeWhile(tail, f));
        } else {
          LazyNil;
        }
    }));
  }
  
  public static function dropWhile <T> (l:LazyList<T>, f:T->Bool):LazyList<T> 
  {
    return asLL(function () return 
    ({
      var res = LazyNil;
      var loop = true;
      while (loop) switch (l.get()) 
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
    ));
  }
  
  /**
   * Warning: This operation has a complexity of O(n)
   */
  public static function last <T> (l:LazyList<T>):T return switch (lastOption(l)) 
  {
    case Some(v): v;
    case None: Scuts.error("Cannot extract last value from Empty List");
  }
  
  /**
   * Warning: This operation has a complexity of O(n)
   */
  public static function lastOption <T> (l:LazyList<T>):Option<T> 
  {
    
    var val = null;
    
    var isSet = false;
    var loop = true;
    
    while (loop) switch (l.get()) 
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
  
  public static function first <T> (l:LazyList<T>):T return switch (l.get()) 
  {
    case LazyNil: Scuts.error("Cannot extract first value from Empty List");
    case LazyCons(e, _): e;
  }
  
  public static function firstOption <T> (l:LazyList<T>):Option<T> return switch (l.get()) 
  {
    case LazyNil: None;
    case LazyCons(e, _): Some(e);
  }
  
  public static function zip <A,B>(a:LazyList<A>, b:LazyList<B>):LazyList<Tup2<A,B>>
  {
    return asLL(function () return (switch (a.get()) 
    {
      case LazyNil: LazyNil;
      case LazyCons(e1, tail1): switch (b.get()) 
      {
        case LazyNil:             LazyNil;
        case LazyCons(e2, tail2): LazyCons(Tup2.create(e1,e2), zip(tail1, tail2));
      }
    }));
  }
  
  public static function zipWith <A,B,C>(a:LazyList<A>, b:LazyList<B>, f:A->B->C):LazyList<C>
  {
    return asLL(function () return (switch (a.get()) 
    {
      case LazyNil: LazyNil;
      case LazyCons(e1, tail1): switch (b.get()) 
      {
        case LazyNil:             LazyNil;
        case LazyCons(e2, tail2): LazyCons(f(e1,e2), zipWith(tail1, tail2, f));
      }
    }));
  }
  
  @:noUsing public static inline function mkEmpty <T> ():LazyList<T> 
  {
    return EMPTY_LIST; 
  }
  
  @:noUsing public static function mkOne <T>(e:T):LazyList<T> 
  {
    return asLL(function () return (LazyCons(e, mkEmpty())));
  }
  
  @:noUsing public static function mkOneThunk <T>(e:Void->T):LazyList<T> 
  {
    return asLL(function () return (LazyCons(e(), mkEmpty())));
  }
  
  public static inline function cons <T>(l:LazyList<T>, el:T):LazyList<T> 
  {
    return concat(mkOne(el), l);
  }
  
  public static function consThunk <T>(l:LazyList<T>, el:Void->T):LazyList<T> 
  {
    return concat(mkOneThunk(el), l);
  }
  
  public static inline function append <T>(a:LazyList<T>, b:LazyList<T>):LazyList<T> 
  {
    return concat(a, b);
  }
  
  public static inline function appendElem <T>(l:LazyList<T>, el:T):LazyList<T> 
  {
    return concat(l, mkOne(el));
  }
  
  public static function appendThunk <T>(l:LazyList<T>, el:Void->T):LazyList<T> 
  {
    return concat(l, mkOneThunk(el));
  }
  
  public static function size <T>(l:LazyList<T>):Int 
  {
    var i = 0;
    var loop = true;
    while (loop) switch (l.get()) 
    {
      case LazyNil: loop = false;
      case LazyCons(_, tail):
        i++;
        l = tail;
    }
    return i;
  }
  
  public static function tail <T>(l:LazyList<T>):LazyList<T>
  {
    return asLL(function () return switch (l.get()) 
    {
      case LazyNil:           LazyNil;
      case LazyCons(_, tail): tail.get();
    });
  }

  public static function map <S,T>(l:LazyList<T>, f:T->S):LazyList<S>
  {
    return asLL(function () return (switch (l.get()) 
    {
      case LazyNil:           LazyNil;
      case LazyCons(e, tail): LazyCons(f(e), map(tail, f));
    }));
  }
  
  public static function concat <T>(l1:LazyList<T>, l2:LazyList<T>):LazyList<T> 
  {
    return asLL(function () return (switch (l1.get()) 
    {
      case LazyNil: l2.get();
      case LazyCons(e, tail): LazyCons(e, concat(tail, l2));
    }));
  }
  
  public static function filter <T>(l:LazyList<T>, f:T->Bool) 
  {
    return asLL(function () return 
    ({
      var ret = LazyNil;
      var loop = true;
      while (loop) switch (l.get()) 
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
    }));
  }
  
  public static inline function flatMap <S, T>(l:LazyList<S>, f:S->LazyList<T>):LazyList<T>
  {
    return flatten(map(l,f));
  }
  
  public static function flatten <T>(l:LazyList<LazyList<T>>):LazyList<T>
  {
    
    return asLL(function () {
      var l1 : LazyNode<LazyList<T>> = l.get();
      return switch (l1) 
      {
        case LazyNil: LazyNil;
        case LazyCons(e, tail): switch (e.get()) 
        {
          case LazyNil:             flatten(tail).get();
          case LazyCons(e2, tail2): LazyCons(e2, concat(tail2, flatten(tail)));
        }
      };
    });
  }
  
  @:noUsing public static function infinite <T>(start:T, next:T->T):LazyList<T>
  {
    return asLL(function () return 
    (
      LazyCons(start, infinite(next(start), next))
    ));
  }
  
  @:noUsing public static function infinitePlusOne (start:Int):LazyList<Int>
  {
    return asLL(function () return 
    (
      LazyCons(start, infinitePlusOne(start + 1))
    ));
  }
  
  @:noUsing public static function interval (from:Int, to:Int):LazyList<Int>
  {
    return asLL(function () return 
    (
      if (from < to) LazyCons(from, interval(from + 1, to))
      else           LazyNil
    ));
  }

  public static function quicksort <T>(l:LazyList<T>, ord:Ord<T>):LazyList<T>
  {
    return asLL(function () return switch (l.get()) 
    {
      case LazyNil: LazyNil;
      case LazyCons(x, xs): 

        var smaller = filter(xs, ord.lessOrEq.bind(_,x));
        var larger = filter(xs, ord.greater.bind(_,x));
        
        var sorted = quicksort(smaller,ord).concat(mkOne(x)).concat(quicksort(larger,ord));

        return LazyCons(first(sorted), tail(sorted));


      

    });
  }

}

