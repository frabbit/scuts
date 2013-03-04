
package scuts1.instances;



import scuts1.instances.std.*;

import scuts1.classes.Eq;
import scuts.core.Eithers;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.Tuples;
import scuts.core.Validations;

import scuts1.syntax.Shows;

import scuts1.core.Of;

private typedef EB = scuts1.syntax.EqBuilder;

class Eqs {
  @:implicit @:noUsing public static var floatEq      (default, null):Eq<Float> = new FloatEq();
  
  @:implicit @:noUsing public static var intEq        (default, null):Eq<Int> = new IntEq();
  
  @:implicit @:noUsing public static var boolEq       (default, null):Eq<Bool> = new BoolEq();
  @:implicit @:noUsing public static var stringEq     (default, null):Eq<String> = new StringEq();
  @:implicit @:noUsing public static var dateEq       (default, null):Eq<Date> = new DateEq(floatEq);
  
  @:implicit @:noUsing 
  public static function eitherEq <A,B>(eq1:Eq<A>, eq2:Eq<B>):Eq<Either<A,B>> return new EitherEq(eq1, eq2);
  
  @:implicit @:noUsing 
  public static function tup2Eq   <A,B>(eq1:Eq<A>, eq2:Eq<B>):Eq<Tup2<A,B>> return new Tup2Eq(eq1, eq2);
  
  @:implicit @:noUsing 
  public static function tup3Eq   <A,B,C>(eq1, eq2, eq3):Eq<Tup3<A,B,C >> 
  {
    var eq = function (a:Tup3<A,B,C>, b:Tup3<A,B,C>) 
    {
      return eq1.eq(a._1, b._1) && eq2.eq(a._2, b._2) && eq3.eq(a._3, b._3);
    }
    return EB.create(eq);
  }
  
  @:implicit @:noUsing 
  public static function optionEq <T>(eqT:Eq<T>):Eq<Option<T>> return new OptionEq(eqT);
  
  @:implicit @:noUsing 
  public static function arrayEq  <T>(eqT:Eq<T>):Eq<Array<T>> return new ArrayEq(eqT);
  
  @:implicit @:noUsing 
  public static function validationEq  <F,S>(eqF:Eq<F>,eqS:Eq<S>):Eq<Validation<F,S>> return new ValidationEq(eqF,eqS);
}