package scuts.ht.instances;


import scuts.ht.classes.Zero;

import scuts.ht.instances.std.ArrayZero;
import scuts.ht.instances.std.EndoZero;
import scuts.ht.instances.std.IntProductZero;
import scuts.ht.instances.std.IntSumZero;
import scuts.ht.instances.std.OptionZero;
import scuts.ht.instances.std.StringZero;

import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.Tuples;

import scuts.ht.syntax.Shows;


class Zeros {
  @:implicit @:noUsing public static var intSumZero              (default, null):Zero<Int> = new IntSumZero();

  @:noUsing public static var intProductZero          (default, null):Zero<Int> = new IntProductZero();

  @:implicit @:noUsing public static function arrayZero               <T>():Zero<Array<T>> return new ArrayZero();

  @:implicit @:noUsing public static var stringZero              (default, null):Zero<String> = new StringZero();
  @:implicit @:noUsing public static var endoZero                (default, null) = new EndoZero();

  @:implicit @:noUsing public static function optionZero <T>():Zero<Option<T>> return new OptionZero();
}