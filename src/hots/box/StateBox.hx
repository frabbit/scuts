package hots.box;
import hots.In;
import hots.of.StateOf;
import hots.of.StateTOf;
import scuts.core.types.State;

import hots.Of;



class StateBox 
{
  
  public static inline function box <S,X>(a:State<S,X>):StateOf<S,X> return a
  
  public static inline function unbox <S,X>(a:StateOf<S,X>):State<S,X> return a
  
  
  public static inline function box0 <S,X>(a:Void->State<S,X>):Void->StateOf<S,X> return a
  
  public static inline function unbox0 <S,X>(a:Void->StateOf<S,X>):Void->State<S,X> return a
  
  
  public static inline function boxF <A,S,X>(a:A->State<S,X>):A->StateOf<S,X> return a
  
  public static inline function unboxF <A,S,X>(e:A->StateOf<S,X>):A->State<S,X> return e
  
  
  public static inline function boxT <M,S,X>(a:Of<M, State<S,X>>):StateTOf<M,S,X> return a
  
  public static inline function unboxT <M,S,X>(a:StateTOf<M,S,X>):Of<M, State<S,X>> return cast a
  
  
}