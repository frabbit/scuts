package scuts.data;
import scuts.data.LazyList;
using scuts.data.LazyLists;

using scuts.data.LazyStacks;

class LazyStacks 
{
  static inline function box <T>(l:LazyList<T>):LazyStack<T> return cast l
  
  static inline function unbox <T>(s:LazyStack<T>):LazyList<T> return cast s
  
  public static inline function toLazyList <T>(l:LazyStack<T>):LazyList<T> return unbox(l)
  
  public static inline function fromLazyList <T>(l:LazyList<T>):LazyStack<T> return box(l)
  
  public static function mkEmpty <T>():LazyStack<T> return LazyLists.mkEmpty().box()
  
  public static function push <T>(l:LazyStack<T>, el:T):LazyStack<T> 
  {
    return l.unbox().cons(el).box();
  }
  
  public static function pop <T>(l:LazyStack<T>):LazyStack<T> 
  {
    return l.unbox().drop(1).box();
  }
  
  public static function isEmpty <T>(l:LazyStack<T>):Bool 
  {
    return l.unbox().isEmpty();
  }
  
  
}