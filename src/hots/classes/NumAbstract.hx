package hots.classes;
import hots.classes.Eq;
import hots.classes.Show;
import scuts.Scuts;




@:tcAbstract class NumAbstract<A> implements Num<A> 
{
  
  var e:Eq<A>;
  var s:Show<A>;
    
  public function new (eq:Eq<A>, show:Show<A>) {
    this.e = eq;
    this.s = show;
  }
  
  public function minus (a:A, b:A):A {
    return minus(a, negate(b));
  }
  
  public function plus (a:A, b:A):A return Scuts.abstractMethod()
  public function mul (a:A, b:A):A return Scuts.abstractMethod()
  
  
  public function negate (a:A):A return Scuts.abstractMethod()
  public function abs (a:A):A return Scuts.abstractMethod()
  public function signum (a:A):A return Scuts.abstractMethod()
  public function fromInt (a:Int):A return Scuts.abstractMethod()
  
  
  // delegation of Show
  @:final public inline function show (a:A):String return s.show(a)
  
  // delegation of Eq
  @:final public inline function eq (a:A, b:A):Bool return e.eq(a,b)
  
  @:final public inline function notEq (a:A, b:A):Bool return e.notEq(a,b)
}