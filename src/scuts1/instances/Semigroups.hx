
package scuts1.instances;

import scuts1.classes.Semigroup;
import scuts1.classes.Show;
import scuts1.instances.std.ArraySemigroup;
import scuts1.instances.std.ArrayShow;
import scuts1.instances.std.DualSemigroup;
import scuts1.instances.std.EitherSemigroup;
import scuts1.instances.std.EndoSemigroup;
import scuts1.instances.std.ImListShow;
import scuts1.instances.std.IntProductSemigroup;
import scuts1.instances.std.IntSumSemigroup;
import scuts1.instances.std.LazyListShow;
import scuts1.instances.std.OptionSemigroup;
import scuts1.instances.std.OptionShow;
import scuts1.instances.std.StringSemigroup;
import scuts1.instances.std.Tup2Semigroup;
import scuts1.instances.std.Tup3Semigroup;
import scuts1.instances.std.ValidationSemigroup;
import scuts.core.Eithers;
import scuts.core.Options;
import scuts.core.Tuples;
import scuts.core.Validations;
import scuts.ds.ImLists;
import scuts.ds.LazyLists;

private typedef SG<X> = Semigroup<X>;

class Semigroups 
{
  @:implicit @:noUsing public static function arraySemigroup <T>():SG<Array<T>> return new ArraySemigroup();
  
  @:implicit @:noUsing public static var intSumSemigroup           (default, null):SG<Int> = new IntSumSemigroup();
  @:implicit @:noUsing public static var stringSemigroup           (default, null):SG<String> = new StringSemigroup();
  @:noUsing public static var intProductSemigroup       (default, null) = new IntProductSemigroup();
  @:implicit @:noUsing public static function endoSemigroup             <T>():SG<T->T> return new EndoSemigroup();
  
  @:noUsing public static function dualSemigroup       (semiT)        return new DualSemigroup(semiT);
  
  @:implicit @:noUsing public static function eitherSemigroup     <L,R>(semiL, semiR):SG<Either<L,R>>        return new EitherSemigroup(semiL, semiR);
  @:implicit @:noUsing public static function tup2Semigroup       <A,B>(semi1, semi2):SG<Tup2<A,B>>        return new Tup2Semigroup(semi1, semi2);
  
  @:implicit @:noUsing 
  public static function tup3Semigroup       <A,B,C>(semi1:SG<A>, semi2:SG<B>, semi3:SG<C>):SG<Tup3<A,B,C>> 
  {
    return new Tup3Semigroup(semi1, semi2, semi3);
  }
  
  @:implicit @:noUsing 
  public static function validationSemigroup <F,S>(semiF, semiS):SG<Validation<F,S>>        
    return new ValidationSemigroup(semiF, semiS);
  
  @:implicit @:noUsing 
  public static function optionSemigroup (semiT) 
    return new OptionSemigroup(semiT);
}