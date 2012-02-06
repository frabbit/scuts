package hots.instances;

import hots.classes.Eq;
import hots.classes.EqAbstract;

#if macro
import haxe.macro.Expr;
import scuts.macro.builder.TypeClasses;
#end

class EqArray  {

  static var hash:Hash<EqArrayImpl<Dynamic>> = new Hash();
  
  @:macro public static function forType <S>(eqT:ExprRequire<Eq<S>>):Expr {
    return TypeClasses.forType([eqT], "Hash<hots.instances.EqArrayImpl<Dynamic>>", "hots.instances.EqArrayImpl", "hots.instances.EqArray");
  }
}

class EqArrayImpl<T> extends EqAbstract<Array<T>> {
  
  var eqT:Eq<T>;
  
  public function new (eqT:Eq<T>) 
  {
    this.eqT = eqT;
  }
  
  override public function eq  (a:Array<T>, b:Array<T>):Bool {
    if (a.length != b.length) return false;
    for ( i in 0...a.length) {
      if (!eqT.eq(a[i], b[i])) return false;
    }
    return true;
  }
  
}