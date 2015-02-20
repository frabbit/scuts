
package scuts.ht.instances;



import scuts.ht.instances.std.*;

import scuts.ht.classes.Eq;
import scuts.core.Eithers;
import scuts.core.Options;
import scuts.core.Promises;
import scuts.core.Tuples;
import scuts.core.Validations;

import scuts.ht.syntax.Shows;

private typedef EB = scuts.ht.syntax.EqBuilder;

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
  public static function tup3Eq   <A,B,C>(eq1:Eq<A>, eq2:Eq<B>, eq3:Eq<C>):Eq<Tup3<A,B,C >>
  {
    function eq (a:Tup3<A,B,C>, b:Tup3<A,B,C>)
    {
      return eq1.eq(a._1, b._1) && eq2.eq(a._2, b._2) && eq3.eq(a._3, b._3);
    }
    return EB.create(eq);
  }

  @:implicit @:noUsing
  public static function tup4Eq   <A,B,C,D>(eq1:Eq<A>, eq2:Eq<B>, eq3:Eq<C>, eq4:Eq<D>):Eq<Tup4<A,B,C,D >>
  {
    function eq (a:Tup4<A,B,C,D>, b:Tup4<A,B,C,D>)
    {
      return eq1.eq(a._1, b._1) && eq2.eq(a._2, b._2) && eq3.eq(a._3, b._3) && eq4.eq(a._4, b._4);
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