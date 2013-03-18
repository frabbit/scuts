package scuts.mcore;

import haxe.macro.Context;
import haxe.macro.Expr;
import utest.Assert;

class CheckTest
{

  public function new() {}
  
  public function test_isConstantExpr_Int () 
  {
    var e = Context.parse("1", Context.currentPos());
    
    Assert.isTrue(Check.isConstantExpr(e));
  }
  
  public function test_isConstantExpr_String () 
  {
    var e = Context.parse("'1'", Context.currentPos());
    
    Assert.isTrue(Check.isConstantExpr(e));
  }
  
  public function test_isConstantExpr_Float () 
  {
    var e = Context.parse("1.0", Context.currentPos());
    
    Assert.isTrue(Check.isConstantExpr(e));
  }
  
  public function test_isConstantExpr_Anon () 
  {
    var e = Context.parse("{a:1, b:2.0, c: \"hi\"}", Context.currentPos());
    
    Assert.isTrue(Check.isConstantExpr(e));
  }
  
  public function test_isConstantExpr_Array_Int () 
  {
    var e = Context.parse("[1,2,3]", Context.currentPos());
    
    Assert.isTrue(Check.isConstantExpr(e));
  }
  
  public function test_isConstantExpr_Nested () 
  {
    var e = Context.parse("{ a: [1,2,3], b: {c : { a:[1.0, 2.0]}, d:'hello'}}", Context.currentPos());
    
    Assert.isTrue(Check.isConstantExpr(e));
  }
  
  public function test_isConstantTypeDecl_Nested () {
    var type = Convert.stringToComplexType("Array<{ a : Int }>");
    Assert.isTrue(Check.isConstantTypeDecl(type));
  }
  
  public function test_isConstantTypeDecl_Nested2 () {
    var type = Convert.stringToComplexType("Array<{ a : Array<{b:String, c:Float, d:Int, f:Array<String>}> }>");
    Assert.isTrue(Check.isConstantTypeDecl(type));
  }
  
}
