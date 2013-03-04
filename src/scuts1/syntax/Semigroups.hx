package scuts1.syntax;

import scuts1.classes.Semigroup;


class Semigroups 
{
  public static function append <T>(v1:T, v2:T, m:Semigroup<T>):T 
  {
    return m.append(v1, v2);
  }
  
}
