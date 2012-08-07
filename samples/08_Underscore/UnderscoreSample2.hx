package ;



import hots.box.ArrayBox;
import hots.classes.Monad;
import hots.classes.Monad;
import hots.classes.Monoid;
import hots.classes.Show;
import hots.classes.ShowAbstract;
import hots.extensions.Arrows;
import hots.extensions.Monads;
import hots.extensions.Monoids;
import hots.extensions.Shows;
import hots.Hots;
import hots.In;
import hots.instances.ArrayOf;
import hots.instances.IntProductMonoid;
import hots.Of;
import scuts.core.types.Option;


using hots.Hots;

using hots.box.ArrayBox;
using hots.box.OptionBox;

using scuts.core.extensions.Functions;

using scuts.core.extensions.Options;

using hots.extensions.Arrows;

class MyBetterStringShow2 extends ShowAbstract<String> {
  
  public function new () {  }
  
  public override function show (s:String) {
    return "super " + s;
  }
  
  public static function implicitObj (i:Show<String>->Void) {
    return new MyBetterStringShow2();
  }
}

using UnderscoreSample2.MyBetterStringShow2;


class UnderscoreSample2 
{

  //static function doIt <F,X>(f:F<X>) {}
  
  static function flatMap <X, Y, T>(a:Of<X, T>, f:T->Of<X,Y>, m:Monad<X>) 
   {
     return m.flatMap(a, f);
   }
  
   static function getIt <T>(t:T):T return t
   
  public static function main () 
  {
    //Hots.monoid(4);
    
    
    
    //var x = Hots.tc("Monad<Option<In>>");
   
    
    
    
   //var r = Monads.flatMap._([Some(1)].boxT(), (function (x) return [Some(x + 1)]), _ in [IntProductMonoid.get()]);
   
   var x = Monoids.append._(1,2, _ in [IntProductMonoid.get()]);
   
   var r1 = Arrows.dot._(function (x:String) return 1, function (y:Int) return "hi");
   
   trace(2.2.show._());
   trace(2.show._());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   
   trace(1.append._(2));
   
   
   Shows.show._(1);
   
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   1.show._().show._().show._(_ in new MyBetterStringShow2());
   //trace([1,2]._box(flatMap, function (x) return "foo");
   
   //var y = (r1.dot)._(function (x:String) return 5);
   
   trace(x);
   
   

  }
  
  
}
