package hots.extensions;
import hots.instances.ArrayBox;
import hots.instances.ArrayOfFunctor;
import hots.instances.ArrayOf;

private typedef B = ArrayBox;

extern class ArrayOfExt 
{

  public static inline function box<A>(a:Array<A>):ArrayOf<A> 
  {
    return B.box(a);
  }
  
  public static inline function unbox<A>(a:ArrayOf<A>):Array<A> 
  {
    return B.unbox(a);
  }
  
  public static inline function map<A,B>(a:ArrayOf<A>, f:A->B):ArrayOf<B> 
  {
    return ArrayOfFunctor.get().map(f,a);
  }
  
  public static inline function empty<A>():ArrayOf<A> 
  {
    return ArrayBox.box([]);
  }
  
  public static inline function concat<A>(a:ArrayOf<A>, b:ArrayOf<A>):ArrayOf<A> 
  {
    return B.box(B.unbox(a).concat(B.unbox(b)));
  }
    
}