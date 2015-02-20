package scuts.ht.instances.std;

import scuts.core.Lazy;
import scuts.ht.classes.Pure;


import scuts.core.Options;


class LazyPure implements Pure<Lazy<In>>
{
  public function new () {}

  public function pure<B>(b:B):Lazy<B>
  {
  	return new Lazy(function () return b);
  }
}
