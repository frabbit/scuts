package scuts.core.extensions;

import scuts.core.types.Tup2;


class Function2Ext 
{
  public static function curry < A, B, C > (f:A->B->C):A->(B->C)
	{
		return function (a:A) 
      return function (b:B) return f(a, b);
	}

	public static function uncurry <A,B,C>(f:A->(B->C)):A->B->C
	{
		return function (a:A, b:B) return f(a)(b);
	}
  
  public static function flip < A, B, C > (f:A->B->C):B->A->C
	{
		return function (b, a) return f(a, b);
	}

  public static function tupled <A,B,Z>(f:A->B->Z):Tup2<A,B>->Z
  {
    return function (t) return f(t._1, t._2);
  }
  public static function untupled <A,B,Z>(f:Tup2<A,B>->Z):A->B->Z
  {
    return function (a,b) return f(Tup2.create(a,b));
  }
}