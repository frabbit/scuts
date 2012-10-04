package hots.box;

import hots.Of;
import hots.of.ValidationOf;
import hots.of.ValidationTOf;
import scuts.core.types.Validation;

class ValidationBox 
{
  public static inline function boxT <M, F,S>(a:Of<M, Validation<F,S>>):ValidationTOf<M,F,S> return a
  
  public static inline function unboxT <M, F,S>(a:ValidationTOf<M,F,S>):Of<M, Validation<F,S>> return cast a
  
  public static inline function box <F,S>(a:Validation<F,S>):ValidationOf<F,S> return a
  
  public static inline function unbox <F,S>(a:ValidationOf<F,S>):Validation<F,S> return a
  
  public static inline function box0 <F,S>(a:Void->Validation<F,S>):Void->ValidationOf<F,S> return a
  
  public static inline function unbox0 <F,S>(a:Void->ValidationOf<F,S>):Void->Validation<F,S> return a
  
  public static inline function boxF <F,S,SS>(a:S->Validation<F,SS>):S->ValidationOf<F,SS> return a
  
  public static inline function unboxF <F,S,SS>(a:S->ValidationOf<F,SS>):S->Validation<F,SS> return a
  
  public static inline function boxFT <X,A,F,S>(f:X->Of<A, Validation<F,S>>):X->ValidationTOf<A,F,S> return f
  
  public static inline function unboxFT <X, A,F,S>(f:X->ValidationTOf<A,F,S>):X->Of<A, Validation<F,S>> return cast f 
  
  
  public static inline function validationT <A,F,S>(o:Of<A, Validation<F,S>>):ValidationTOf<A,F,S> return boxT(o)
  
  public static inline function runT <A,F,S>(o:ValidationTOf<A,F,S>):Of<A, Validation<F,S>> return unboxT(o) 
}

extern class FailProjectionBox 
{
  public static inline function box <F,S>(a:FailProjection<F,S>):FailProjectionOf<F,S> return cast a
  
  public static inline function unbox <F,S>(a:FailProjectionOf<F,S>):FailProjection<F,S> return cast a
}
