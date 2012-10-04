package hots.macros.implicits;


class HacksHelper 
{
  public static inline function castCallbackTo0 <A,B>          (f:A->(Void->B),          c:Dynamic):A->B                return cast c
  public static inline function castCallbackTo1 <A,B,C>        (f:A->(B->C),             c:Dynamic):A->B->C             return cast c
  public static inline function castCallbackTo2 <A,B,C,D>      (f:A->(B->C->D),          c:Dynamic):A->B->C->D          return cast c
  public static inline function castCallbackTo3 <A,B,C,D,E>    (f:A->(B->C->D->E),       c:Dynamic):A->B->C->D->E       return cast c
  public static inline function castCallbackTo4 <A,B,C,D,E,F>  (f:A->(B->C->D->E->F),    c:Dynamic):A->B->C->D->E->F    return cast c
  public static inline function castCallbackTo5 <A,B,C,D,E,F,G>(f:A->(B->C->D->E->F->G), c:Dynamic):A->B->C->D->E->F->G return cast c
}