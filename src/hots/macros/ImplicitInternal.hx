package hots.macros;
import hots.Of;

class ImplicitInternal 
{
  public static inline function curry0<A> (f:Void->A):Void->A return null
  public static inline function curry1<A,B> (f:A->B):A->B return null
  public static inline function curry2<A,B,C> (f:A->B->C):A->(B->C) return null
  public static inline function curry3<A,B,C,D> (f:A->B->C->D):A->(B->(C->D)) return null
  public static inline function curry4<A,B,C,D,E> (f:A->B->C->D->E):A->(B->(C->(D->E))) return null
  public static inline function curry5<A,B,C,D,E,F> (f:A->B->C->D->E->F):A->(B->(C->(D->(E->F)))) return null
  public static inline function curry6<A,B,C,D,E,F,G> (f:A->B->C->D->E->F->G):A->(B->(C->(D->(E->(F->G))))) return null
  public static inline function curry7<A,B,C,D,E,F,G,H> (f:A->B->C->D->E->F->G->H):A->(B->(C->(D->(E->(F->(G->H)))))) return null
  
  public static inline function toImplicitConversion <A,B>(a:A, b:B->Void):hots.ImplicitConversion<A,B> return null
  public static inline function toImplicitObject <A>(a:A->Void):hots.ImplicitObject<A> return null
  
  public static inline function toImplicit <A>(a:A):hots.Implicit<A> return cast a
  
  public static inline function removeImplicit <A>(a:Implicit<A>):A return cast a
  
  public static inline function isValidConversionFunction <A,B>(from:A, to:B->Void, res:A->B):Void return null
  
  public static inline function neededIsOfType <A>(t:Of<Dynamic, Dynamic>->Void):Void return null
  
    
  public static inline function castCallbackTo0 <A,B>          (f:A->(Void->B),          c:Dynamic):A->B             return cast c
  public static inline function castCallbackTo1 <A,B,C>        (f:A->(B->C),             c:Dynamic):A->B->C          return cast c
  public static inline function castCallbackTo2 <A,B,C,D>      (f:A->(B->C->D),          c:Dynamic):A->B->C->D       return cast c
  public static inline function castCallbackTo3 <A,B,C,D,E>    (f:A->(B->C->D->E),       c:Dynamic):A->B->C->D->E    return cast c
  public static inline function castCallbackTo4 <A,B,C,D,E,F>  (f:A->(B->C->D->E->F),    c:Dynamic):A->B->C->D->E->F return cast c
  public static inline function castCallbackTo5 <A,B,C,D,E,F,G>(f:A->(B->C->D->E->F->G), c:Dynamic):A->B->C->D->E->F->G return cast c
  
  public static inline function castTo <X>(f:X, c:Dynamic):X return cast c
  
  public static inline function sameType <A>(a:A,b:A):Void return null
 
  public static inline function effectParam <T> (x:T->Void):T return null
  
  public static inline function id <T> (x:T):T return x
  
  public static inline function toEffect <A,B> (f:A->B):A->Void return null
  
  
  //public static function toEffect <A,B> (f:A->B):A->Void return null
}