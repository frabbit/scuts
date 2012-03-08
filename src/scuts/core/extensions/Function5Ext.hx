package scuts.core.extensions;




class Function5Ext 
{

  public static function flip < A, B, C, D, E, F > (f:A->B->C->D->E->F):B->A->C->D->E->F
  {
    return function (b, a, c, d, e) return f(a, b, c, d, e);
  }
  
}