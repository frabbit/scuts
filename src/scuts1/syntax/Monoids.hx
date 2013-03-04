package scuts1.syntax;
import scuts1.classes.Monoid;
import scuts1.classes.Semigroup;
import scuts1.classes.Zero;
import scuts1.syntax.Semigroups;
import scuts.Scuts;

class Monoids 
{
  public static function append <T>(v1:T, v2:T, m:Semigroup<T>):T return m.append(v1, v2);
}
