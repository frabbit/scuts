package hots.classes;
import hots.TC;
import scuts.core.types.LazyIterator;
import scuts.data.LazyList;




interface Enumeration<T> implements TC {
  public function pred (a:T):T;
  
  public function succ (a:T):T;
  
  public function toEnum (i:Int):T;
  public function fromEnum (i:T):Int;
  
  public function enumFrom (a:T):LazyList<T>;
  
  public function enumFromTo (a:T, b:T):LazyList<T>;
  
  public function enumFromThenTo (a:T, b:T, c:T):LazyList<T>;
}

