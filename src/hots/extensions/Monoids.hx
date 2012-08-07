package hots.extensions;
import hots.classes.Monoid;
import hots.classes.Semigroup;
import hots.Implicit;


class Monoids 
{
  public static function append <T>(v1:T, v2:T, m:Implicit<Semigroup<T>>):T 
  {
    return m.append(v1, v2);
  }
  
}