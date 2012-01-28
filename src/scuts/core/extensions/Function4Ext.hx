package scuts.core.extensions;

class Function4Ext 
{

  public static function curry < A, B, C, D, Z > (f:A->B->C->D->Z):A->(B->(C->(D->Z)))
	{
		return function (a:A) 
      return function (b:B) 
        return function(c:C) 
          return function(d:D) 
            return f(a, b, c,d);
	}

	public static function uncurry <A,B,C,D, Z>(f:A->(B->(C->(D->Z)))):A->B->C->D->Z
	{
		return function (a,b,c,d) return f(a)(b)(c)(d);
	}
  
  public static function flip < A, B, C, D, E > (f:A->B->C->D->E):B->A->C->D->E
	{
		return function (b, a, c, d) return f(a, b, c, d);
	}
  
}