package scuts.mcore;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using scuts.core.Options;
import scuts.Scuts;
#end

import utest.Assert;

private class Helper {
  
  macro public static function getStringType (expr:Expr, ?simpleSignatures:Bool = false) {
    
    var t = MCore.typeof(expr);
    
    var type = t.getOrError("Error cannot get type of expression " + expr);
    
    return { expr:EConst(CString(Print.type(type, simpleSignatures))), pos:expr.pos };
  }
}
#if !macro

class Print_type_Test<Z>
{

  public function new() {}
  
  public function testFunctionTypeParameterShouldEqualX<X>() 
  {
    var a:X;
    var expected = "X";
    var actual = Helper.getStringType( a );
    Assert.equals(expected, actual);
  }
  
  public function testClassTypeParameterShouldEqualZ() 
  {
    var a:Z;
    var expected = "Z";
    var actual = Helper.getStringType( a );
    Assert.equals(expected, actual);
  }
  
  public function testStdTypesShouldBePrintedWithoutModule() 
  {
    var a:Int;
    var expected = "StdTypes.Int";
    var actual = Helper.getStringType( a );
    Assert.equals(expected, actual);
  }
  
  public function testAnonymousObjectFieldsShouldBePrintedCorrectly() 
  {
    var a:{ x: String, i:Int}; // fields gets sorted from the compiler alphabetical
    var expected = "{ var i : StdTypes.Int; var x : String; }";
    var actual = Helper.getStringType( a );
    Assert.equals(expected, actual);
  }
  
  
  public function testFunctionsWithStdTypesShouldBePrintedWithoutThem() 
  {
    var a:Int->String; 
    var expected = "StdTypes.Int -> String";
    var actual = Helper.getStringType( a );
    Assert.equals(expected, actual);
  }
  
  public function test_with_functions2() 
  {
    function a (hi:String):Void {};
    
    var expected = "hi : String -> StdTypes.Void";
    var actual = Helper.getStringType( a );
    Assert.equals(expected, actual);
  }
  
  public function test_with_functionsAndParenthesis() 
  {
    var a:(String -> String) -> String;
    
    var expected = "(String -> String) -> String";
    var actual = Helper.getStringType( a );
    Assert.equals(expected, actual);
  }
  
  public function test_with_functions_and_parenthesis_around_return_type() 
  {
    var a:String -> (String -> String);
    
    var expected = "String -> (String -> String)";
    var actual = Helper.getStringType( a );
    Assert.equals(expected, actual);
  }
  
  public function test_with_functions2_simple_signatures() 
  {
    function a (hi:String):Void {};
    
    var expected = "String -> StdTypes.Void";
    var actual = Helper.getStringType( a, true );
    Assert.equals(expected, actual);
  }
  
  public function test_with_container_types() 
  {
    var a: Array<String>;
    
    var expected = "Array<String>";
    var actual = Helper.getStringType( a );
    Assert.equals(expected, actual);
  }
  
  
  
}
#end