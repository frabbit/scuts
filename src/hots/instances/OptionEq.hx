package hots.instances;

import hots.classes.EqAbstract;
import scuts.core.types.Option;
import hots.classes.Eq;


class OptionEqImpl<T> extends EqAbstract<Option<T>> {
  
  var equals:Eq<T>;

  public function new (equals:Eq<T>) {
    this.equals = equals;
  }
  
  override public function eq  (a:Option<T>, b:Option<T>):Bool {
    return switch (a) {
      case None: 
        switch (b) {
          case None: true;
          case Some(_): false;
        }
      case Some(v1):
        switch (b) {
          case None: false;
          case Some(v2): equals.eq(v1, v2);
        }
    }
  }
  
}

typedef OptionEq = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(OptionEqImpl)]>;