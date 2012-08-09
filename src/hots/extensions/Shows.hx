package hots.extensions;
import hots.classes.Show;
import hots.Implicit;


class Shows
{
  public static inline function show<T>(v1:T, s:Implicit<Show<T>>):String return s.show(v1) 
  
  
  public static inline function create<T>(f:T->String) return new ShowByFun(f)
}

class ShowByFun<T> implements Show<T>
{
  
  var f : T->String;
  
  public function new (f:T->String) this.f = f
  
  public inline function show (s:T) return f(s)
  
}