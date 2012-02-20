package scuts.mcore;

import haxe.macro.Context;
import haxe.macro.Expr;
import scuts.mcore.Type;
import scuts.Scuts;
import utest.Assert;


class TypeTest 
{

  public function new() 
  {
    
  }
  
  private function getType(t:String):ComplexType
  {
    var str = '{
      var a:' + t + ' = null;
    }';
    var e = Context.parse(str, Context.currentPos());
    
    return switch (e.expr) {
      case EBlock(b):
        switch (b[0].expr) {
          case EVars(vars):
            vars[0].type;
          default: Scuts.error("Assert");
        }
      default: Scuts.error("Assert");
    }
  }
  
  public function testIsSuperTypeOf () 
  {
    var arrayType = getType("Array<StdTypes.Int>");
    var iterType = getType("StdTypes.Iterable<StdTypes.Int>");
    
    
    Assert.isTrue(Type.isSupertypeOf(iterType, arrayType));
    Assert.isFalse(Type.isSupertypeOf(arrayType, iterType));
  }
  
  public function testIsSubtypeOf () 
  {
    var arrayType = getType("Array<StdTypes.Int>");
    var iterType = getType("StdTypes.Iterable<StdTypes.Int>");
    
    Assert.isTrue(Type.isSubtypeOf(arrayType, iterType));
    Assert.isFalse(Type.isSubtypeOf(iterType, arrayType));
  }
  
  public function testIsSubtypeOf_forSameType () 
  {
    var arrayType = getType("Array<StdTypes.Int>");
    
    Assert.isFalse(Type.isSubtypeOf(arrayType, arrayType));
  }
  
  public function testIsSupertypeOf_forSameType () 
  {
    var arrayType = getType("Array<StdTypes.Int>");
    
    Assert.isFalse(Type.isSupertypeOf(arrayType, arrayType));
  }
  
}