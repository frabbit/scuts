package hots.extensions;
import hots.classes.Ord;
import hots.classes.OrdAbstract;
import scuts.core.types.Ordering;


class Ords
{

  /**
   * Helper Function to create various Ord instances from a function.
   */
  public static function create <T>(f:T->T->Ordering):Ord<T> return new OrdByFunc(f)
  
  // static functions of Ord
  
  public static inline function compare<T>(v1:T, v2:T, o:Ord<T>):Ordering return o.compare(v1, v2)
    
  public static inline function greater<T>(v1:T, v2:T, o:Ord<T>):Bool return o.greater(v1, v2)
  
  public static inline function less<T>(v1:T, v2:T, o:Ord<T>):Bool return o.less(v1, v2)
  
  public static inline function greaterOrEq<T>(v1:T, v2:T, o:Ord<T>):Bool return o.greaterOrEq(v1, v2)
  
  public static inline function lessOrEq<T>(v1:T, v2:T, o:Ord<T>):Bool return o.lessOrEq(v1, v2)
  
  public static inline function max<T>(v1:T, v2:T, o:Ord<T>):T return o.max(v1, v2)
  
  public static inline function min<T>(v1:T, v2:T, o:Ord<T>):T return o.min(v1, v2)
  
}


private class OrdByFunc<T> extends OrdAbstract<T>
{
  var f : T->T->Ordering;
  
  public function new (f:T->T->Ordering) 
  {
    super(Eqs.create(function (a,b) return f(a,b) == EQ));
    this.f = f;
  }
  
  override public inline function compare (a:T, b:T) return f(a,b)
}