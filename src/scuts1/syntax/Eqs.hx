package scuts1.syntax;
import scuts1.classes.Eq;

import scuts1.classes.EqAbstract;

class Eqs
{
  
  public static inline function eq<T>(v1:T, v2:T, eq:Eq<T>):Bool return eq.eq(v1, v2);
    
  public static inline function notEq<T>(v1:T, v2:T, eq:Eq<T>):Bool return eq.notEq(v1, v2);
}


