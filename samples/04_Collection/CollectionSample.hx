package ;

import hots.classes.Collection;
import hots.classes.Foldable;
import hots.Of;
import hots.instances.ArrayOfCollection;
import hots.instances.ListOfCollection;

using hots.macros.TcContext;
using hots.macros.Box;


class CollectionSample 
{

  
  
  public static function main () 
  {
    var arrOf = [2,3,4].box();
    
    var list = new List();
    list.add(3); list.add(2); list.add(1);
    
    var listOf = list.box();
    
    
    
    trace(insertIntoCollection(arrOf, arrOf.tc(Collection), 7));
    trace(insertIntoCollection(listOf, listOf.tc(Collection), 10));
    
    
    
  }
  
  
  public static function insertIntoCollection <M,T>(of:Of<M,T>, c:Collection<M>, el:T):Of<M,T>
  {
    return c.insert(of, el);
  }
  
  public static function removeFromCollection <M,T>(of:Of<M,T>, c:Collection<M>, remove:T->Bool):Of<M,T>
  {
    return c.remove(of, remove);
  }
  
}
// hots.instances.ArrayTOf<hots.Of<scuts.core.types.Option<hots.In>, scuts.core.types.Option<hots.In>>, Int> 



