package scuts.ht.instances.std;

import scuts.core.Lazy;
import scuts.ht.classes.Pure;

import scuts.ht.core.In;

import scuts.core.Options;
import scuts.ht.instances.std.LazyOf;


class LazyPure implements Pure<Lazy<In>>
{
  public function new () {}
  
  public function pure<B>(b:B):LazyOf<B> 
  {
    return function () return b;
  }
}
