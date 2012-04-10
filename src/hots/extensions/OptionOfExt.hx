package hots.extensions;

import hots.classes.Monoid;
import hots.instances.OptionOfFunctor;
import hots.instances.OptionOf;
import scuts.core.types.Option;

private typedef B = hots.macros.Box;

class OptionOfExt 
{

  public static inline function box<A>(of:Option<A>):OptionOf<A> return B.box(of)
  
  public static inline function unbox<A>(of:OptionOf<A>):Option<A> return B.unbox(of)
  
  
  public static inline function map<A,B>(of:OptionOf<A>, f:A->B):OptionOf<B> 
  {
    return OptionOfFunctor.get().map(of,f);
  }
  
  public static inline function empty<A>():OptionOf<A> 
  {
    return B.box(None);
  }
  
  public static function concat<A>(of1:OptionOf<A>, of2:OptionOf<A>, m:Monoid<A>):OptionOf<A> 
  {
    
    return B.box(switch (B.unbox(of1)) {
      case Some(v1):
        switch (B.unbox(of2)) {
          case Some(v2): Some(m.append(v1,v2));
          case None: None;
        }
      case None: None;
    });
    
  }
    
}