package hots.instances;
import hots.classes.Show;
import hots.classes.ShowAbstract;
import hots.instances.StringShow;

using scuts.core.extensions.ArrayExt;
using scuts.core.extensions.IteratorExt;

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
typedef HashShow = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(HashShowImpl)]>;