package hots.classes;


import scuts.core.types.Ordering;

@:tcAbstract class OrdAbstract<T> implements Ord<T> {
  
  var e:Eq<T>;
  
  public function new (e:Eq<T>) {
    this.e = e;
  }
  
  public function compare (a:T, b:T):Ordering 
  {
    return if      (e.eq(a, b))       Ordering.EQ
           else if (lessOrEq(a, b))   Ordering.LT
           else                       Ordering.GT;
  }
  
  public function compareInt (a:T, b:T):Int 
  {
    return if      (e.eq(a, b))  0
           else if (lessOrEq(a, b))   -1
           else                       1;
  }
  
  public function less (a:T, b:T):Bool 
  {
    return compare(a, b) == LT;
  }
  
  public function lessOrEq (a:T, b:T):Bool 
  {
    return compare(a, b) != GT;
  }
  
  public function greaterOrEq (a:T, b:T):Bool 
  {
    return compare(a, b) != LT;
  }
  
  public function greater (a:T, b:T):Bool 
  {
    return compare(a, b) == GT;
  }
  
  public function min (a:T, b:T):T 
  {
    return lessOrEq(a, b) ? a : b;
  }
  
  public function max (a:T, b:T):T 
  {
    return greaterOrEq(a, b) ? a : b;
  }
  
  // delegation of Eq
  
  public inline function eq (a:T, b:T):Bool return e.eq(a,b)
  
  public inline function notEq (a:T, b:T):Bool return e.notEq(a,b)
}
