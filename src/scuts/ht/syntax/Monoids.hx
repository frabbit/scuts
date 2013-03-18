package scuts.ht.syntax;
import scuts.ht.classes.Monoid;
import scuts.ht.classes.Semigroup;
import scuts.ht.classes.Zero;
import scuts.ht.syntax.Semigroups;
import scuts.Scuts;

class Monoids 
{
  public static function append <T>(v1:T, v2:T, m:Semigroup<T>):T return m.append(v1, v2);
}
