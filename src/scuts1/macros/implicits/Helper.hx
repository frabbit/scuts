package scuts1.macros.implicits;

import scuts1.core.Of;

private class ImplicitObject<X> {}

class Helper 
{
  public static inline function curry0<A> (f:Void->A):Void->A return null;
  public static inline function curry1<A,B> (f:A->B):A->B return null;
  public static inline function curry2<A,B,C> (f:A->B->C):A->(B->C) return null;
  public static inline function curry3<A,B,C,D> (f:A->B->C->D):A->(B->(C->D)) return null;
  public static inline function curry4<A,B,C,D,E> (f:A->B->C->D->E):A->(B->(C->(D->E))) return null;
  public static inline function curry5<A,B,C,D,E,F> (f:A->B->C->D->E->F):A->(B->(C->(D->(E->F)))) return null;
  public static inline function curry6<A,B,C,D,E,F,G> (f:A->B->C->D->E->F->G):A->(B->(C->(D->(E->(F->G))))) return null;
  public static inline function curry7<A,B,C,D,E,F,G,H> (f:A->B->C->D->E->F->G->H):A->(B->(C->(D->(E->(F->(G->H)))))) return null;
  
  public static inline function toImplicitObject  <A>            (a:A)                  :ImplicitObject<A> return null;
  public static inline function toImplicitObject0 <A>            (a:Void->A)            :Void->ImplicitObject<A> return null;
  public static inline function toImplicitObject1 <A,B>          (a:A->B)               :A->ImplicitObject<B> return null;
  public static inline function toImplicitObject2 <A,B,C>        (a:A->B->C)            :A->B->ImplicitObject<C> return null;
  public static inline function toImplicitObject3 <A,B,C,D>      (a:A->B->C->D)         :A->B->C->ImplicitObject<D> return null;
  public static inline function toImplicitObject4 <A,B,C,D,E>    (a:A->B->C->D->E)      :A->B->C->D->ImplicitObject<E> return null;
  public static inline function toImplicitObject5 <A,B,C,D,E,F>  (a:A->B->C->D->E->F)   :A->B->C->D->E->ImplicitObject<F> return null;
  public static inline function toImplicitObject6 <A,B,C,D,E,F,G>(a:A->B->C->D->E->F->G):A->B->C->D->E->F->ImplicitObject<G> return null;
  
  public static inline function first <A,B> (f:A->B):A return null;
  
  public static inline function typeAsParam <A,B> (f:A):A->Void return null;
  
  
  
  public static inline function ret0 <B>(f:Void->B):B return null;
  public static inline function ret1 <A,B>(f:A->B):B return null;
  public static inline function ret2 <A,B,C>(f:A->B->C):C return null;
  public static inline function ret3 <A,B,C,D>(f:A->B->C->D):D return null;
  public static inline function ret4 <A,B,C,D,E>(f:A->B->C->D->E):E return null;
  public static inline function ret5 <A,B,C,D,E, F>(f:A->B->C->D->E->F):F return null;
  public static inline function ret6 <A,B,C,D,E,F,G>(f:A->B->C->D->E->F->G):G return null;
  
  public static inline function typed0 <B>(f:Void->B, x:B):Void->B return f;
  public static inline function typed1 <A,B>(f:A->B,x:B):A->B return f;
  public static inline function typed2 <A,B,C>(f:A->B->C,x:C):A->B->C return f;
  public static inline function typed3 <A,B,C,D>(f:A->B->C->D, x:D):A->B->C->D return f;
  public static inline function typed4 <A,B,C,D,E>(f:A->B->C->D->E, x:E):A->B->C->D->E return f;
  public static inline function typed5 <A,B,C,D,E, F>(f:A->B->C->D->E->F, x:F):A->B->C->D->E->F return f;
  public static inline function typed6 <A,B,C,D,E,F,G>(f:A->B->C->D->E->F->G, x:G):A->B->C->D->E->F->G return f;
  
  
}