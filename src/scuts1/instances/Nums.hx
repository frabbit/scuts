
package scuts1.instances;

import scuts1.instances.std.IntNum;

import scuts1.instances.Eqs.*;
import scuts1.instances.Shows.*;

class Nums {
  @:implicit @:noUsing public static var intNum       (default, null) = new IntNum(intEq, intShow);
}