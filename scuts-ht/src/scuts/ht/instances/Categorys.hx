
package scuts.ht.instances;

import scuts.ht.classes.Category;
import scuts.ht.instances.std.Function;
import scuts.ht.instances.std.FunctionCategory;
import scuts.ht.instances.std.KleisliCategory;

class Categorys {
  @:implicit @:noUsing public static var functionCategory       (default, null):Category<Function<_,_>> = new FunctionCategory();
  @:implicit @:noUsing public static function kleisliCategory   (m) return new KleisliCategory(m);
}