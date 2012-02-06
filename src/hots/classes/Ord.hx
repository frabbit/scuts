package hots.classes;


import scuts.core.types.Ordering;


interface Ord<T> implements Eq<T> {
  
  public function compare (a:T, b:T):Ordering;
  
  public function compareInt (a:T, b:T):Int;
  
  public function less (a:T, b:T):Bool;
  
  public function lessOrEq (a:T, b:T):Bool;
  
  public function greaterOrEq (a:T, b:T):Bool;
  
  public function greater (a:T, b:T):Bool;
  
  public function min (a:T, b:T):T;
  
  public function max (a:T, b:T):T;
  
  
}

