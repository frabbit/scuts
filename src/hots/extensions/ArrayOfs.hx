package hots.extensions;

import hots.instances.ArrayOfFunctor;
import hots.instances.ArrayOf;

using scuts.core.extensions.Arrays;

typedef ArrayBox = hots.box.ArrayBox;

using hots.extensions.ArrayOfs.ArrayBox;

class ArrayOfs
{
  
  public static inline function box <A>(a:Array<A>):ArrayOf<A> 
  {
    return ArrayBox.box(a);
  }
  
  public static inline function unbox <A>(a:ArrayOf<A>):Array<A> 
  {
    return ArrayBox.unbox(a);
  }
  
  
  public static inline function map <A,B>(a:ArrayOf<A>, f:A->B):ArrayOf<B> 
  {
    return a.unbox().map(f).box();
  }
  
  public static inline function flatMap<A,B>(a:ArrayOf<A>, f:A->ArrayOf<B>):ArrayOf<B> 
  {
    return a.unbox().flatMap(f.unboxF()).box();
  }
  
  public static inline function empty<A>():ArrayOf<A> 
  {
    return [].box();
  }
  
  public static inline function concat<A>(a:ArrayOf<A>, b:ArrayOf<A>):ArrayOf<A> 
  {
    return a.unbox().concat(b.unbox()).box();
  }
    
}