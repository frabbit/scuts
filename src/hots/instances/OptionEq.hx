package hots.instances;

import hots.classes.EqAbstract;
import scuts.core.extensions.Options;
import scuts.core.types.Option;
import hots.classes.Eq;


class OptionEq<T> extends EqAbstract<Option<T>> {
  
  var equals:Eq<T>;

  public function new (equals:Eq<T>) {
    this.equals = equals;
  }
  
  override public function eq  (a:Option<T>, b:Option<T>):Bool return Options.eq(a,b, equals.eq)
  
}
