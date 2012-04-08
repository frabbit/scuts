package scuts;
import haxe.PosInfos;
import Type;


class Assert 
{
  
  private static inline function doAssert (expr : Bool, assertId : String, ?message : String, ?posInfos:PosInfos):Void
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
  public static inline function assertTrue (expr:Bool, ?message:String, ?posInfos:PosInfos):Bool 
  {
    #if debug
    doAssert(expr, "assertTrue", message, posInfos);
    #end
    return expr;
  }
  
  /**
   * throws an assertion error in debug mode if expr is not true
   */
  public static function assertIsObject <T>(val:T, ?message:String, ?posInfos:PosInfos):T 
  {
    #if debug
    doAssert(Reflect.isObject(val), "assertIsObject", message, posInfos);
    #end
    return val;
  }
  /**
   * throws an assertion error in debug mode.
   */
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
  public static inline function assertEquals <T>(expected:T, actual:T, ?message:String, ?posInfos:PosInfos):T 
  {
    #if debug
        message = message == null ? "expected " + expected + " but was " + actual : message;
    doAssert(expected == actual, "assertEquals", message, posInfos);
    #end
    return actual;
  }
  
  /**
   * throws an assertion error in debug mode if a is null.
   */
  public static function assertNotNull <T>(a:T, ?message:String = null, ?posInfos:PosInfos):T 
  {
    #if debug
    doAssert(a != null, "assertNotNull", message, posInfos);
    #end
    return a;
  }
  
  /**
   * throws an assertion error in debug mode if all elements of a are null.
   */
  public static inline function assertAllNotNull <T>(a:Iterable<T>, ?message:String = null, ?posInfos:PosInfos):Iterable<T> 
  {
    
    #if debug
    doAssert(a != null, "assertAllNotNull", "The passed Array is null", posInfos);
    var i = 0;
    for (e in a) { 
      doAssert(e != null, "assertAllNotNull", "The Element at Position " + i + " is null", posInfos);
      i++;
    }
    #end
    return a;
  }
  
  /**
   * throws an assertion error in debug mode if a is not null.
   */
  public static function assertNull <T>(a:T, ?message:String, ?posInfos:PosInfos):T 
  {
    #if debug
    doAssert(a == null, "assertNotNull", message, posInfos);
    #end
    return a;
  }
  
  /**
   * throws an assertion error in debug mode if value is not between min and max.
   */
  public static inline function assertFloatInRange (value : Float, min : Float, max : Float, ?message : String, ?posInfos:PosInfos):Float 
  {
    #if debug
    message = message == null 
        ? "expected Range (" + min + ", " + max + ") but was " + value 
        : message;
        doAssert( min <= value && value <= max, "assertInRange", message, posInfos);
    #end
    return value;
  }
    
  
  /**
   * throws an assertion error in debug mode if value is not between min and max.
   */
  public static inline function assertIntInRange (value : Int, min : Int, max : Int, ?message : String, ?posInfos:PosInfos):Int
  {
    #if debug
    message = message == null 
        ? "expected Range (" + min + ", " + max + ") but was " + value 
        : message;
        doAssert( min <= value && value <= max, "assertInRange", message, posInfos);
    #end
    return value;
  }
  
  /**
   * throws an assertion error in debug mode if expr is true.
   */
  public static inline function assertFalse (expr:Bool, ?message:String, ?posInfos:PosInfos):Bool 
  {
    #if debug
    doAssert(!expr, "assertFalse", message, posInfos);
    #end
    return expr;
  }
  
  /**
   * throws an assertion error in debug mode if obj is not of type objType.
   */
  public static inline function assertType <T>(obj:T, objType:Dynamic, ?posInfos:PosInfos):T 
  {
    #if debug
    doAssert(Std.is(obj, objType), "assertType", "expected type " + objType + ", but was " + Type.getClass(obj), posInfos);
    #end
    return obj;
  }
  
  /**
   * throws an assertion error in debug mode if obj is a class instance.
   */
  public static inline function assertIsClassInstance <T>(obj:T, ?posInfos:PosInfos):T 
  {
    #if debug
    var isClassInstance = switch (Type.typeof(obj)) 
    {
      case TClass(_): true;
      default: false;
    }
    doAssert(isClassInstance, "assertType", "expected type " + obj + ", but was " + Type.getClass(obj), posInfos);
    #end
    return obj;
  }
  
  
  
  
  
}