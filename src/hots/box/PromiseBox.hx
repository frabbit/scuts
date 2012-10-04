package hots.box;
import hots.In;
import hots.of.KleisliOf;
import hots.of.PromiseOf;
import hots.of.PromiseTOf;

import scuts.core.types.Promise;

class PromiseBox 
{
  
  public static inline function box <X>(o:Promise<X>):PromiseOf<X> return o
  
  public static inline function unbox <X>(o:PromiseOf<X>):Promise<X> return o
  
  public static inline function box0 <X>(o:Void->Promise<X>):Void->PromiseOf<X> return o
  
  public static inline function unbox0 <X>(o:Void->PromiseOf<X>):Void->Promise<X> return o
  
  public static inline function boxF <X,XX>(o:X->Promise<XX>):X->PromiseOf<XX> return o
  
  public static inline function unboxF <X,XX>(o:X->PromiseOf<XX>):X->Promise<XX> return o

  public static inline function boxT <M,X>(o:Of<M, Promise<X>>):PromiseTOf<M,X> return o
  
  public static inline function unboxT <M,X>(o:PromiseTOf<M,X>):Of<M, Promise<X>> return cast o
  
  public static inline function boxFT <M,X,A>(o:A->Of<M, Promise<X>>):A->PromiseTOf<M,X> return o
  
  public static inline function unboxFT <M,X,A>(o:A->PromiseTOf<M,X>):A->Of<M, Promise<X>> return cast o
  
}