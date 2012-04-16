package hots.macros.utils;
#if (macro || display)
import haxe.macro.Context;
import scuts.core.extensions.Arrays;
import scuts.core.extensions.Options;
import scuts.core.extensions.Strings;
import scuts.core.extensions.Tup2s;
import scuts.core.types.Tup2;
import scuts.mcore.MContext;
import scuts.mcore.extensions.TypeExt;
import scuts.mcore.Parse;
import scuts.mcore.Print;
import scuts.Scuts;
import utest.Assert;
import scuts.core.types.Option;
using scuts.core.extensions.Options;
import hots.macros.utils.Utils;
using scuts.core.extensions.Dynamics;
using scuts.core.extensions.Functions;
#end
#if !macro
class XXX {}
class YYY {}
interface D {}
interface E {}
interface C implements D, implements E {}
class S implements C {}
class U extends S{}

interface V<T> {}

class Z implements V<Int> {}


class Q<K, TT> implements V<TT> {}

class Z2<K> extends Q<Int, K> {}

#end

#if (macro || display)
class UtilsTest 
{
  static var FQ_XXX = "hots.macros.utils.UtilsTest.XXX";
  static var FQ_YYY = "hots.macros.utils.UtilsTest.YYY";
  static var FQ_U = "hots.macros.utils.UtilsTest.U";
  static var FQ_S = "hots.macros.utils.UtilsTest.S";
  static var FQ_C = "hots.macros.utils.UtilsTest.C";
  static var FQ_D = "hots.macros.utils.UtilsTest.D";
  static var FQ_Z = "hots.macros.utils.UtilsTest.Z";
  static var FQ_Z2 = "hots.macros.utils.UtilsTest.Z2";
  static var FQ_V = "hots.macros.utils.UtilsTest.V";
  public function new() {}
  
  
  public function testRemap () 
  {
    var t = MContext.getType(FQ_V).getOrError("Cannot get type of " + FQ_V);
    
    var ct = TypeExt.asClassType(t).getOrError("Cannot convert to Class Type");
    
    var paramsCur = ct._2[0];
    var paramsNew = MContext.getType(FQ_XXX).getOrError("Cannot get type " + FQ_XXX);
    
    var mapping = [Tup2.create(paramsCur, paramsNew)];

    var actual = Utils.remap(t, mapping);
    var expected = Context.typeof(Parse.parse("{ var x:hots.macros.utils.UtilsTest.V<" + FQ_XXX + "> = null; x;}"));
    
    Assert.isTrue(TypeExt.eq(actual, expected));
  }
  
  public function testRemap2 () 
  {
    
    var t = MContext.getType(FQ_V).getOrError("Cannot get type of " + FQ_V); // V<T>
    
    var ct = TypeExt.asClassType(t).getOrError("Cannot convert to Class Type"); // XXX
    
    var paramsCur = ct._2[0]; // T 
    var paramsNew = MContext.getType(FQ_XXX).getOrError("Cannot get type " + FQ_XXX); // XXX
    
    var mapping = [Tup2.create(paramsCur, paramsNew)];

    var actual = Utils.remap(t, mapping); // shoulb be V<XXX>
    var expected = Parse.parseToType(FQ_V + "<" + FQ_XXX + ">").getOrError("Parse To Type Fails");
    
    Assert.isTrue(TypeExt.eq(actual, expected));
  }

  public function testGetParamsAsTypes () 
  {
    var paramsOption = MContext.getType(FQ_V).flatMap(
      function (t) return TypeExt.asClassType(t).map(
        function (x) return Utils.getParamsAsTypes(x._1.get())
      )
    );
    
    Assert.isTrue(paramsOption.isSome());
  }
  
  public function testGetTypeParamMappings () {
    
    trace(MContext.getType("hots.macros.utils.UtilsTest.V"));
    var t1 = 
      TypeExt.asClassType(MContext.getType(FQ_V).extract())
      .map(function (x) return x._1.get()).extract();
      
    var t2 = 
      TypeExt.asClassType(Parse.parseToType(FQ_Z).extract())
      .map(function (x) return x._1.get()).extract();
      
    var param1 = Utils.getParamsAsTypes(t1)[0];
    var expected = Some([Tup2.create(MContext.getType("StdTypes.Int").extract(), param1)]);
    var actual = Utils.getTypeParamMappings(t2, t1);
    
    var mappingEq = function (a,b) return Options.eq(a,b, 
      function (a,b) return Arrays.eq(a,b, function (a,b) return Tup2s.eq(a,b, TypeExt.eq, TypeExt.eq)));
    
    Assert.isTrue(mappingEq(actual, expected));
  }
  
  public function testGetTypeParamMappings2 () {
    
    trace(MContext.getType("hots.macros.utils.UtilsTest.V"));
    var t1 = 
      TypeExt.asClassType(MContext.getType(FQ_V).extract())
      .map(function (x) return x._1.get()).extract();
      
    var t2 = 
      TypeExt.asClassType(MContext.getType(FQ_Z2).extract())
      .map(function (x) return x._1.get()).extract();
    
    // expected K -> V.T
    var t_K = t2.superClass.params[1];
    var t_TT = t2.superClass.t.get().interfaces[0].params[0];
    var t_T = Utils.getParamsAsTypes(t1)[0];
    var expected = Some([Tup2.create(t_K, t_T)]);
    var actual = Utils.getTypeParamMappings(t2, t1);
    
    var mappingEq = function (a,b) return Options.eq(a,b, 
      function (a,b) return Arrays.eq(a,b, function (a,b) return Tup2s.eq(a,b, TypeExt.eq, TypeExt.eq)));
      
    
    Assert.isTrue(mappingEq(actual, expected));
  }
  
  public function testGetFirstPath () {
    var t1 = 
      TypeExt.asClassType(Parse.parseToType(FQ_U).extract())
      .map(function (x) return x._1.get()).extract();
      
    var t2 = 
      TypeExt.asClassType(Parse.parseToType(FQ_U).extract())
      .map(function (x) return x._1.get()).extract();
    
    
    var expected = Some([]);
    var actual = Utils.getFirstPath(t1, t2);
    
    Assert.isTrue(Options.eq(actual, expected, function (x,y) return Arrays.eq(x,y, PathNodeExt.eq))); 
  }
  
  public function testGetFirstPath2 () {
    var t1 = 
      TypeExt.asClassType(Parse.parseToType(FQ_U).extract())
      .map(function (x) return x._1.get()).extract();
      
    var t2 = 
      TypeExt.asClassType(Parse.parseToType(FQ_S).extract())
      .map(function (x) return x._1.get()).extract();
    
    
    var expected = Some([SuperClass]);
    var actual = Utils.getFirstPath(t1, t2);
    
    Assert.isTrue(Options.eq(actual, expected, function (x,y) return Arrays.eq(x,y, PathNodeExt.eq))); 
  }
  
  public function testGetFirstPath3 () {
    var t1 = 
      TypeExt.asClassType(Parse.parseToType(FQ_U).extract())
      .map(function (x) return x._1.get()).extract();
      
    var t2 = 
      TypeExt.asClassType(Parse.parseToType(FQ_C).extract())
      .map(function (x) return x._1.get()).extract();
    
    
    var expected = Some([SuperClass, InterfaceAt(0)]);
    var actual = Utils.getFirstPath(t1, t2);
    Assert.isTrue(Options.eq(actual, expected, function (x,y) return Arrays.eq(x,y, PathNodeExt.eq))); 
  }
  
  public function testGetFirstPath4 () {
    var t1 = 
      TypeExt.asClassType(Parse.parseToType(FQ_U).extract())
      .map(function (x) return x._1.get()).extract();
      
    var t2 = 
      TypeExt.asClassType(Parse.parseToType(FQ_D).extract())
      .map(function (x) return x._1.get()).extract();
    
    
    // interfaces are sorted backwards C implements D, implements E, is stored in C.interfaces as [E,D], thus pathnode at 2 is InterfaceAt(1) 
    var expected = Some([SuperClass, InterfaceAt(0), InterfaceAt(1)]);
    var actual = Utils.getFirstPath(t1, t2);
    trace(actual);
    Assert.isTrue(Options.eq(actual, expected, function (x,y) return Arrays.eq(x,y, PathNodeExt.eq))); 
  }
  
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