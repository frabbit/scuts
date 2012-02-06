package hots.boxing;


import hots.wrapper.CVal;

class BoxCatFunction1 
{

  public static function box <A,B>(f:A->B):CValFunction<A,B> return cast f
  public static function unbox <A,B>(f:CValFunction<A,B>):A->B return cast f
}