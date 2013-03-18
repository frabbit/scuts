package scuts.ds;

using scuts.ds.LazyLists;

using scuts.ds.LazyStacks;

abstract LazyStack<T>(LazyList<T>) 
{
  public function new (x) this = x;
  public static inline function fromLazyList <T>(l:LazyList<T>):LazyStack<T> return new LazyStack(l);
  
  public inline function toLazyList <T>():LazyList<T> return this;

}

class LazyStacks 
{
  
  
  static inline function unbox <T>(l:LazyStack<T>):LazyList<T> return l.toLazyList();
  
  static inline function box <T>(l:LazyList<T>):LazyStack<T> return LazyStack.fromLazyList(l);
  
  public static function mkEmpty <T>():LazyStack<T> return LazyLists.mkEmpty().box();
  
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