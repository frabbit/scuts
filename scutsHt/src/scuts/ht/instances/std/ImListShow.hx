package scuts.ht.instances.std;
import scuts.ht.classes.Show;
import scuts.ht.instances.std.ImListShow;
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
