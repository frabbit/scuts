package scuts.core.debug;
import haxe.PosInfos;
import Type;

private typedef A = Assert;

class AssertUsing 
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

class Assert
{
  static inline function doAssert (expr : Bool, assertId : String, ?message : String, ?posInfos:PosInfos):Void
  {
    if (!(expr)) {
      if (message == null) message = "(no message)";
      var posStr = posInfos.fileName + " at " + posInfos.lineNumber + " (" + posInfos.className + "." + posInfos.methodName + ")"; 
      var msg = posStr + ": " + assertId + " failed: " + message;
      Scuts.error(msg, posInfos);
    } 
  }
  
  /**
   * throws an assertion error in debug mode if expr is not true
   */
  @:noUsing 
  public static inline function isTrue <T>(expr:Bool, ?ret:T, ?message:String, ?posInfos:PosInfos):T {
    #if debug
    doAssert(expr, "assertTrue", message, posInfos);
    #end
    return ret;
  }
  
  /**
   * throws an assertion error in debug mode if expr is not true
   */
  @:noUsing
  public static function isObject <T>(val:Dynamic, ?ret:T, ?message:String, ?posInfos:PosInfos):T 
  {
    #if debug
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
    #if debug
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
    #if debug
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
    #if debug
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
    
    #if debug
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
    #if debug
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
    #if debug
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
    #if debug
    message = message == null 
        ? "expected Range (" + min + ", " + max + ") but was " + value 
        : message;
        doAssert( min <= value && value <= max, "assertInRange", message, posInfos);
    #end
    return ret;
  }
  
  /**
   * throws an assertion error in debug mode if expr is true.
   */
  @:noUsing
  public static inline function isFalse <X>(expr:Bool, ?ret:X, ?message:String, ?posInfos:PosInfos):X 
  {
    #if debug
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
    #if debug
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
    #if debug
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