package scuts.core.extensions;

import scuts.core.types.Tup3;

class Function3Ext 
{

  public static function curry < A, B, C, D > (f:A->B->C->D):A->(B->(C->D))
	{
		return function (a:A) 
      return function (b:B) 
        return function(c:C) return f(a, b, c);
	}
	
	public static function uncurry <A,B,C,D>(f:A->(B->(C->D))):A->B->C->D
	{
		return function (a,b,c) return f(a)(b)(c);
	}
  
  public static function flip < A, B, C, D > (f:A->B->C->D):B->A->C->D
	{
		return function (b, a, c) return f(a, b, c);
	}
  
  public static function tupled <A,B,C,Z>(f:A->B->C->Z):Tup3<A,B,C>->Z
  {
    return function (t) return f(t._1, t._2, t._3);
  }
  
  public static function untupled <A,B,C,Z>(f:Tup3<A,B,C>->Z):A->B->C->Z
  {
    return function (a,b,c) return f(Tup3.create(a,b,c));
  }
  
  
  
}