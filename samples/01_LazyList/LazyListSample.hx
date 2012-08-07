package ;
import haxe.Timer;
//import hots.instances.IntShow;
import scuts.core.types.Option;
import scuts.data.LazyList;
import scuts.data.LazyLists;

/**
 * ...
 * @author 
 */

using scuts.data.LazyLists;


private typedef LL = LazyLists;

enum IntHolder<T> {
  Some(i:T);
  None;
}
class LazyListSample 
{
  
  
  public static function main() 
  {
    var a = LL.mkEmpty();
    var b = a.appendElem(5).appendElem(7).appendElem(9);
    var c = b.appendElem(2).filter(function (x) return x >= 7).drop(1).cons(1);
    for (i in b) {
      trace(i);
    }
    
    for (i in c) {
      trace(i);
    }
    
  }
  
}