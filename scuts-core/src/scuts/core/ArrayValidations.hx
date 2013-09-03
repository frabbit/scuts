
package scuts.core;

import scuts.core.Validations;

private typedef VD<F,S> = Validation<F,S>;

class ArrayValidations {

  public static function catIfAllSuccess <F,S>(x:Array<VD<F,S>>):VD<F, Array<S>>
  {
    var res = [];
    for (i in x) {
      switch (i) {
        case Success(v): res.push(v);
        case Failure(f): return Failure(f);
      }
    }
    return Success(res);
  }

}