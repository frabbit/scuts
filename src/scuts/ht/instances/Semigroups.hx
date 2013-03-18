
package scuts.ht.instances;

import scuts.ht.classes.Semigroup;
import scuts.ht.classes.Show;
import scuts.ht.instances.std.ArraySemigroup;
import scuts.ht.instances.std.ArrayShow;
import scuts.ht.instances.std.DualSemigroup;
import scuts.ht.instances.std.EitherSemigroup;
import scuts.ht.instances.std.EndoSemigroup;
import scuts.ht.instances.std.ImListShow;
import scuts.ht.instances.std.IntProductSemigroup;
import scuts.ht.instances.std.IntSumSemigroup;
import scuts.ht.instances.std.LazyListShow;
import scuts.ht.instances.std.OptionSemigroup;
import scuts.ht.instances.std.OptionShow;
import scuts.ht.instances.std.StringSemigroup;
import scuts.ht.instances.std.Tup2Semigroup;
import scuts.ht.instances.std.Tup3Semigroup;
import scuts.ht.instances.std.ValidationSemigroup;
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
  public static function validationSemigroup <F,S>(semiF:SG<F>, semiS:SG<S>):SG<Validation<F,S>>        
    return new ValidationSemigroup(semiF, semiS);
  
  @:implicit @:noUsing 
  public static function optionSemigroup <X>(semiT:SG<X>):SG<Option<X>> 
    return new OptionSemigroup(semiT);
}