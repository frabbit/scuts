
package scuts.ht.instances;

import scuts.ht.classes.Foldable;
import scuts.ht.instances.std.ArrayFoldable;
import scuts.ht.instances.std.ImListFoldable;
import scuts.ht.instances.std.LazyListFoldable;
import scuts.ds.ImLists;
import scuts.ds.LazyLists;



class Foldables
{
  @:implicit @:noUsing public static var arrayFoldable             (default, null):Foldable<Array<_>> = new ArrayFoldable();
  @:implicit @:noUsing public static var lazyListFoldable          (default, null):Foldable<LazyList<_>> = new LazyListFoldable();
  @:implicit @:noUsing public static var imListFoldable          (default, null):Foldable<ImList<_>> = new ImListFoldable();
}