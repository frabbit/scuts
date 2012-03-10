package hots.macros.utils;
#if macro
import haxe.macro.Context;
import scuts.mcore.extensions.TypeExt;
import scuts.mcore.Parse;
import scuts.mcore.Print;
import utest.Assert;

using scuts.core.extensions.OptionExt;
#end
#if !macro
class XXX {}
class YYY {}
#end

#if macro
class UtilsTest 
{
  static var FQ_XXX = "hots.macros.utils.UtilsTest.XXX";
  static var FQ_YYY = "hots.macros.utils.UtilsTest.YYY";
  public function new() {}
  
  public function testIsCompatibleTo () {
    
    var ot = Context.typeof(Parse.parse("{ var x:" + FQ_XXX + " = null; x;}"));
    
    var t1 = Context.typeof(Parse.parse("{ var x:Array<Array<StdTypes.Int>> = null; x;}"));
    
    var t2 = Context.typeof(Parse.parse("{ var x:Array<Array<" + FQ_XXX + ">> = null; x;}"));
    
    Assert.isTrue(Utils.typeIsCompatibleTo(t1, t2, [ot]).isSome());
    
    var t1 = Context.typeof(Parse.parse("{ var x:StdTypes.Int -> StdTypes.Int = null; x;}"));
    
    var t2 = Context.typeof(Parse.parse("{ var x:StdTypes.Int -> " + FQ_XXX + " = null; x;}"));
    
    Assert.isTrue(Utils.typeIsCompatibleTo(t1, t2, [ot]).isSome());
    
    Assert.isTrue(Utils.typeIsCompatibleTo(t1, t1, [ot]).isSome());
    Assert.isTrue(Utils.typeIsCompatibleTo(t2, t2, [ot]).isSome());
    
  }
  
  public function testIsCompatibleTo_WithMultipleTypeParams_ShouldBeNone () {
    
    var ot1 = Context.typeof(Parse.parse("{ var x:" + FQ_XXX + " = null; x;}"));
    
    var t1 = Context.typeof(Parse.parse("{ var x:Array<Array<scuts.core.types.Tup2<StdTypes.Int, String>>> = null; x;}"));
    
    var t2 = Context.typeof(Parse.parse("{ var x:Array<Array<scuts.core.types.Tup2<" + FQ_XXX + "," + FQ_XXX + ">>> = null; x;}"));
    
    Assert.isTrue(Utils.typeIsCompatibleTo(t1, t2, [ot1]).isNone());
    
  }
  
  public function testIsCompatibleTo_WithMultipleTypeParams_ShouldBeSome () {
    
    var ot1 = Context.typeof(Parse.parse("{ var x:" + FQ_XXX + " = null; x;}"));
    var ot2 = Context.typeof(Parse.parse("{ var x:" + FQ_YYY + " = null; x;}"));
    
    var t1 = Context.typeof(Parse.parse("{ var x:Array<Array<scuts.core.types.Tup2<StdTypes.Int, String>>> = null; x;}"));
    
    var t2 = Context.typeof(Parse.parse("{ var x:Array<Array<scuts.core.types.Tup2<" + FQ_XXX + "," + FQ_YYY + ">>> = null; x;}"));
    
    var res = Utils.typeIsCompatibleTo(t1, t2, [ot1, ot2]);
    trace(res);
    Assert.isTrue(res.isSome());
    
  }
  
  public function testConvertToOfType () {
    
    var expectedType = Context.typeof(Parse.parse("{ var x:hots.Of<Array<hots.In>, StdTypes.Int> = null; x;}"));
    
    var containerType = Context.typeof(Parse.parse("{ var x:Array<StdTypes.Int> = null; x;}"));
    
    var actualType = Utils.convertToOfType(containerType);

    Assert.isTrue(TypeExt.eq(expectedType, actualType));
  }
  
  public function testGetOfParts () {
    var expectedType1 = Context.typeof(Parse.parse("{ var x:Array<hots.In> = null; x;}"));
    var expectedType2 = Context.typeof(Parse.parse("{ var x:StdTypes.Int = null; x;}"));
    var ofType = Context.typeof(Parse.parse("{ var x:hots.Of<Array<hots.In>, StdTypes.Int> = null; x;}"));
    
    var actual = Utils.getOfParts(ofType);
    
    Assert.isTrue(actual.isSome());
    var tup = actual.extract();
    
    Assert.isTrue(TypeExt.eq(expectedType1, tup._1));
    Assert.isTrue(TypeExt.eq(expectedType2, tup._2));
  }
  
  public function testFlattenOfType () {
    var expectedType = Context.typeof(Parse.parse("{ var x:hots.Of<hots.Of<Array<hots.In>, Array<hots.In>>, StdTypes.Int> = null; x;}"));
    var startType = Context.typeof(Parse.parse("{ var x:hots.Of<Array<hots.In>, hots.Of<Array<hots.In>, StdTypes.Int>> = null; x;}"));
    
    var actualType = Utils.flattenOfType(startType);
    
    Assert.isTrue(TypeExt.eq(expectedType, actualType));
  }
  
  public function testReplaceContainerElemType () {
    var expectedType = Context.typeof(Parse.parse("{ var x:Array<String> = null; x;}"));
    var containerType = Context.typeof(Parse.parse("{ var x:Array<StdTypes.Int> = null; x;}"));
    var newElemType = Context.typeof(Parse.parse("{ var x:String = null; x;}"));
    
    var actualType = Utils.replaceContainerElemType(containerType, newElemType);
    
    
    Assert.isTrue(actualType.isSome());
    Assert.isTrue(TypeExt.eq(expectedType, actualType.extract()));
    
  }
 
}
#end