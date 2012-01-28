package scuts.core.extensions;
import scuts.core.types.Tup2;

class Tup2s 
{

  public static function swap <X,Y>(t:Tup2<X,Y>) return Tup2.create(t._2, t._1)
  
}