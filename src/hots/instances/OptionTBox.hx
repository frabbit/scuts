package hots.instances;

import hots.instances.OptionTOf;
import hots.Of;
import scuts.core.types.Option;

class OptionTBox
{

  public static function box <M,A>(v:Of<M, Option<A>>):OptionTOf<M, A> return cast v
  
  public static function unbox <M,A>(v:OptionTOf<M, A>):Of<M, Option<A>> return cast v
  
  public static function boxF <M,A,B>(f:A->Of<M, Option<B>>):A->OptionTOf<M, B> return cast f
  
  public static function unboxF <M,A,B>(f:A->OptionTOf<M, B>):A->Of<M, Option<B>> return cast f
  
}