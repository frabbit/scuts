package scuts.ht.syntax;

import scuts.ht.classes.Eq;




class Eqs
{
  

  public static function eq<T>(v1:T, v2:T, eq:Eq<T>):Bool return eq.eq(v1, v2);



  public static function notEq<T>(v1:T, v2:T, eq:Eq<T>):Bool return eq.notEq(v1, v2);
}


