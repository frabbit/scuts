package hots.instances;
import hots.classes.Show;
import hots.classes.ShowAbstract;
import hots.instances.StringShow;

using scuts.core.extensions.ArrayExt;
using scuts.core.extensions.IteratorExt;

#if macro
import scuts.macro.builder.TypeClasses;
import haxe.macro.Expr;
#end

class HashShow {
  
  static var hash:Hash<Show<Dynamic>> = new Hash();
  
  @:macro public static function forType <S>(showT:ExprRequire<Show<S>>):Expr {
    return TypeClasses.forType([showT], "Hash<Show<Dynamic>>", "hots.instances.ShowHashImpl", "hots.instances.ShowHash");
  }
}

class HashShowImpl<T> extends ShowAbstract<Hash<T>> {

  private var showT:Show<T>;
  
  public function new (showT:Show<T>) {
    this.showT = showT;
  }
  
  override public function show (v:Hash<T>):String {
    
    var elems = v.keys().mapToArray(function (k) return StringShow.get().show(k) + " => " + showT.show(v.get(k)));
    return "{ " + elems.join(", ") + " }";
  }
}