
package scuts1.instances;

import scuts1.classes.Monoid;
import scuts1.classes.Semigroup;
import scuts.core.Options;


import scuts1.instances.Semigroups.*;
import scuts1.instances.Zeros.*;
private typedef MB = scuts1.syntax.MonoidBuilder;

class Monoids 
{
  @:implicit @:noUsing public static var intSumMonoid              (default, null):Monoid<Int> = MB.createFromSemiAndZero(intSumSemigroup, intSumZero);
  
  @:noUsing public static var intProductMonoid          (default, null) = MB.createFromSemiAndZero(intProductSemigroup, intProductZero);
  
  @:implicit @:noUsing public static function arrayMonoid               <T>():Monoid<Array<T>> return MB.createFromSemiAndZero(arraySemigroup(), arrayZero());
  
  @:implicit @:noUsing public static var stringMonoid              (default, null):Monoid<String> = MB.createFromSemiAndZero(stringSemigroup, stringZero);
  @:implicit @:noUsing public static function endoMonoid                <T>():Monoid<T->T> return MB.createFromSemiAndZero(endoSemigroup(), endoZero);
  
  @:implicit @:noUsing public static function optionMonoid <T>(semiT:Semigroup<T>):Monoid<Option<T>> return MB.createFromSemiAndZero(optionSemigroup(semiT), optionZero());
  @:noUsing public static function dualMonoid   <T>(monoidT:Monoid<T>):Monoid<T> return MB.createFromSemiAndZero(dualSemigroup(monoidT), monoidT);
}