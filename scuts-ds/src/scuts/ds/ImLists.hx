package scuts.ds;



import scuts.core.debug.Assert;
import scuts.core.Tuples;
import scuts.core.Tuples.*;
import scuts.ht.classes.Eq;
import scuts.ht.classes.Ord;
import scuts.Scuts;


using scuts.core.Iterators;
using scuts.core.Options;


using scuts.ds.ImLists;

enum ImList<T> {
  Nil;
  Cons(e:T, tail:ImList<T>);
}

private typedef List<T> = scuts.ds.ImList<T>;
private typedef L = ImLists;

private class ListIter<T> 
{
  var l:List<T>;
  
  public function new (l:List<T>) 
  {
    this.l = l;
  }
  
  public inline function hasNext () return !L.isEmpty(l);

  public function next () {
    return if (!L.isEmpty(l)) 
    { 
      var v = L.first(l);
      l = L.tail(l);
      v;
    } 
    else Scuts.error("Iterator has no value left");
  }
}

class ImLists 
{

  public static function eq <T>(x1:List<T>, x2:List<T>, eqTc:Eq<T>)
  {
    return switch [x1,x2] {
      case [Nil, Nil]: true;
      case [Cons(a1, t1), Cons(a2,t2)]: eqTc.eq(a1,a2) && eq(t1, t2, eqTc);
      case _ : false;
    }
  }

  public static function groupBy <T> (l:List<T>, f:T->T->Bool):List<List<T>>
  {
    return switch (l) 
    {
      case Nil: Nil;
      case Cons(x, xs): 
        var r = span(xs, f.bind(x));
        var ys = r._1;
        var zs = r._2;
        Cons(Cons(x, ys), groupBy(zs, f));
    }
  } 
  
  public static function span <T> (l:List<T>, f:T->Bool):Tup2<List<T>, List<T>>
  {
    return span1(l, Nil, f);
  } 

  static function span1 <T> (l:List<T>, prefix:List<T>, f:T->Bool):Tup2<List<T>, List<T>>
  {
    return switch (l) {
      case Nil: tup2(prefix.reverse(), Nil);
      case Cons(x, tail) if (f(x)): span1(tail, prefix.cons(x), f);
      case tail: tup2(prefix.reverse(), tail);
    }
  } 



  public static function each <T> (l:List<T>, f:T->Void) 
  {
    while (true) {
      switch (l) {
        case Cons(e, tail):
          l = tail;
          f(e);
        case Nil: break;
      }
    }
  }
  
  @:noUsing public static function fromArray <T> (arr:Array<T>):List<T> 
  {
    var len = arr.length;
    var l = Nil;
    while (--len > -1) {
      l = Cons(arr[len], l);
    }
    return l;
  }
  
  @:noUsing public static function fromArrayWithBounds <T> (arr:Array<T>, index:Int = 0, to:Int = -1):List<T> 
  {
    to = (to == -1) ? arr.length : to;
    #if debug
    Assert.intInRange(to, 0, arr.length);
    Assert.isTrue(index >= 0 && index <= to);
    #end
    var cur = Nil;
    for (i in index...to) {
      var index = (to-1) - (i - index);
      cur = Cons(arr[index], cur);
    }
    return cur;
  }
  
  @:noUsing public static inline function fromIterable <T> (it:Iterable<T>):List<T> 
  {
    return fromIterator(it.iterator());
  }
  
  @:noUsing public static inline function fromIterator <T> (it:Iterator<T>):List<T> 
  {
    return fromArrayWithBounds(it.toArray());
  }
  
  @:generic @:noUsing public static inline function mkEmpty <T> ():List<T> {
    return Nil;
  }
  
  @:noUsing public static inline function mkOne <T>(e:T):List<T> 
  {
    return Cons(e, mkEmpty());
  }
  
  public static inline function isEmpty <T> (l:List<T>):Bool 
  {
    return switch (l) { case Nil:true; case Cons(_): false;}
  }
  
  public static function toArray <T> (l:List<T>):Array<T> 
  {
    var res = [];
    var loop = true;
    while (loop) {
      switch (l) {
        case Nil: loop = false;
        case Cons(e, tail):
          res.push(e);
          l = tail;
      }
    }
    return res;
  }
  
  
  
  public static inline function iterator <T> (l:List<T>):Iterator<T> 
  {
    return new ListIter(l);
  }
  
  public static function foldLeft <A,B> (list:List<A>, init:B, f:B->A->B):B 
  {
    while (!isEmpty(list)) 
    {
      init = f(init, first(list));
      list = tail(list);
    }
    return init;
  }
  
  public static function foldRight <A,B> (list:List<A>, init:B, f:A->B->B):B 
  {
    var a = toArray(list);
    var i = a.length;
    while (--i > -1) {
      init = f(a[i], init);
    }
    return init;
  }
  
  public static function foldLeftWithIndex <A,B> (list:List<B>, init:A, f:A->B->Int->A):A 
  {
    var i = 0;
    
    while (!isEmpty(list)) 
    {
      init = f(init, first(list), i);
      list = tail(list);
      i++;
    }
    return init;
  }
  
  
  
  public static function foldLeft1 <A,B> (list:List<A>, f:A->A->A):A 
  {
    var a = toArray(list);
    #if debug
    Assert.isTrue(a.length > 0);
    #end
    var init = a[0];
    for (i in 1...a.length) {
      init = f(init, a[i]);
    }
    return init;
  }
  
  public static function toString <T> (list:List<T>, show:T->String):String 
  {
    return "ImList["
      + foldLeftWithIndex(list, "", function (acc, el, i) return acc + ((i>0) ? ", " : "") + show(el)) 
      + "]";
  }
  
  public static function take <T> (l:List<T>, num:Int):List<T> 
  {
    #if debug
    Assert.isTrue(num >= 0);
    #end
    
    var loop = true;
    var stack = mkEmpty();
    while (loop && num-- >= 0) {
      switch (l) {
        case Nil: loop = false;
        case Cons(e,_): stack = cons(stack, e);
      }
    }
    
    var res = Nil;
    while (!isEmpty(stack)) {
      res = cons(res, first(stack));
      stack = tail(stack);
    }
    return res;
  }
  
  public static function drop <T> (l:List<T>, num:Int):List<T> 
  {
    #if debug 
    Assert.isTrue(num >= 0);
    #end
    var res = l;
    var loop = true;
    while (loop && num-- >= 0) {
      switch (l) {
        case Nil: loop = false;
        case Cons(_,tail): l = tail;
      }
    }
    return res;
  }
  
  public static function insertElemAt <T> (l:List<T>, el:T, at:Int):List<T> 
  {
    #if debug 
    var size = size(l);
    Assert.isTrue( size >= at, "Position " + at + " must be between 0 and list size (" + size + ")"); 
    #end
    var res = l;

    var stack = mkEmpty();
    
    var loop = true;
    while (loop && at-- >= 0) {
      switch (res) {
        case Nil: loop = false;
        case Cons(e,tail): 
          stack = cons(stack, e);
          res = tail;
      }
    }
    res = cons(res, el);
    while (!isEmpty(stack)) {
      res = cons(res, first(stack));
      stack = tail(stack);
    }
    return res;
  }
  
  
  public static function takeWhile <T> (l:List<T>, f:T->Bool):List<T> 
  {
    var loop = true;
    var stack = mkEmpty();
    while (loop) {
      switch (l) {
        case Nil: loop = false;
        case Cons(e,_): 
         if (!f(e)) {
           loop = false;
         } else {
           stack = cons(stack, e);
         }
      }
    }
    
    return reverse(stack);
    
  }
  
  public static function dropWhile <T> (l:List<T>, f:T->Bool):List<T> 
  {
    var res = l;
    var loop = true;
    while (loop) {
      switch (res) {
        case Nil: loop = false;
        case Cons(e, tail): 
          if (!f(e)) {
            loop = false;
          } else {
            res = tail;
          }
      }
    }
    return res;
  }
  
  /**
   * Warning: This operation has a complexity of O(n)
   */
  public static function last <T> (l:List<T>):T 
  {
    return switch (lastOption(l)) {
      case Some(v): v;
      case None: Scuts.error("Cannot extract last value from Empty List");
    }
  }
  
  /**
   * Warning: This operation has a complexity of O(n)
   */
  public static function lastOption <T> (l:List<T>):Option<T> 
  {
    var val = null;
    var isSet = false;
    var loop = true;
    while (loop) {
      switch (l) {
        case Nil: loop = false;
        case Cons(e, tail):
          val = e;
          isSet = true;
          l = tail;
      }
    }
    return if (isSet) Some(val) else None;
  }
  
  public static function first <T> (l:List<T>):T {
    return switch (l) {
      case Nil: Scuts.error("Cannot extract first value from Empty List");
      case Cons(e, _): e;
    }
  }
  
  public static function tail <T> (l:List<T>):List<T> {
    return switch (l) {
      case Nil: Scuts.error("Empty list has no tail");
      case Cons(_, tail): tail;
    }
  }
  
  public static function firstOption <T> (l:List<T>):Option<T> {
    return switch (l) {
      case Nil: None;
      case Cons(e, _): Some(e);
    }
  }
  
  public static function reverse <T>(l:List<T>):List<T>{
    var rev = mkEmpty();
    while (true) {
      
      switch (l) {
        case Nil: break;
        case Cons(el, tail):
          rev = cons(rev, el);
          l = tail;
      }
    }
    return rev;
  }
  
  
  
  public static function zip <A,B>(a:List<A>, b:List<B>):List<Tup2<A,B>>
  {
    var stack = mkEmpty();
    while (!isEmpty(a) && !isEmpty(b)) {
      stack = cons(stack, Tup2.create(first(a), first(b)));
      a = tail(a);
      b = tail(b);
    }
    return reverse(stack);
  }
  
  public static function zipWith <A,B,C>(a:List<A>, b:List<B>, f:A->B->C):List<C>
  {
    
    var stack = mkEmpty();
    
    while (!isEmpty(a) && !isEmpty(b)) {
      stack = cons(stack, f(first(a), first(b)));
      a = tail(a);
      b = tail(b);
    }
    return reverse(stack);
  }
  
  
  
  
  
  public static inline function cons <T>(l:List<T>, el:T):List<T> 
  {
    return Cons(el, l);
  }
  
  
  public static function append <T>(l:List<T>, el:T):List<T> 
  {
    return concat(l, mkOne(el));
  }
  
  
  public static function size <T>(l:List<T>):Int 
  {
    var i = 0;
    while (!isEmpty(l)) 
    {
      l = tail(l);
      ++i;
    }
    return i;
    
  }
  
  public static function map <S,T>(l:List<T>, f:T->S):List<S>
  {
    var stack = mkEmpty();
    while (!isEmpty(l)) {
      stack = cons(stack, f(first(l)));
      l = tail(l);
    }
    return reverse(stack);
  }
  
  public static function concat <T>(l1:List<T>, l2:List<T>):List<T> 
  {
    var stack = reverse(l1);
    
    while (!isEmpty(stack)) {
      l2 = cons(l2, first(stack));
      stack = tail(stack);
    }
    return l2;
  }


  public static function concatReversed <T>(l1:List<T>, l2:List<T>):List<T> 
  {
    while (!isEmpty(l1)) {
      l2 = cons(l2, first(l1));
      l1 = tail(l1);
    }
    return l2;
  }


  public static function quicksort <T>(l:List<T>, ord:Ord<T>):List<T>
  {
    return switch (l) 
    {
      case Nil: Nil;
      case Cons(x, xs): 

        var smaller = filter(xs, ord.lessOrEq.bind(_,x));
        var larger = filter(xs, ord.greater.bind(_,x));
        
        quicksort(smaller,ord).concat(mkOne(x)).concat(quicksort(larger,ord));
      

    }
  }
  
  public static function filter <T>(l:List<T>, f:T->Bool):List<T> 
  {
    var stack = mkEmpty();
    while (!isEmpty(l)) {
      var el = first(l);
      if (f(el)) {
        stack = cons(stack, el);
      }
      l = tail(l);
    }
    return reverse(stack);
  }
  
  

  public static function flatMap <S, T>(l:List<S>, f:S->List<T>):List<T>
  {
    return flatten(map(l,f));
  }
  
  public static function flatten <S,T>(l:List<List<T>>):List<T>
  {
    var stack = mkEmpty();
    while (!isEmpty(l)) 
    {
      var l1 = first(l);
      while (!isEmpty(l1)) {
        var e = first(l1);
        stack = cons(stack, e);
        l1 = tail(l1);
      }
      l = tail(l);
    }
    return reverse(stack);
  }
}