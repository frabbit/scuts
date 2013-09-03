
package scuts.ht.instances;

import scuts.ht.instances.std.IntNum;

import scuts.ht.instances.Eqs.*;
import scuts.ht.instances.Shows.*;

class Nums {
  @:implicit @:noUsing public static var intNum       (default, null) = new IntNum(intEq, intShow);
}