package scuts.mcore;
import haxe.macro.Context;
import utest.Assert;

/**
 * ...
 * @author 
 */


class ParseTest 
{

  public function new() 
  {
    
  }
  
  public function test_insert_context_integers_as_expressions_into_array() 
  {
    var s = "[$0, $1]";
    var e = Parse.parse(s, [2, 3]);
    
    var actual = Print.expr(e);
    var expected = Print.expr(Context.parse("[2,3]", Context.currentPos()));

    Assert.equals(expected, actual);
  }
  
  public function test_context_strings_as_types_into_expr() 
  {
    var s = "function a<T, S>(b:$0<T>, c:S->$1->Void):$2 { return $3;}";
    var e = Parse.parse(s, ['Array', 'Foo', 'Array<String>', ['a']]);
    
    var actual = Print.expr(e);
    var expected = 
      Print.expr(
        Context.parse("function a<T, S>(b:Array<T>, c:S->Foo->Void):Array<String> { return [\"a\"];}", Context.currentPos())
      );

    Assert.equals(expected, actual);
  }
  
  public function test_anonymous_object_field_type() 
  {
    
    var s = "{ a : $0 }";
    var e = Parse.parse(s, [Context.getType("String")]);
    var actual = Print.expr(e);
    var expected = 
      Print.expr(
        Context.parse("{\n\ta : String\n}", Context.currentPos())
      );

    Assert.equals(expected, actual);
  }
  
  public function test_optional_field_in_anonymous_type () 
  {
    var s = "{var u:{ @:optional var x: $0;};}";
    var e = Parse.parse(s, ["String"]);
    var actual = Print.expr(e);
    var expected = 
      Print.expr(
        Context.parse("{\n\tvar u: {\n\t\t@:optional var x : String;\n\t}\n}", Context.currentPos())
      );

    Assert.equals(expected, actual);
  }
  
  public function test_type_in_parenthesis () 
  {
    var s = "{var u:{ x: ($0)};}";
    var e = Parse.parse(s, ["String"]);
    var actual = Print.expr(e);
    
    var expected = 
      Print.expr(
        Context.parse("{\n\tvar u: {\n\t\tx : (String)\n\t}\n}", Context.currentPos())
      );

    Assert.equals(expected, actual);
  }
  
  public function test_complex_anonymous_type_def () 
  {
    var s = "{var u:{ x: $0->Int, y: Int->$1 };}";
    var e = Parse.parse(s, ["Void", "Array<String>"]);
    var actual = Print.expr(e);
    
    var expected = 
      Print.expr(
        Context.parse("{\n\tvar u: {\n\t\tx : Void -> Int,\n\t\ty:Int->Array<String>\n\t}\n}", Context.currentPos())
      );

    Assert.equals(expected, actual);
  }
  
  public function test_anonymous_type_def_with_super_type () 
  {
    var s = "{var u:{ > $0, x:Int}}";
    
    var e = Parse.parse(s, ["BaseType"]);
    
    var actual = Print.expr(e);
    
    var expected = 
      Print.expr(
        Context.parse("{\n\tvar u: {\n\t\t > BaseType,\n\t\tx:Int\n\t}\n}", Context.currentPos())
      );

    Assert.equals(expected, actual);
  }
  
  public function test_simple_anonymous_type_def () 
  {
    var s = "{var u:{ a : $0 };}";
    
    var e = Parse.parse(s, ["Array<String>"]);
    
    var actual = Print.expr(e);
    
    var expected = 
      Print.expr(
        Context.parse("{\n\tvar u: {\n\t\ta : Array<String>\n\t}\n}", Context.currentPos())
      );

    Assert.equals(expected, actual);
  }
  
  public function test_function_with_optional_expression() 
  {
    var s = "function a (b = $0):Void { }";
    
    var e = Parse.parse(s, [5]);
    
    var actual = Print.expr(e);
    var expected = Print.expr(
      Context.parse("function a (b = 5):Void {}", Context.currentPos()));

    Assert.equals(expected, actual);
  }
  
  public function test_for_in() 
  {
    var s = "for (i in $0...$1) {}";
    
    var e = Parse.parse(s, [0, 5]);
    
    var actual = Print.expr(e);
    var expected = Print.expr(
      Context.parse("for (i in 0...5) {}", Context.currentPos()));

    Assert.equals(expected, actual);
  }
  
  public function test_switch_with_2_cases() 
  {
    var s = "switch ($0) { case A: $1; case B: $2;}";
    
    var e = Parse.parse(s, [Make.constIdent("a"), 0, 5]);
    
    var actual = Print.expr(e);
    var expected = 
      Print.expr(
        Context.parse("switch (a) {\n\tcase A: 0;\n\tcase B: 5;\n}", Context.currentPos())
      );

    Assert.equals(expected, actual);
  }
  
  public function test_switch_with_only_default() 
  {
    var s = "switch (a) { default: $0;}";
    
    var e = Parse.parse(s, [5]);
    
    var actual = Print.expr(e);
    var expected = 
      Print.expr(
        Context.parse("switch (a) {\n\tdefault: 5;\n}", Context.currentPos())
      );

    Assert.equals(expected, actual);
  }
  
  public function test_switch_with_case_and_default() 
  {
    var s = "switch (a) { case A: $0; default: $1;}";
    
    var e = Parse.parse(s, [0,1]);
    
    var actual = Print.expr(e);
    var expected = 
      Print.expr(
        Context.parse("switch (a) {\n\tcase A: 0;\n\tdefault: 1;\n}", Context.currentPos())
      );

    Assert.equals(expected, actual);
  }
  
  public function test_switch_with_case_expr() 
  {
    var s = "switch (a) { case $0 > $1: 0; }";
    
    var e = Parse.parse(s, [5,3]);
    
    var actual = Print.expr(e);
    var expected = 
      Print.expr(
        Context.parse("switch (a) {\n\tcase 5 > 3: 0;\n}", Context.currentPos())
      );

    Assert.equals(expected, actual);
  }
  
  public function test_switch_with_case_type() 
  {
    var s = "switch (a) { case $0: 0; }";
    
    var e = Parse.parse(s, [Context.getType("String")]);
    
    var actual = Print.expr(e);
    var expected = 
      Print.expr(
        Context.parse("switch (a) {\n\tcase String: 0;\n}", Context.currentPos())
      );

    Assert.equals(expected, actual);
  }
  
  public function test_while_with_body() 
  {
    var s = "while ($0 > $1) { $2; }";
    
    var e = Parse.parse(s, [1,2,3]);
    
    var actual = Print.expr(e);
    var expected = 
      Print.expr(
        Context.parse("while (1 > 2) {\n\t3;\n}", Context.currentPos())
      );

    Assert.equals(expected, actual);
  }
  
  public function test_while_without_body() 
  {
    var s = "while ($0 > $1) {  }";
    
    var e = Parse.parse(s, [1,2,3]);
    
    var actual = Print.expr(e);
    var expected = 
      Print.expr(
        Context.parse("while (1 > 2) {}", Context.currentPos())
      );

    Assert.equals(expected, actual);
  }
  public function test_do_while_with_body() 
  {
    var s = "do { $2; } while ($0 > $1)";
    
    var e = Parse.parse(s, [1,2,3]);
    
    var actual = Print.expr(e);
    var expected = 
      Print.expr(
        Context.parse("do {\n\t3;\n} while (1 > 2)", Context.currentPos())
      );

    Assert.equals(expected, actual);
  }
  
  public function test_do_while_without_body() 
  {
    var s = "do {} while ($0 > $1)";
    
    var e = Parse.parse(s, [1,2]);
    
    var actual = Print.expr(e);
    var expected = 
      Print.expr(
        Context.parse("do {} while (1 > 2)", Context.currentPos())
      );

    Assert.equals(expected, actual);
  }
  
}