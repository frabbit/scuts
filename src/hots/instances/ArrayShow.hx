package hots.instances;
import hots.classes.Show;

using scuts.core.extensions.ArrayExt;

#if macro
import scuts.macro.builder.TypeClasses;
import haxe.macro.Expr;
#end

class ShowArray {
  
  static var hash:Hash<Show<Dynamic>> = new Hash();
  
  @:macro public static function forType <S>(showT:ExprRequire<Show<S>>):Expr {
    return TypeClasses.forType([showT], "Hash<Show<Dynamic>>", "hots.instances.ShowArrayImpl", "hots.instances.ShowArray");
  }
}

class ShowArrayImpl<T> implements Show<Array<T>> {

  private var showT:Show<T>;
  
  public function new (showT:Show<T>) {
    this.showT = showT;
  }
  
  public function show (v:Array<T>):String {
    return "[" + v.map(function (x) return showT.show(x)).join(", ") + "]";
  }
}