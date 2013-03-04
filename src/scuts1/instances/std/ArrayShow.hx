package scuts1.instances.std;
import scuts1.classes.Show;

using scuts.core.Arrays;

class ArrayShow<T> implements Show<Array<T>> 
{

  private var showT:Show<T>;
  
  public function new (showT:Show<T>) 
  {
    this.showT = showT;
  }
  
  public function show (v:Array<T>):String 
  {
    return "[" + v.map(function (x) return showT.show(x)).join(", ") + "]";
  }
}
