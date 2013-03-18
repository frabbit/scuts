package scuts.ht.macros.implicits;

import scuts.ht.core.Hots;

class HacksHelper 
{
  public static inline function castCallbackTo0 <A,B>          (f:A->(Void->B),          c:Dynamic):A->B                return Hots.preservedCast(cast c);
  public static inline function castCallbackTo1 <A,B,C>        (f:A->(B->C),             c:Dynamic):A->B->C             return Hots.preservedCast(cast c);
  public static inline function castCallbackTo2 <A,B,C,D>      (f:A->(B->C->D),          c:Dynamic):A->B->C->D          return Hots.preservedCast(cast c);
  public static inline function castCallbackTo3 <A,B,C,D,E>    (f:A->(B->C->D->E),       c:Dynamic):A->B->C->D->E       return Hots.preservedCast(cast c);
  public static inline function castCallbackTo4 <A,B,C,D,E,F>  (f:A->(B->C->D->E->F),    c:Dynamic):A->B->C->D->E->F    return Hots.preservedCast(cast c);
  public static inline function castCallbackTo5 <A,B,C,D,E,F,G>(f:A->(B->C->D->E->F->G), c:Dynamic):A->B->C->D->E->F->G return Hots.preservedCast(cast c);
}