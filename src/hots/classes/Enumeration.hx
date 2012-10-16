package hots.classes;


import scuts.core.LazyList;




interface Enumeration<T>
{
  public function pred (a:T):T;
  
  public function succ (a:T):T;
  
  public function toEnum (i:Int):T;
  public function fromEnum (i:T):Int;
  
  public function enumFrom (a:T):LazyList<T>;
  
  public function enumFromTo (a:T, b:T):LazyList<T>;
  
  public function enumFromThenTo (a:T, b:T, c:T):LazyList<T>;
}

