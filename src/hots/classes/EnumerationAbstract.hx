package hots.classes;
import scuts.core.types.LazyIterator;
import scuts.Scuts;


using scuts.core.extensions.FunctionExt;
using scuts.core.extensions.IntExt;
using scuts.core.extensions.ArrayExt;
using scuts.core.extensions.IterableExt;
using scuts.core.extensions.LazyIteratorExt;

@:tcAbstract class EnumerationAbstract<T> implements Enumeration<T>{
  
  public function toEnum (i:Int):T return Scuts.abstractMethod()
  
  public function fromEnum (i:T):Int return Scuts.abstractMethod()
  
  public function pred (a:T):T {
    return toEnum.compose(function (x) return x-1).compose(fromEnum)(a);
  }
  
  public function succ (a:T):T {
    return toEnum.compose(function (x) return x+1).compose(fromEnum)(a);
  }
  
  public function enumFrom (a:T):LazyIterator<T>
  {
    var cur = fromEnum(a);
    return cur.toLazyInfiniteIterator().map(toEnum);
  }
  
  public function enumFromTo (a:T, b:T):LazyIterator<T> {
    return fromEnum(a).toLazyIteratorTo(fromEnum(b)).map(toEnum);
  }
  
  public function enumFromThenTo (a:T, b:T, c:T):LazyIterator<T> {
    return fromEnum(b).toLazyIteratorTo(fromEnum(c)).cons(fromEnum(a)).map(toEnum);
  }
}

