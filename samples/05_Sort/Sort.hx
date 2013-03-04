package ;

// Import der Do-Syntax
import haxe.Timer;
import scuts1.classes.Ord;

import scuts1.core.Hots;
import scuts.core.Tup2;

import scuts.core.ImLists;
import scuts.core.ImList;
import scuts.core.Option;

using scuts1.core.Hots;
// Identity stellt unter anderem die Funktion show bereit
using scuts1.Identity;
// Hinzufügen aller Typklasseninstanzen in den Using-Scope
using scuts1.ImplicitInstances;
// Hinzufügen aller Casts in den Using-Scope
using scuts1.ImplicitCasts;

class Sort
{
  public static function sort <A> (list:ImList<A>, ord:Ord<A>) 
  {
    Hots.implicit(ord);
    // Insertion Sort
    function insert (x:A, l:ImList<A>) 
    {
      return switch (l) {
        case Nil : ImLists.mkOne(x);
        case Cons(y, ys): 
          if (ord.greater(x,y)) 
            Cons(y, insert(x, ys)) 
          else Cons(x, l);
      }
    }
    
    return switch (list) {
      case Nil: Nil;
      case Cons(x, xs): insert(x, sort._(xs));
    }
  }
  
  public static function main() 
  {
    
    var tupleList = ImLists.fromArray([Tup2.create(4, 2.2), Tup2.create(1, 2.0), Tup2.create(1, 2.2), Tup2.create(0, 10.0)]);
    var intList = ImLists.fromArray([1,4,5,6,2]);
    var floatList = ImLists.fromArray([4.0,1.4,1.5,1.6,1.2]);
    var stringList = ImLists.fromArray(["paul", "bettina", "jerome", "kirstin"]);
    var arrayList = ImLists.fromArray([[Some(4)], [Some(2)], [Some(1)]]);
    
    trace(sort._(intList).show());
    trace(sort._(stringList).show());
    trace(sort._(floatList).show());
    trace(sort._(tupleList).show());
    trace(sort._(arrayList).show());
  }
}