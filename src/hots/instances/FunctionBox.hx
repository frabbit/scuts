package hots.instances;


import hots.instances.FunctionOf;

class FunctionBox 
{

  public static function box <A,B>(f:A->B):FunctionOf<A,B> return cast f
  public static function unbox <A,B>(f:FunctionOf<A,B>):A->B return cast f
}