package scuts.core;
import scuts.core.State;
import scuts.core.Tup2;



class States 
{

  public static function map<ST,A,B>(x:State<ST,A>, f:A->B):State<ST,B> 
  {
    return function (s:ST) 
    {
      var t = x(s);
      return Tup2.create(t._1, f(t._2));
    }
  }
  
  @:noUsing public static function pure<ST, A>(x:A):State<ST,A> 
  {
    return function (s:ST) return Tup2.create(s, x);
  }
  
  public static function flatMap<ST,A,B>(x:State<ST,A>, f: A->State<ST,B>):State<ST,B> 
  {
    return function (s:ST) {
      var z = x(s);
      return f(z._2)(z._1);
    }
  }
}