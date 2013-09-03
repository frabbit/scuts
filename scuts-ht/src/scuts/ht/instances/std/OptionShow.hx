package scuts.ht.instances.std;

import scuts.ht.classes.Show;
import scuts.core.Options;

class OptionShow<T> implements Show<Option<T>> 
{
  private var showT:Show<T>;
  
  public function new (showT:Show<T>) 
  {
    this.showT = showT;
  }
  
  public function show (v:Option<T>):String return switch (v) 
  {
    case Some(s): "Some(" + showT.show(s) + ")";
    case None: "None";
  }
}
