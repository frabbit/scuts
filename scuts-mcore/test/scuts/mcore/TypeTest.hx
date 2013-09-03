package scuts.mcore;

import haxe.macro.Context;
import haxe.macro.Expr;

import scuts.mcore.ast.ComplexTypes;
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
    
    
    Assert.isTrue(ComplexTypes.isSupertypeOf(iterType, arrayType));
    Assert.isFalse(ComplexTypes.isSupertypeOf(arrayType, iterType));
  }
  
  public function testIsSubtypeOf () 
  {
    var arrayType = getType("Array<StdTypes.Int>");
    var iterType = getType("StdTypes.Iterable<StdTypes.Int>");
    
    Assert.isTrue(ComplexTypes.isSubtypeOf(arrayType, iterType));
    Assert.isFalse(ComplexTypes.isSubtypeOf(iterType, arrayType));
  }
  
  public function testIsSubtypeOf_forSameType () 
  {
    var arrayType = getType("Array<StdTypes.Int>");
    
    Assert.isFalse(ComplexTypes.isSubtypeOf(arrayType, arrayType));
  }
  
  public function testIsSupertypeOf_forSameType () 
  {
    var arrayType = getType("Array<StdTypes.Int>");
    
    Assert.isFalse(ComplexTypes.isSupertypeOf(arrayType, arrayType));
  }
  
}