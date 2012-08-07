package ;


import hots.classes.Foldable;
import hots.Of;
import hots.instances.ArrayOfFoldable;
import hots.instances.ListOfFoldable;

using hots.macros.Resolver;
using hots.macros.Box;

class FoldableSample 
{

  public static function genericFoldLeft <M,T, Acc>(of:Of<M,T>, f:Foldable<M>, fn:Acc->T->Acc, acc:Acc):Acc
  {
    return f.foldLeft(of, acc, fn);
  }
  
  public static function main () {
    var arrOf = [2,3,4].box();
    
    var list = new List();
    list.add(3); list.add(2); list.add(1);
    
    var listOf = list.box();
    
    var fn = function (acc, e) return acc + e;
    
    trace(genericFoldLeft(arrOf, arrOf.tc(Foldable), fn, 0));
    trace(genericFoldLeft(listOf, listOf.tc(Foldable), fn, 0));
    
  }
    
  
}
