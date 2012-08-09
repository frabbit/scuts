package hots.instances;
import hots.classes.Show;
import hots.classes.ShowAbstract;
import scuts.core.types.Option;

class OptionShow<T> extends ShowAbstract<Option<T>> 
{

  private var showT:Show<T>;
  
  public function new (showT:Show<T>) 
  {
    this.showT = showT;
  }
  
  override public function show (v:Option<T>):String return switch (v) 
  {
    case Some(s): "Some(" + showT.show(s) + ")";
    case None: "None";
  }
    
}
