package hots.extensions;

import hots.classes.Monoid;
import hots.instances.OptionBox;
import hots.instances.OptionFunctor;
import hots.instances.OptionOf;
import scuts.core.types.Option;

private typedef B = OptionBox;

extern class OptionOfExt 
{

  public static inline function box<A>(a:Option<A>):OptionOf<A> return B.box(a)
  
  public static inline function unbox<A>(a:OptionOf<A>):Option<A> return B.unbox(a)
  
  
  public static inline function map<A,B>(a:OptionOf<A>, f:A->B):OptionOf<B> 
  {
    return OptionFunctor.get().map(f,a);
  }
  
  public static inline function empty<A>():OptionOf<A> 
  {
    return B.box(None);
  }
  
  public static inline function concat<A>(a:OptionOf<A>, b:OptionOf<A>, m:Monoid<A>):OptionOf<A> 
  {
    var a1 = B.unbox(a);
    var b1 = B.unbox(b);
    
    return B.box(switch (a1) {
      case Some(v1):
        switch (b1) {
          case Some(v2): Some(m.append(v1,v2));
          case None: None;
        }
      case None: None;
    });
    
  }
    
}