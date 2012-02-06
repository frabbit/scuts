package hots.boxing;

import hots.wrapper.MVal;
import scuts.core.types.Option;
import hots.wrapper.MTVal;

class BoxOptionT 
{

  public static function box <M,A>(v:MVal<M, Option<A>>):MTValOption<M, A> return cast v
  
  public static function unbox <M,A>(v:MTValOption<M, A>):MVal<M, Option<A>> return cast v
  
  public static function boxF <M,A,B>(f:A->MVal<M, Option<B>>):A->MTValOption<M, B> return cast f
  
  public static function unboxF <M,A,B>(f:A->MTValOption<M, B>):A->MVal<M, Option<B>> return cast f
  
}