package hots.instances;
import hots.classes.Show;
import hots.classes.ShowAbstract;
import hots.instances.StringShow;

using scuts.core.extensions.Arrays;
using scuts.core.extensions.Iterators;

class HashShow<T> extends ShowAbstract<Hash<T>> {

  private var showT:Show<T>;
  private var stringShow:Show<String>;
  
  public function new (showT:Show<T>, stringShow:Show<String>) {
    this.showT = showT;
    this.stringShow = stringShow;
  }
  
  override public function show (v:Hash<T>):String 
  {
    var elems = v.keys().mapToArray(function (k) return stringShow.show(k) + " => " + showT.show(v.get(k)));
    return "{ " + elems.join(", ") + " }";
  }
}
