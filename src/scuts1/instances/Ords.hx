
package scuts1.instances;



import scuts1.classes.Ord;
import scuts1.instances.std.ArrayOrd;
import scuts1.instances.std.BoolOrd;
import scuts1.instances.std.DateOrd;
import scuts1.instances.std.FloatOrd;
import scuts1.instances.std.IntOrd;
import scuts1.instances.std.OptionOrd;
import scuts1.instances.std.StringOrd;
import scuts1.instances.std.Tup2Ord;
import scuts.core.Option;
import scuts.core.Promise;
import scuts.core.Tup2;
import scuts.core.Validation;


import scuts1.core.Of;

import scuts1.instances.Eqs.*;

class Ords {
  @:implicit @:noUsing public static var floatOrd     (default, null):Ord<Float> = new FloatOrd(floatEq);
  @:implicit @:noUsing public static var intOrd       (default, null):Ord<Int>  = new IntOrd(intEq);
  
  @:implicit @:noUsing public static var stringOrd    (default, null)  = new StringOrd(stringEq);
  @:implicit @:noUsing public static var dateOrd      (default, null)  = new DateOrd(dateEq, floatOrd);
  @:implicit @:noUsing public static var boolOrd       (default, null) = new BoolOrd(boolEq);
  
  @:implicit @:noUsing public static function optionOrd       <A>(a:Ord<A>) return new OptionOrd(a, optionEq(a));
  @:implicit @:noUsing public static function arrayOrd       <A>(a:Ord<A>) return new ArrayOrd(a, arrayEq(a));
  @:implicit @:noUsing public static function tup2Ord       <A,B>(a:Ord<A>, b:Ord<B>) return new Tup2Ord(a,b, tup2Eq(a,b));
}