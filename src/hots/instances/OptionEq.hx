package hots.instances;

import hots.classes.EqAbstract;
import scuts.core.extensions.OptionExt;
import scuts.core.types.Option;
import hots.classes.Eq;


class OptionEqImpl<T> extends EqAbstract<Option<T>> {
  
  var equals:Eq<T>;

  public function new (equals:Eq<T>) {
    this.equals = equals;
  }
  
  override public function eq  (a:Option<T>, b:Option<T>):Bool return OptionExt.eq(a,b, equals.eq)
  
}

typedef OptionEq = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(OptionEqImpl)]>;