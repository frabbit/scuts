package hots.classes;
import hots.TC;
import scuts.core.types.LazyIterator;

import scuts.core.extensions.Function1Ext;
using scuts.core.extensions.Function1Ext;


interface Enumeration<T>, implements TC {
  public function pred (a:T):T;
  
  public function succ (a:T):T;
  
  public function toEnum (i:Int):T;
  public function fromEnum (i:T):Int;
  
  public function enumFrom (a:T):LazyIterator<T>;
  
  public function enumFromTo (a:T, b:T):LazyIterator<T>;
  
  public function enumFromThenTo (a:T, b:T, c:T):LazyIterator<T>;
}

