package hots.extensions;
import hots.classes.Eq;
import hots.Implicit;


class Eqs
{

  public static function create <A>(f:A->A->Bool) return new EqByFun(f)
  
  public static inline function eq<T>(v1:T, v2:T, eq:Implicit<Eq<T>>):Bool return eq.eq(v1, v2)
    
  public static inline function notEq<T>(v1:T, v2:T, eq:Implicit<Eq<T>>):Bool return eq.notEq(v1, v2)
  
}

import hots.classes.EqAbstract;

class EqByFun<T> extends EqAbstract<T> 
{
  var f:T->T->Bool;
  
  public function new (f:T->T->Bool) this.f = f
  
  override inline function eq (a:T, b:T) return f(a,b)
}