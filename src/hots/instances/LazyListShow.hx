package hots.instances;
import hots.classes.Show;
import hots.classes.ShowAbstract;
import scuts.core.extensions.LazyLists;
import scuts.core.types.LazyList;

using scuts.core.extensions.Arrays;

class LazyListShow<T> extends ShowAbstract<LazyList<T>> 
{
  private var showT:Show<T>;
  
  public function new (showT:Show<T>) 
  {
    this.showT = showT;
  }
  
  override public function show (v:LazyList<T>):String 
  {
    return LazyLists.toString(v, showT.show);
  }
}
