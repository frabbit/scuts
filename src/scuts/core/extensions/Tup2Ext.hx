package scuts.core.extensions;
import scuts.core.types.Tup2;

class Tup2Ext 
{
  public static function swap <X,Y>(t:Tup2<X,Y>) return Tup2.create(t._2, t._1)
  
  public static function eq <X,Y>(t1:Tup2<X,Y>, t2:Tup2<X,Y>, eq1:X->X->Bool, eq2:Y->Y->Bool) {
    return eq1(t1._1, t2._1) && eq2(t1._2, t2._2);
  }
}