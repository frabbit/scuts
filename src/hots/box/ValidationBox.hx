package hots.box;

import hots.instances.ValidationOf;
import hots.instances.ValidationTOf;
import hots.Of;
import scuts.core.types.Validation;

extern class ValidationBox 
{
  public static inline function boxT <M, F,S>(a:Of<M, Validation<F,S>>):ValidationTOf<M,F,S> return cast a
  
  public static inline function unboxT <M, F,S>(a:ValidationTOf<M,F,S>):Of<M, Validation<F,S>> return cast a
  
  public static inline function box <F,S>(a:Validation<F,S>):ValidationOf<F,S> return cast a
  
  public static inline function unbox <F,S>(a:ValidationOf<F,S>):Validation<F,S> return cast a
  
  public static inline function boxF <F,S,SS>(a:S->Validation<F,SS>):S->ValidationOf<F,SS> return cast a
  
  public static inline function unboxF <F,S,SS>(a:S->ValidationOf<F,SS>):S->Validation<F,SS> return cast a
  
}

extern class FailProjectionBox 
{
  public static inline function box <F,S>(a:FailProjection<F,S>):FailProjectionOf<F,S> return cast a
  
  public static inline function unbox <F,S>(a:FailProjectionOf<F,S>):FailProjection<F,S> return cast a
}
