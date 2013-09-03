
package scuts.ht.instances;

import scuts.ht.classes.Show;
import scuts.ht.instances.std.ArrayShow;
import scuts.ht.instances.std.FloatShow;
import scuts.ht.instances.std.ImListShow;
import scuts.ht.instances.std.IntShow;
import scuts.ht.instances.std.LazyListShow;
import scuts.ht.instances.std.OptionShow;
import scuts.ht.instances.std.StringShow;
import scuts.core.Options;
import scuts.core.Tuples;
import scuts.core.Validations;
import scuts.ds.ImLists;
import scuts.ds.LazyLists;


private typedef SB = scuts.ht.syntax.ShowBuilder;

class Shows 
{
  @:implicit @:noUsing public static var stringShow                (default, null):Show<String> = new StringShow();
  @:implicit @:noUsing public static var intShow                   (default, null):Show<Int> = new IntShow();
  @:implicit @:noUsing public static var floatShow                 (default, null):Show<Float> = new FloatShow();
  
  @:implicit @:noUsing public static function lazyListShow          <T>(showT:Show<T>):Show<LazyList<T>>        return new LazyListShow(showT);
  @:implicit @:noUsing public static function imListShow            <T>(showT:Show<T>):Show<ImList<T>>        return new ImListShow(showT);
  @:implicit @:noUsing public static function arrayShow             <T>(showT:Show<T>):Show<Array<T>>        return new ArrayShow(showT);
  @:implicit @:noUsing public static function optionShow            <T>(showT:Show<T>):Show<Option<T>>        return new OptionShow(showT);
  
  @:implicit @:noUsing public static function tup2Show         <A,B>(show1:Show<A>, show2:Show<B>):Show<Tup2<A,B>> 
  {
    return SB.create(function (t:Tup2<A,B>) return "(" + show1.show(t._1) + ", " + show2.show(t._2) + ")");
  }
  
  @:implicit @:noUsing public static function validationShow        <F,S>(showF, showS):Show<Validation<F,S>> 
  {
    return SB.create(function (v) return switch (v) 
    { 
      case Success(s): "Success(" + showS.show(s) + ")";
      case Failure(f): "Failure(" + showF.show(f) + ")";
    });
  }
}