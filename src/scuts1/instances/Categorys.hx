
package scuts1.instances;

import scuts1.classes.Category;
import scuts1.instances.std.FunctionCategory;
import scuts1.instances.std.KleisliCategory;
import scuts1.core.In;

class Categorys {
  @:implicit @:noUsing public static var functionCategory       (default, null):Category<In->In> = new FunctionCategory();
  @:implicit @:noUsing public static function kleisliCategory   (m) return new KleisliCategory(m);
}