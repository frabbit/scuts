package hots.extensions;
import hots.classes.Arrow;
import hots.classes.Category;
import hots.COf;
import scuts.core.types.Tup2;


class COfExt 
{
  public static inline function 
  next <A,B,C, Cat>(f:COf<Cat, A, B>, g:COf<Cat, B, C>, cat:Category<Cat>):COf<Cat,A, C> return cat.next(f,g)
  
  public function split <B,B1, C,C1,D, AR>(f:COf<AR,B, C>, g:COf<AR, B1, C1>, arr:Arrow<AR>):COf<AR, Tup2<B,B1>, Tup2<C,C1>> {
    return arr.split(f,g);
  }
}