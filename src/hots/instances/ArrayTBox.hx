package hots.instances;
import hots.COf;
import hots.In;
import hots.Of;
import scuts.Assert;

/**
 * ...
 * @author 
 */

 
class ArrayTBox 
{
  public static inline function box <M,A>(v:Of<M, Array<A>>):ArrayTOf<M, A> {
    return cast Assert.assertNotNull(v);
  }
  
  /**
   * Unboxing of a value which is currently in the Context of ArrayTOf.
   * 
   */
  public static inline function unbox <M,A>(v:ArrayTOf<M, A>):Of<M, Array<A>> {
    return cast Assert.assertNotNull(v);
  }
  
  public static inline function boxInner <M,A>(v:Of<M, Of<Array<In>, A>>):ArrayTOf<M, A> {
    return cast Assert.assertNotNull(v);
  }
  
  public static inline function unboxInner <M,A>(v:ArrayTOf<M, A>):Of<M, Of<Array<In>, A>> {
    return cast Assert.assertNotNull(v);
  }
}