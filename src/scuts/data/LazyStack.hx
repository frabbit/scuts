package scuts.data;
import scuts.data.LazyList;
using scuts.data.LazyList.LazyListExt;

typedef LazyStack<T> = { ___internal__newtype__scuts_data_LazyStack__:T}

class Box {
  public static inline function box <T>(l:LazyList<T>):LazyStack<T> {
    return cast l;
  }
  public static inline function unbox <T>(s:LazyStack<T>):LazyList<T> {
    return cast s;
  }
}

using scuts.data.LazyStack.Box;

class LazyStackExt 
{
  public static function mkEmpty <T>():LazyStack<T> {
    return LazyListExt.mkEmpty().box();
  }
  
  public static function push <T>(l:LazyStack<T>, el:T):LazyStack<T> {
    return l.unbox().pushElem(el).box();
  }
  
  public static function pop <T>(l:LazyStack<T>):LazyStack<T> {
    return l.unbox().drop(1).box();
  }
  
  public static function isEmpty <T>(l:LazyStack<T>):LazyStack<T> {
    return l.unbox().isEmpty();
  }
  
  
}