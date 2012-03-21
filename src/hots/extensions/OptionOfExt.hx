package hots.extensions;

import hots.classes.Monoid;
import hots.instances.OptionOfFunctor;
import hots.instances.OptionOf;
import scuts.core.types.Option;

private typedef B = hots.macros.Box;

extern class OptionOfExt 
{

  public static inline function box<A>(a:Option<A>):OptionOf<A> return B.box(a)
  
  public static inline function unbox<A>(a:OptionOf<A>):Option<A> return B.unbox(a)
  
  
  public static inline function map<A,B>(a:OptionOf<A>, f:A->B):OptionOf<B> 
  {
    return OptionOfFunctor.get().map(f,a);
  }
  
  public static inline function empty<A>():OptionOf<A> 
  {
    return B.box(None);
  }
  
  public static function concat<A>(a:OptionOf<A>, b:OptionOf<A>, m:Monoid<A>):OptionOf<A> 
  {
    
    return B.box(switch (B.unbox(a)) {
      case Some(v1):
        switch (B.unbox(b)) {
          case Some(v2): Some(m.append(v1,v2));
          case None: None;
        }
      case None: None;
    });
    
  }
    
}