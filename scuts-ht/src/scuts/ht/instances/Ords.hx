
package scuts.ht.instances;



import scuts.ht.classes.Ord;
import scuts.ht.instances.std.ArrayOrd;
import scuts.ht.instances.std.BoolOrd;
import scuts.ht.instances.std.DateOrd;
import scuts.ht.instances.std.FloatOrd;
import scuts.ht.instances.std.IntOrd;
import scuts.ht.instances.std.OptionOrd;
import scuts.ht.instances.std.StringOrd;
import scuts.ht.instances.std.Tup2Ord;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.Tuples;
import scuts.core.Validations;


import scuts.ht.instances.Eqs.*;

class Ords {
  @:implicit @:noUsing public static var floatOrd     (default, null):Ord<Float> = new FloatOrd(floatEq);
  @:implicit @:noUsing public static var intOrd       (default, null):Ord<Int>  = new IntOrd(intEq);

  @:implicit @:noUsing public static var stringOrd    (default, null):Ord<String>  = new StringOrd(stringEq);
  @:implicit @:noUsing public static var dateOrd      (default, null):Ord<Date>  = new DateOrd(dateEq, floatOrd);
  @:implicit @:noUsing public static var boolOrd       (default, null):Ord<Bool> = new BoolOrd(boolEq);

  @:implicit @:noUsing public static function optionOrd       <A>(a:Ord<A>):Ord<Option<A>> return new OptionOrd(a, optionEq(a));
  @:implicit @:noUsing public static function arrayOrd       <A>(a:Ord<A>):Ord<Array<A>> return new ArrayOrd(a, arrayEq(a));
  @:implicit @:noUsing public static function tup2Ord       <A,B>(a:Ord<A>, b:Ord<B>):Ord<Tup2<A,B>> return new Tup2Ord(a,b, tup2Eq(a,b));
}