package hots.classes;
import scuts.core.types.LazyList;


import scuts.Scuts;


using scuts.core.extensions.Functions;
using scuts.core.extensions.Ints;
using scuts.core.extensions.Arrays;
//using scuts.core.extensions.Iterables;
using scuts.core.extensions.LazyLists;

class EnumerationAbstract<T> {
  
  public function toEnum (i:Int):T return Scuts.abstractMethod()
  
  public function fromEnum (i:T):Int return Scuts.abstractMethod()
  
  public function pred (a:T):T {
    return toEnum.compose(function (x) return x-1).compose(fromEnum)(a);
  }
  
  public function succ (a:T):T {
    return toEnum.compose(function (x) return x+1).compose(fromEnum)(a);
  }
  
  public function enumFrom (a:T):LazyList<T>
  {
    var cur = fromEnum(a);
    return LazyLists.infinitePlusOne(cur).map(toEnum);
  }
  
  public function enumFromTo (a:T, b:T):LazyList<T> {
    return LazyLists.interval(fromEnum(a), fromEnum(b)).map(toEnum);
  }
  
  public function enumFromThenTo (a:T, b:T, c:T):LazyList<T> {
    return LazyLists.interval(fromEnum(b), fromEnum(c))
      .cons(fromEnum(a))
      .map(toEnum);
  }
}

