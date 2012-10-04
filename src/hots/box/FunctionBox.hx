package hots.box;


import hots.In;
import hots.Of;
import hots.of.FunctionOfOf;

class FunctionBox 
{
  public static function asArrow <A,B>(f:A->B):FunctionOfOf<A,B> return cast f
  
  public static function runArrow <A,B>(f:FunctionOfOf<A,B>):A->B return cast f
}

class Function0Box 
{
  public static function box <A>(f:Void->A):Of<Void->In,A> return cast f
  
  public static function unbox <A>(f:Of<Void->In,A>):Void->A return cast f
}

class Function1Box 
{
  public static function box <A,B>(f:A->B):Of<A->In,B> return cast f
  
  public static function unbox <A,B>(f:Of<A->In,B>):A->B return cast f
  
}