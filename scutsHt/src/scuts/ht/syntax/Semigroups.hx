package scuts.ht.syntax;

import scuts.ht.classes.Semigroup;


class Semigroups 
{
  public static function append <T>(v1:T, v2:T, m:Semigroup<T>):T 
  {
    return m.append(v1, v2);
  }
  
}
