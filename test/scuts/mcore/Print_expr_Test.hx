package scuts.mcore;

#if macro
import haxe.macro.Expr;
import scuts.Scuts;
#end

@:macro private class Helper {
  public static function getStringExpr (expr:Expr, indent:Int = 0, indentStr:String = "\t") {
    
    return { expr:EConst(CString(Print.expr(expr, indent, indentStr))), pos:expr.pos };
  }
}
#if !macro

import utest.Assert;

class Print_expr_Test
{

  public function new() {}
  
  public function test_anonymous() 
  {
    var expected = "{\n\tx:5\n}";
    var actual = Helper.getStringExpr( { x:5 } );
    Assert.equals(expected, actual);
  }
  
  public function test_var_with_full_qualified_arg_and_long_package() 
  {
    var expected = "{\n\tvar a:pack.to.foo.MyClass;\n}";
    var actual = Helper.getStringExpr( { var a : pack.to.foo.MyClass; } );
    Assert.equals(expected, actual);
  }
  
  public function test_call() 
  {
    var expected = "foo()";
    var actual = Helper.getStringExpr( foo() );
    Assert.equals(expected, actual);
  }
  
  
  public function test_call_with_args() 
  {
    var expected = "foo(1, a)";
    var actual = Helper.getStringExpr( foo(1, a) );
    Assert.equals(expected, actual);
  }
  
  public function test_field_call_with_args() 
  {
    var expected = "a.foo(1, a)";
    var actual = Helper.getStringExpr( a.foo(1, a) );
    Assert.equals(expected, actual);
  }
  
  public function test_field() 
  {
    var expected = "a.foo";
    var actual = Helper.getStringExpr( a.foo );
    Assert.equals(expected, actual);
  }
  
  public function test_function() 
  {
    var expected = "function () {}";
    var actual = Helper.getStringExpr( function () {} );
    Assert.equals(expected, actual);
  }
  
  public function test_function_with_optional_arg() 
  {
    var expected = "function (?a) {}";
    var actual = Helper.getStringExpr( function (?a) {} );
    Assert.equals(expected, actual);
  }
  
  public function test_named_function() 
  {
    var expected = "function f () {}";
    var actual = Helper.getStringExpr( function f() {} );
    Assert.equals(expected, actual);
  }
  
  public function test_function_with_arg_having_typeParameter() 
  {
    var expected = "function <T> (a:T) {}";
    var actual = Helper.getStringExpr( function <T>(a:T) {} );
    Assert.equals(expected, actual);
  }
  
  public function test_function_with_arg_having_full_qualified_type() 
  {
    var expected = "function (a:pack.MyClass) {}";
    var actual = Helper.getStringExpr( function (a:pack.MyClass) {} );
    Assert.equals(expected, actual);
  }
  
  public function test_function_with_arg_having_full_qualified_typeParameter() 
  {
    var expected = "function (a:Array<pack.MyClass>) {}";
    var actual = Helper.getStringExpr( function (a:Array<pack.MyClass>) { } );
    Assert.equals(expected, actual);
  }
  
  public function test_named_function_with_arg_having_full_qualified_typeParameter() 
  {
    var expected = "function f (a:Array<pack.MyClass>) {}";
    var actual = Helper.getStringExpr( function f (a:Array<pack.MyClass>) { } );
    Assert.equals(expected, actual);
  }
  
  public function test_function_with_full_qualified_arg_having_full_qualified_typeParameter() 
  {
    var expected = "function (a:my.Array<pack.MyClass>) {}";
    var actual = Helper.getStringExpr( function (a:my.Array<pack.MyClass>) { } );
    Assert.equals(expected, actual);
  }
  
 
  
  public function test_function_with_arg_having_full_qualified_inner_module_type_with_pack() 
  {
    var expected = "function (a:pack.MyModule.MyClass) {}";
    var actual = Helper.getStringExpr( function (a:pack.MyModule.MyClass) { } );
    Assert.equals(expected, actual);
  }
  
  public function test_function_with_arg_having_full_qualified_inner_module_type_without_pack() 
  {
    var expected = "function (a:MyModule.MyClass) {}";
    var actual = Helper.getStringExpr( function (a:MyModule.MyClass) { } );
    Assert.equals(expected, actual);
  }
  
  public function test_function_with_arg_having_full_qualified_inner_module_typeParameter_with_pack() 
  {
    var expected = "function (a:Array<pack.MyModule.MyClass>) {}";
    var actual = Helper.getStringExpr( function (a:Array<pack.MyModule.MyClass>) { } );
    Assert.equals(expected, actual);
  }
  
  public function test_function_with_arg_having_full_qualified_inner_module_typeParameter_without_pack() 
  {
    var expected = "function (a:Array<MyModule.MyClass>) {}";
    var actual = Helper.getStringExpr( function (a:Array<MyModule.MyClass>) { } );
    Assert.equals(expected, actual);
  }
  
  public function test_function_with_arg_having_full_qualified_inner_module_typeParameter_without_pack_and_arg_with_function_type_parameter() 
  {
    var expected = "function <T> (a:Array<MyModule.MyClass>, b:T) {}";
    var actual = Helper.getStringExpr( function <T>(a:Array<MyModule.MyClass>, b:T) { } );
    Assert.equals(expected, actual);
  }
  
  public function test_function_with_arg_having_multiple_nested_full_qualified_typeParameters_and_function_type_parameter() 
  {
    var expected = "function <T> (a:Array<MyModule.MyClass<MySuperMod.Dup<Hello, Sub<T>>, AnotherType<T>>, OtherType>) {}";
    var actual = Helper.getStringExpr( function <T> (a:Array<MyModule.MyClass<MySuperMod.Dup<Hello, Sub<T>>, AnotherType<T>>, OtherType>) {} );
    Assert.equals(expected, actual);
  }
  
  public function test_function_with_full_qualified_arg_having_full_qualified_typeParameter_and_function_typeParameter() 
  {
    var expected = "function <T> (a:my.Tuple<haxe.macro.Expr, T>) {}";
    var actual = Helper.getStringExpr( function <T> (a:my.Tuple<haxe.macro.Expr, T>) { } );
    Assert.equals(expected, actual);
  }
  
  public function test_try_catch() 
  {
    var expected = "try {\n\t1;\n} catch (e:Dynamic) {\n\t2;\n}";
    var actual = Helper.getStringExpr( try { 1; } catch (e:Dynamic) { 2; } );
    Assert.equals(expected, actual);
  }
  
  public function test_try_catch_without_indent() 
  {
    var expected = "try {\n1;\n} catch (e:Dynamic) {\n2;\n}";
    var actual = Helper.getStringExpr( try { 1; } catch (e:Dynamic) { 2; }, 0, "" );
    Assert.equals(expected, actual);
  }
  
  public function test_try_catch_with_indent_of_2() 
  {
    var expected = "\t\ttry {\n\t\t\t1;\n\t\t} catch (e:Dynamic) {\n\t\t\t2;\n\t\t}";
    var actual = Helper.getStringExpr( try { 1; } catch (e:Dynamic) { 2; }, 2 );
    Assert.equals(expected, actual);
  }
  
  public function test_ternary_operator() 
  {
    var expected = "true ? 1 : 2";
    var actual = Helper.getStringExpr( true ? 1 : 2 );
    Assert.equals(expected, actual);
  }
  
  public function test_increment_operator() 
  {
    var expected = "i++";
    var actual = Helper.getStringExpr( i++ );
    Assert.equals(expected, actual);
  }
  
  public function test_decrement_operator() 
  {
    var expected = "i--";
    var actual = Helper.getStringExpr( i-- );
    Assert.equals(expected, actual);
  }
  
  public function test_binary_operator_plus() 
  {
    var expected = "1 + 2";
    var actual = Helper.getStringExpr( 1 + 2 );
    Assert.equals(expected, actual);
  }
  
  public function test_binary_operator_minus() 
  {
    var expected = "1 - 2";
    var actual = Helper.getStringExpr( 1 - 2 );
    Assert.equals(expected, actual);
  }
  
  public function test_binary_operator_divide() 
  {
    var expected = "1 / 2";
    var actual = Helper.getStringExpr( 1 / 2 );
    Assert.equals(expected, actual);
  }
  
  public function test_binary_operator_multiply() 
  {
    var expected = "1 * 2";
    var actual = Helper.getStringExpr( 1 * 2 );
    Assert.equals(expected, actual);
  }
  public function test_binary_operator_binary_and() 
  {
    var expected = "1 & 2";
    var actual = Helper.getStringExpr( 1 & 2 );
    Assert.equals(expected, actual);
  }
  
  public function test_binary_operator_binary_or() 
  {
    var expected = "1 | 2";
    var actual = Helper.getStringExpr( 1 | 2 );
    Assert.equals(expected, actual);
  }
  
  public function test_binary_operator_binary_left_shift() 
  {
    var expected = "1 << 2";
    var actual = Helper.getStringExpr( 1 << 2 );
    Assert.equals(expected, actual);
  }
  
  public function test_binary_operator_binary_right_shift() 
  {
    var expected = "1 >> 2";
    var actual = Helper.getStringExpr( 1 >> 2 );
    Assert.equals(expected, actual);
  }
  
  public function test_binary_assign_operator_plus() 
  {
    var expected = "1 += 2";
    var actual = Helper.getStringExpr( 1 += 2 );
    Assert.equals(expected, actual);
  }
  
  public function test_binary_assign_operator_minus() 
  {
    var expected = "1 -= 2";
    var actual = Helper.getStringExpr( 1 -= 2 );
    Assert.equals(expected, actual);
  }
  
  public function test_binary_assign_operator_binary_and() 
  {
    var expected = "1 &= 2";
    var actual = Helper.getStringExpr( 1 &= 2 );
    Assert.equals(expected, actual);
  }
  
  public function test_binary_assign_operator_binary_or() 
  {
    var expected = "1 |= 2";
    var actual = Helper.getStringExpr( 1 |= 2 );
    Assert.equals(expected, actual);
  }
  
  public function test_unary_not() 
  {
    var expected = "!1";
    var actual = Helper.getStringExpr( !1 );
    Assert.equals(expected, actual);
  }
  
  public function test_binary_op_and() 
  {
    var expected = "a && b";
    var actual = Helper.getStringExpr( a && b );
    Assert.equals(expected, actual);
  }
  public function test_binary_op_or() 
  {
    var expected = "a || b";
    var actual = Helper.getStringExpr( a || b );
    Assert.equals(expected, actual);
  }
  
  public function test_binary_op_not_equals() 
  {
    var expected = "a != b";
    var actual = Helper.getStringExpr( a != b );
    Assert.equals(expected, actual);
  }
  
  public function test_binary_op_equals() 
  {
    var expected = "a == b";
    var actual = Helper.getStringExpr( a == b );
    Assert.equals(expected, actual);
  }
  
  public function test_binary_op_bigger_or_equals() 
  {
    var expected = "a >= b";
    var actual = Helper.getStringExpr( a >= b );
    Assert.equals(expected, actual);
  }
  
  public function test_binary_op_bigger() 
  {
    var expected = "a > b";
    var actual = Helper.getStringExpr( a > b );
    Assert.equals(expected, actual);
  }
  
  public function test_binary_op_less_or_equals() 
  {
    var expected = "a <= b";
    var actual = Helper.getStringExpr( a <= b );
    Assert.equals(expected, actual);
  }
  
  public function test_binary_op_less() 
  {
    var expected = "a < b";
    var actual = Helper.getStringExpr( a < b );
    Assert.equals(expected, actual);
  }
  
  public function test_for_in() 
  {
    var expected = "for (i in a) {}";
    var actual = Helper.getStringExpr( for (i in a) {});
    Assert.equals(expected, actual);
  }
  
  public function test_in() 
  {
    var expected = "i in a";
    var actual = Helper.getStringExpr( i in a );
    Assert.equals(expected, actual);
  }
  
  public function test_block_empty() 
  {
    var expected = "{}";
    var actual = Helper.getStringExpr({});
    Assert.equals(expected, actual);
  }
  
  public function test_block_with_one_expr() 
  {
    var expected = "{\n\t5;\n}";
    var actual = Helper.getStringExpr( { 5; } );
    Assert.equals(expected, actual);
  }
  
  public function test_break() 
  {
    var expected = "break";
    var actual = Helper.getStringExpr( break );
    Assert.equals(expected, actual);
  }
  
  public function test_continue() 
  {
    var expected = "continue";
    var actual = Helper.getStringExpr( continue );
    Assert.equals(expected, actual);
  }
  
  public function test_new() 
  {
    var expected = "new MyClass()";
    var actual = Helper.getStringExpr( new MyClass() );
    Assert.equals(expected, actual);
  }
  
  public function test_new_with_args() 
  {
    var expected = "new MyClass(a, b)";
    var actual = Helper.getStringExpr( new MyClass(a, b) );
    Assert.equals(expected, actual);
  }
  
  public function test_new_with_full_qualified_type_name() 
  {
    var expected = "new de.pack.MyClass(a, b)";
    var actual = Helper.getStringExpr( new de.pack.MyClass(a, b) );
    Assert.equals(expected, actual);
  }
  
  public function test_new_with_full_qualified_type_name_inside_module() 
  {
    var expected = "new de.pack.MyModule.MyClass(a, b)";
    var actual = Helper.getStringExpr( new de.pack.MyModule.MyClass(a, b) );
    Assert.equals(expected, actual);
  }
  
  public function test_new_with_qualified_type_name_inside_root_module() 
  {
    var expected = "new MyModule.MyClass(a, b)";
    var actual = Helper.getStringExpr( new MyModule.MyClass(a, b) );
    Assert.equals(expected, actual);
  }
  
  public function test_new_with_type_parameter() 
  {
    var expected = "new MyClass<String>(a, b)";
    var actual = Helper.getStringExpr( new MyClass<String>(a, b) );
    Assert.equals(expected, actual);
  }
  
  public function test_new_with_multiple_type_parameters() 
  {
    var expected = "new MyClass<String, Int>(a, b)";
    var actual = Helper.getStringExpr( new MyClass<String, Int>(a, b) );
    Assert.equals(expected, actual);
  }
  
  public function test_new_with_nested_type_parameters() 
  {
    var expected = "new MyClass<Array<String>>(a, b)";
    var actual = Helper.getStringExpr( new MyClass<Array<String>>(a, b) );
    Assert.equals(expected, actual);
  }
  
  public function test_type() 
  {
    var expected = "MyClass";
    var actual = Helper.getStringExpr( MyClass );
    Assert.equals(expected, actual);
  }
  
  public function test_type_with_pack() 
  {
    var expected = "pack.MyClass";
    var actual = Helper.getStringExpr( pack.MyClass );
    Assert.equals(expected, actual);
  }
  
  
  
  
  public function test_type_with_subtype_of_root_module() 
  {
    var expected = "Module.MyClass";
    var actual = Helper.getStringExpr( Module.MyClass );
    Assert.equals(expected, actual);
  }
  
  public function test_type_with_subtype_of_root_module_and_package() 
  {
    var expected = "pack.Module.MyClass";
    var actual = Helper.getStringExpr( pack.Module.MyClass );
    Assert.equals(expected, actual);
  }
  
  public function test_if_without_else() 
  {
    var expected = "if (true) doIt()";
    var actual = Helper.getStringExpr( if (true) doIt() );
    Assert.equals(expected, actual);
  }
  
  public function test_if_with_else() 
  {
    var expected = "if (true) doIt() else foo()";
    var actual = Helper.getStringExpr( if (true) doIt() else foo() );
    Assert.equals(expected, actual);
  }
  
  public function test_switch() 
  {
    var expected = "switch (a) {\n\tcase Case1:\n\t\ttrue;\n}";
    var actual = Helper.getStringExpr( switch (a) {case Case1: true;} );
    Assert.equals(expected, actual);
  }
  
  public function test_switch_case_without_expr() 
  {
    var expected = "switch (a) {\n\tcase Case1:\n}";
    var actual = Helper.getStringExpr( switch (a) {case Case1:} );
    Assert.equals(expected, actual);
  }
  
  public function test_switch_with_2_cases_without_expr() 
  {
    var expected = "switch (a) {\n\tcase Case1:\n\tcase Case2:\n}";
    var actual = Helper.getStringExpr( switch (a) {case Case1: case Case2:} );
    Assert.equals(expected, actual);
  }
  
  public function test_switch_with_default() 
  {
    var expected = "switch (a) {\n\tcase Case1:\n\tdefault:\n}";
    var actual = Helper.getStringExpr( switch (a) {case Case1: default: } );
    Assert.equals(expected, actual);
  }
  
  public function test_switch_default_without_expr() 
  {
    var expected = "switch (a) {\n\tdefault:\n}";
    var actual = Helper.getStringExpr( switch (a) { default: } );
    Assert.equals(expected, actual);
  }
  
  public function test_switch_multiple_cases_and_default() 
  {
    var expected = "switch (a) {\n\tcase C1:\n\tcase C2:\n\tdefault:\n}";
    var actual = Helper.getStringExpr( switch (a) { case C1: case C2: default: } );
    Assert.equals(expected, actual);
  }
  
  
  
}
#end