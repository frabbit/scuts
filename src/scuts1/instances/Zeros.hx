
package scuts1.instances;




import scuts1.instances.std.ArrayZero;
import scuts1.instances.std.EndoZero;
import scuts1.instances.std.IntProductZero;
import scuts1.instances.std.IntSumZero;
import scuts1.instances.std.OptionZero;
import scuts1.instances.std.StringZero;

import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.Tuples;


import scuts1.syntax.Shows;

import scuts1.core.Of;

class Zeros {
  @:implicit @:noUsing public static var intSumZero              (default, null):Zero<Int> = new IntSumZero();
  
  @:noUsing public static var intProductZero          (default, null):Zero<Int> = new IntProductZero();
  
  @:implicit @:noUsing public static function arrayZero               <T>():Zero<Array<T>> return new ArrayZero();
  
  @:implicit @:noUsing public static var stringZero              (default, null):Zero<String> = new StringZero();
  @:implicit @:noUsing public static var endoZero                (default, null) = new EndoZero();
  
  @:implicit @:noUsing public static function optionZero <T>():Zero<Option<T>> return new OptionZero();
}