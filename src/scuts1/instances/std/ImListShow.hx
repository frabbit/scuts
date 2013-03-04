package scuts1.instances.std;
import scuts1.classes.Show;
import scuts1.instances.std.ImListShow;
import scuts.ds.ImLists;

class ImListShow<T> implements Show<ImList<T>> 
{

  private var showT:Show<T>;
  
  public function new (showT:Show<T>) 
  {
    this.showT = showT;
  }
  
  public function show (v:ImList<T>):String 
  {
    return ImLists.toString(v, showT.show);
  }
}
