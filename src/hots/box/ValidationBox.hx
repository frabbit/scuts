package hots.box;

import hots.instances.ValidationOf;
import hots.instances.ValidationTOf;
import hots.Of;
import scuts.core.types.Validation;

class ValidationBox 
{
  public static inline function boxT <M, F,S>(a:Of<M, Validation<F,S>>):ValidationTOf<M,F,S> return cast a
  
  public static inline function unboxT <M, F,S>(a:ValidationTOf<M,F,S>):Of<M, Validation<F,S>> return cast a
  
  public static inline function box <F,S>(a:Validation<F,S>):ValidationOf<F,S> return cast a
  
  public static inline function unbox <F,S>(a:ValidationOf<F,S>):Validation<F,S> return cast a
  
  public static inline function boxF <F,S,SS>(a:S->Validation<F,SS>):S->ValidationOf<F,SS> return cast a
  
  public static inline function unboxF <F,S,SS>(a:S->ValidationOf<F,SS>):S->Validation<F,SS> return cast a
  
  public static inline function validationT <A,F,S>(o:Of<A, Validation<F,S>>):ValidationTOf<A,F,S> return boxT(o)
  
  public static inline function runT <A,F,S>(o:ValidationTOf<A,F,S>):Of<A, Validation<F,S>> return unboxT(o) 
  
  public static inline function boxFT <X,A,F,S>(f:X->Of<A, Validation<F,S>>):X->ValidationTOf<A,F,S> return cast f
  
  public static inline function unboxFT <X, A,F,S>(f:X->ValidationTOf<A,F,S>):X->Of<A, Validation<F,S>> return cast f 
  
}

extern class FailProjectionBox 
{
  public static inline function box <F,S>(a:FailProjection<F,S>):FailProjectionOf<F,S> return cast a
  
  public static inline function unbox <F,S>(a:FailProjectionOf<F,S>):FailProjection<F,S> return cast a
}
