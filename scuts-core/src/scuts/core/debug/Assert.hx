package scuts.core.debug;

import Type;

import haxe.macro.Expr.Expr;

#if macro
typedef PosInfos = Dynamic
#else
typedef PosInfos = haxe.PosInfos
#end


class AssertionError {

  var msg:String;
  var pos:PosInfos;

  public function new (msg:String, ?pos:PosInfos) {
    this.msg = msg;
    this.pos = pos;
  }
}


private typedef A = Assert;




#if (macro || (debug && !noAssert))
private class AssertUsingNormal
{


  public static inline function assert <T>(ret:T, expr:Bool, ?message:String, ?posInfos:PosInfos):T
  {
    return A.isTrue(expr, ret, message, posInfos);
  }

  public static inline function assertTrue <T>(ret:T, expr:Bool, ?message:String, ?posInfos:PosInfos):T
  {
    return A.isTrue(expr, ret, message, posInfos);
  }

  public static function assertObject <X>(ret:X, val:Dynamic, ?message:String, ?posInfos:PosInfos):X
  {
    return A.isObject(val, ret, message, posInfos);
  }

  public static inline function assertFail <T>(?message:String, ?posInfos:PosInfos):T
  {
    return A.fail(message, posInfos);
  }

  public static function assertEquals <X,T>(ret:X, expected:T, actual:T, ?message:String, ?posInfos:PosInfos):X
  {
    return A.equals(expected, actual, ret, message, posInfos);
  }

  public static function assertNotNull <X>(ret:X,a:Dynamic, ?message:String = null, ?posInfos:PosInfos):X
  {
    return A.notNull(a, ret, message, posInfos);
  }

  public static inline function assertAllNotNull <X>(ret:X,a:Iterable<Dynamic>, ?message:String = null, ?posInfos:PosInfos):X
  {
    return A.allNotNull(a, ret, message, posInfos);
  }

  public static function assertNull <X>(ret:X,a:Dynamic, ?message:String, ?posInfos:PosInfos):X
  {
    return A.isNull(a, ret, message, posInfos);
  }

  public static inline function assertFloatInRange <X>(ret:X,value : Float, min : Float, max : Float, ?message : String, ?posInfos:PosInfos):X
  {
    return A.floatInRange(value, min, max, ret, message, posInfos);
  }

  public static inline function assertIntInRange <X>(ret:X,value : Int, min : Int, max : Int, ?message : String, ?posInfos:PosInfos):X
  {
    return A.intInRange(value, min, max, ret, message, posInfos);
  }

  public static inline function assertIntMin <X>(ret:X,value : Int, min : Int, ?message : String, ?posInfos:PosInfos):X
  {
    return A.intMin(value, min, ret, message, posInfos);
  }

  public static inline function assertFalse <X>(ret:X, expr:Bool,  ?message:String, ?posInfos:PosInfos):X
  {
    return A.isFalse(expr, ret, message, posInfos);
  }

  public static inline function assertType <X>(ret:X,obj:Dynamic, objType:Dynamic,  ?message:String, ?posInfos:PosInfos):X
  {
    return A.isType(obj, objType, ret, message, posInfos);
  }

  /** @see Assert.isTrue */
  public static inline function assertClassInstance <X>(ret:X,obj:Dynamic, ?message:String, ?posInfos:PosInfos):X
  {
    return A.isClassInstance(obj, ret, message, posInfos);
  }


}
#end

private class AssertUsingMacro
{
  macro public static function assert (ret:Expr, expr:Expr, ?message:Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }

  macro public static function assertTrue (ret:Expr, expr:Expr, ?message:Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }

  macro public static function assertObject (ret:Expr, val:Expr, ?message:Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }

  macro public static function assertFail (?message:Expr, ?posInfos:Expr):Expr
  {
    return macro throw "fail";
  }

  macro public static function assertEquals (ret:Expr, expected:Expr, actual:Expr, ?message:Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }

  macro public static function assertNotNull (ret:ExprOf<Dynamic>,a:Expr, ?message:Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }

  macro public static function assertAllNotNull (ret:Expr,a:Expr, ?message:Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }

  macro public static function assertNull (ret:Expr,a:Expr, ?message:Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }

  macro public static function assertFloatInRange (ret:Expr,value : Expr, min : Expr, max : Expr, ?message : Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }

  macro public static function assertIntInRange (ret:Expr,value : Expr, min : Expr, max : Expr, ?message : Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }

  macro public static function assertIntMin (ret:Expr,value : Expr, min : Expr, ?message : Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }

  macro public static function assertFalse (ret:Expr, expr:Expr,  ?message:Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }

  macro public static function assertType (ret:Expr,obj:Expr, objType:Expr,  ?message:Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }

  /** @see Assert.isTrue */
  macro public static function assertClassInstance (ret:Expr,obj:Expr, ?message:Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }
}




#if (macro || (debug && !noAssert))
private class AssertNormal
{

  static inline function doAssert (expr : Bool, assertId : String, ?message : String, ?posInfos:PosInfos):Void
  {
    if (expr == null || !(expr)) {
      if (message == null) message = "(no message)";
      var posStr = if (posInfos == null) {
        posInfos.fileName + " at " + posInfos.lineNumber + " (" + posInfos.className + "." + posInfos.methodName + ")";
      } else {
        "noPosInfos";
      };

      var msg = posStr + ": " + assertId + " failed: " + message;
      trace(msg);
      var stack = haxe.CallStack.exceptionStack();
      trace(haxe.CallStack.toString(stack));
      var stack = haxe.CallStack.callStack();
      trace(haxe.CallStack.toString(stack));
      #if (js)
      var stack = Std.string(untyped __new__("Error").stack);
      trace(stack);
      #end
      throw new AssertionError(msg, posInfos);
    }
  }


  /**
   * throws an assertion error in debug mode if expr is not true
   */

  @:noUsing
  public static inline function isTrue <T>(expr:Bool, ?ret:T, ?message:String, ?posInfos:PosInfos):T {

    doAssert(expr, "assertTrue", message, posInfos);
    return ret;
  }

  @:noUsing
  public static inline function assert <T>(expr:Bool, ?ret:T, ?message:String, ?posInfos:PosInfos):T {

    return isTrue(expr, ret, message, posInfos);
  }

  /**
   * throws an assertion error in debug mode if expr is not true
   */
  @:noUsing
  public static function isObject <T>(val:Dynamic, ?ret:T, ?message:String, ?posInfos:PosInfos):T
  {
    #if (debug && !noAssert)
    doAssert(Reflect.isObject(val), "assertIsObject", message, posInfos);
    #end
    return ret;
  }
  /**
   * throws an assertion error in debug mode.
   */
  @:noUsing
  public static inline function fail <T>(?message:String, ?posInfos:PosInfos):T
  {
    #if (debug && !noAssert)
    doAssert(false, "fail", message, posInfos);
    #end
    return Scuts.error("fail");
  }

  /**
   * throws an assertion error in debug mode if expected doesn't equals actual.
   */
  @:noUsing
  public static function equals <X,T>(expected:T, actual:T, ?ret:X, ?message:String, ?posInfos:PosInfos):X
  {
    #if (debug && !noAssert)
        message = message == null ? "expected " + expected + " but was " + actual : message;
    doAssert(expected == actual, "assertEquals", message, posInfos);
    #end
    return ret;
  }

  /**
   * throws an assertion error in debug mode if a is null.
   */
  @:noUsing
  public static function notNull <T,X>(a:T, ?ret:X, ?message:String = null, ?posInfos:PosInfos):X
  {
    #if (debug && !noAssert)
    doAssert(a != null, "assertNotNull", message, posInfos);
    #end
    return ret;
  }

  /**
   * throws an assertion error in debug mode if all elements of a are null.
   */
  @:noUsing
  public static inline function allNotNull <X>(a:Iterable<Dynamic>, ?ret:X, ?message:String = null, ?posInfos:PosInfos):X
  {

    #if (debug && !noAssert)
    doAssert(a != null, "assertAllNotNull", "The passed Array is null", posInfos);
    var i = 0;
    for (e in a) {
      doAssert(e != null, "assertAllNotNull", "The Element at Position " + i + " is null", posInfos);
      i++;
    }
    #end
    return ret;
  }

  /**
   * throws an assertion error in debug mode if a is not null.
   */
  @:noUsing
  public static function isNull <X>(a:Dynamic, ?ret:X, ?message:String, ?posInfos:PosInfos):X
  {
    #if (debug && !noAssert)
    doAssert(a == null, "assertNotNull", message, posInfos);
    #end
    return ret;
  }

  /**
   * throws an assertion error in debug mode if value is not between min and max.
   */
  @:noUsing
  public static inline function floatInRange <X>(value : Float, min : Float, max : Float, ?ret:X, ?message : String, ?posInfos:PosInfos):X
  {
    #if (debug && !noAssert)
    message = message == null
        ? "expected Range (" + min + ", " + max + ") but was " + value
        : message;
        doAssert( min <= value && value <= max, "assertInRange", message, posInfos);
    #end
    return ret;
  }


  /**
   * throws an assertion error in debug mode if value is not between min and max.
   */
  @:noUsing
  public static inline function intInRange <X>(value : Int, min : Int, max : Int, ?ret:X, ?message : String, ?posInfos:PosInfos):X
  {
    #if (debug && !noAssert)
    message = message == null
        ? "expected Range (" + min + ", " + max + ") but was " + value
        : message;
        doAssert( min <= value && value <= max, "assertInRange", message, posInfos);
    #end
    return ret;
  }

  /**
   * throws an assertion error in debug mode if value is not greater or equal as min.
   */
  @:noUsing
  public static inline function intMin <X>(value : Int, min : Int, ?ret:X, ?message : String, ?posInfos:PosInfos):X
  {
    #if (debug && !noAssert)
    message = message == null
        ? "minumum " + min + " expected but was " + value
        : message;
        doAssert( value >= min, "assertIntMin", message, posInfos);
    #end
    return ret;
  }

  /**
   * throws an assertion error in debug mode if expr is true.
   */
  @:noUsing
  public static inline function isFalse <X>(expr:Bool, ?ret:X, ?message:String, ?posInfos:PosInfos):X
  {
    #if (debug && !noAssert)
    doAssert(!expr, "assertFalse", message, posInfos);
    #end
    return ret;
  }

  /**
   * throws an assertion error in debug mode if obj is not of type objType.
   */
  @:noUsing
  public static inline function isType <X>(obj:Dynamic, objType:Dynamic, ?ret:X, ?message:String, ?posInfos:PosInfos):X
  {
    #if (debug && !noAssert)
    doAssert(Std.is(obj, objType), "assertType", "expected type " + objType + ", but was " + Type.getClass(obj), posInfos);
    #end
    return ret;
  }

  /**
   * throws an assertion error in debug mode if obj is a class instance.
   */
  @:noUsing
  public static inline function isClassInstance <X>(obj:Dynamic, ?ret:X, ?message:String, ?posInfos:PosInfos):X
  {
    #if (debug && !noAssert)
    var isClassInstance = switch (Type.typeof(obj))
    {
      case TClass(_): true;
      default:        false;
    }
    doAssert(isClassInstance, "assertType", "expected type " + obj + ", but was " + Type.getClass(obj), posInfos);
    #end
    return ret;
  }

}
#end //(!macro && (!debug || noAssert))

private class AssertMacro
{
  @:noUsing
  macro static function doAssert (expr:Expr, assertId:Expr, ?message:Expr, ?posInfos:Expr):Expr {
    return macro null;
  }
  @:noUsing
  macro public static function isTrue (expr:Expr, ?ret:Expr, ?message:Expr, ?posInfos:Expr):Expr {
    return ret;
  }
  @:noUsing
  macro public static function assert (expr:Expr, ?ret:Expr, ?message:Expr, ?posInfos:Expr):Expr {
    return ret;
  }

  @:noUsing
  macro public static function isObject (val:Expr, ?ret:Expr, ?message:Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }

  @:noUsing
  macro public static function fail (?message:Expr, ?posInfos:Expr):Expr
  {
    return macro scuts.Scuts.error("fail");
  }

  @:noUsing
  macro public static function equals (expected:Expr, actual:Expr, ?ret:Expr, ?message:Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }

  @:noUsing
  macro public static function notNull (a:Expr, ?ret:Expr, ?message:Expr = null, ?posInfos:PosInfos):Expr
  {
    return ret;
  }

  @:noUsing
  macro public static function allNotNull (a:Expr, ?ret:Expr, ?message:Expr = null, ?posInfos:PosInfos):Expr
  {

    return ret;
  }

  @:noUsing
  macro public static function isNull (a:Expr, ?ret:Expr, ?message:Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }

  @:noUsing
  macro public static function floatInRange (value : Expr, min : Expr, max : Expr, ?ret:Expr, ?message : Expr, ?posInfos:PosInfos):Expr
  {
    return ret;
  }



  @:noUsing
  macro public static function intInRange (value : Expr, min : Expr, max : Expr, ?ret:Expr, ?message : Expr, ?posInfos:PosInfos):Expr
  {
    return ret;
  }

  @:noUsing
  macro public static inline function intMin (value : Expr, min : Expr, ?ret:Expr, ?message : Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }

  @:noUsing
  macro public static function isFalse (expr:Expr, ?ret:Expr, ?message:Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }

  @:noUsing
  macro public static function isType (obj:Expr, objType:Expr, ?ret:Expr, ?message:Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }

  @:noUsing
  macro public static function isClassInstance (obj:Expr, ?ret:Expr, ?message:Expr, ?posInfos:Expr):Expr
  {
    return ret;
  }




}


#if (macro || (debug && !noAssert))
typedef AssertUsing = AssertUsingNormal;
typedef Assert = AssertNormal;

#else
typedef AssertUsing = AssertUsingMacro;
typedef Assert = AssertMacro;
#end