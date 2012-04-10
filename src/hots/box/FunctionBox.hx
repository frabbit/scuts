package hots.box;


import hots.instances.FunctionOf;

class FunctionBox 
{

  public static function asArrow <A,B>(f:A->B):FunctionOf<A,B> return cast f
  public static function runArrow <A,B>(f:FunctionOf<A,B>):A->B return cast f
}