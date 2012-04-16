package ;

import haxe.macro.MacroType;
import hots.classes.Collection;
import hots.classes.Eq;
import hots.classes.Foldable;
import hots.classes.Monoid;
import hots.instances.IntProductMonoid;

import hots.Of;
import hots.instances.OptionMonoid;
import hots.instances.OptionSemigroup;
import hots.instances.ArrayMonoid;
import hots.instances.ArraySemigroup;
import hots.instances.Tup2Monoid;
import hots.instances.StringMonoid;
import hots.instances.StringSemigroup;
import hots.instances.IntSumMonoid;
import hots.instances.IntSumSemigroup;

import hots.instances.StringEq;



import scuts.core.types.Tup2;

using hots.macros.TcContext;
using hots.macros.Box;

import scuts.core.types.Option;

enum MyEnum {
  Password(s:String);
  User(s:String);
  Rec(a:MyEnum);  
}

typedef MyEnumEq = MacroType<[ hots.macros.GenEq.forType(MyEnum) ]>

class GenEqSample 
{

  
  
  public static function main () 
  {
    {
      var a = Password("foo");
      var b = Password("bar");
      var c = Password("foo");
      var d = User("test");
      var e = User("test2");
      var f = Rec(a);
      var g = Rec(c);
      
      var eq = a.tc(Eq);
      
      trace(eq.eq(a,b));
      trace(eq.eq(a,c));
      trace(eq.eq(d,a));
      trace(eq.eq(f,g));
      
      
    }
    
    
    
  }
  
  
}


