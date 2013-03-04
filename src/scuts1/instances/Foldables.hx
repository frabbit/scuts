
package scuts1.instances;

import scuts1.classes.Foldable;
import scuts1.instances.std.ArrayFoldable;
import scuts1.instances.std.ImListFoldable;
import scuts1.instances.std.LazyListFoldable;
import scuts.ds.ImList;
import scuts.ds.LazyList;

import scuts1.core.In;


class Foldables 
{
  @:implicit @:noUsing public static var arrayFoldable             (default, null):Foldable<Array<In>> = new ArrayFoldable();
  @:implicit @:noUsing public static var lazyListFoldable          (default, null):Foldable<LazyList<In>> = new LazyListFoldable();
  @:implicit @:noUsing public static var imListFoldable          (default, null):Foldable<ImList<In>> = new ImListFoldable();
}