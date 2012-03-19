package hots.instances;
import hots.classes.Show;
import hots.classes.ShowAbstract;

using scuts.core.extensions.ArrayExt;

class ArrayShow<T> extends ShowAbstract<Array<T>> {

  private var showT:Show<T>;
  
  public function new (showT:Show<T>) {
    this.showT = showT;
  }
  
  override public function show (v:Array<T>):String {
    return "[" + v.map(function (x) return showT.show(x)).join(", ") + "]";
  }
}
