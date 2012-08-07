package hots.extensions;

import hots.box.OptionBox;
import hots.classes.Monoid;
import hots.classes.Semigroup;
import hots.instances.OptionOfFunctor;
import hots.instances.OptionOf;
import scuts.core.extensions.Options;
import scuts.core.types.Option;

private typedef B = hots.box.OptionBox;

using hots.box.OptionBox;

class OptionOfs
{

  public static inline function box<A>(of:Option<A>):OptionOf<A> return of.box()
  
  public static inline function unbox<A>(of:OptionOf<A>):Option<A> return of.unbox()
  
  public static inline function map<A,B>(of:OptionOf<A>, f:A->B):OptionOf<B> 
  {
    return OptionOfFunctor.get().map(of,f);
  }
  
  public static inline function empty<A>():OptionOf<A> 
  {
    return None.box();
  }
  
  public static function append<A>(of1:OptionOf<A>, of2:OptionOf<A>, m:Semigroup<A>):OptionOf<A> 
  {
    return Options.append(of1.unbox(), of2.unbox(), m.append).box();
  }
    
}