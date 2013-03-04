package scuts1.instances.std;
import scuts1.classes.Show;
import scuts.ds.LazyLists;


class LazyListShow<T> implements Show<LazyList<T>> 
{
  private var showT:Show<T>;
  
  public function new (showT:Show<T>) 
  {
    this.showT = showT;
  }
  
  public function show (v:LazyList<T>):String 
  {
    return LazyLists.toString(v, showT.show);
  }
}
