package scuts;
import haxe.PosInfos;
import Type;


class Assert 
{
  private static inline function doAssert (expr : Bool, assertId : String, ?message : String, ?posInfos:PosInfos) 
  {
	if (!(expr)) {
		var msg = assertId + " failed: " + message + " at " + Std.string(posInfos);
		trace(msg);
		throw msg;
	}
  }
  
  /**
   * throws an assertion error in debug mode if expr is not true
   */
	public static inline function assertTrue (expr:Bool, ?message:String, ?posInfos:PosInfos):Void 
	{
		#if debug
		doAssert(expr, "assertTrue", message, posInfos);
		#end
	}
  
  /**
   * throws an assertion error in debug mode if expr is not true
   */
	public static inline function assertIsObject (val:Dynamic, ?message:String, ?posInfos:PosInfos):Void 
	{
		#if debug
		doAssert(Reflect.isObject(val), "assertIsObject", message, posInfos);
		#end
	}
  /**
   * throws an assertion error in debug mode.
   */
  public static inline function fail (?message:String, ?posInfos:PosInfos):Void 
	{
		#if debug
		doAssert(false, "fail", message, posInfos);
		#end
	}
	
	/**
   * throws an assertion error in debug mode if expected doesn't equals actual.
   */
  public static inline function assertEquals <T>(expected:T, actual:T, ?message:String, ?posInfos:PosInfos):Void 
	{
		#if debug
        message = message == null ? "expected " + expected + " but was " + actual : message;
		doAssert(expected == actual, "assertEquals", message, posInfos);
		#end
	}
  
  /**
   * throws an assertion error in debug mode if a is null.
   */
  public static inline function assertNotNull (a:Dynamic, ?message:String = null, ?posInfos:PosInfos):Void 
	{
		#if debug
		doAssert(a != null, "assertNotNull", message, posInfos);
		#end
	}
  
	/**
   * throws an assertion error in debug mode if all elements of a are null.
   */
	public static inline function assertAllNotNull (a:Iterable<Dynamic>, ?message:String = null, ?posInfos:PosInfos):Void 
	{
		
		#if debug
		doAssert(a != null, "assertAllNotNull", "The passed Array is null", posInfos);
		var i = 0;
		for (e in a) { 
			doAssert(e != null, "assertAllNotNull", "The Element at Position " + i + " is null", posInfos);
			i++;
		}
		#end
	}
	
  /**
   * throws an assertion error in debug mode if a is not null.
   */
	public static function assertNull <T>(a:T, ?message:String, ?posInfos:PosInfos):Void 
	{
		#if debug
		doAssert(a == null, "assertNotNull", message, posInfos);
		#end
	}
  
  /**
   * throws an assertion error in debug mode if value is not between min and max.
   */
  public static inline function assertFloatInRange (value : Float, min : Float, max : Float, ?message : String, ?posInfos:PosInfos) 
	{
		#if debug
		message = message == null 
				? "expected Range (" + min + ", " + max + ") but was " + value 
				: message;
        doAssert( min <= value && value <= max, "assertInRange", message, posInfos);
		#end
    }
	
  /**
   * throws an assertion error in debug mode if value is not between min and max.
   */
	public static inline function assertIntInRange (value : Int, min : Int, max : Int, ?message : String, ?posInfos:PosInfos) 
	{
		#if debug
		message = message == null 
				? "expected Range (" + min + ", " + max + ") but was " + value 
				: message;
        doAssert( min <= value && value <= max, "assertInRange", message, posInfos);
		#end
    }
	
  /**
   * throws an assertion error in debug mode if expr is true.
   */
  public static inline function assertFalse (expr:Bool, ?message:String, ?posInfos:PosInfos):Void 
	{
		#if debug
		doAssert(!expr, "assertFalse", message, posInfos);
		#end
	}
  
  /**
   * throws an assertion error in debug mode if obj is not of type objType.
   */
	public static inline function assertType (obj:Dynamic, objType:Dynamic, ?posInfos:PosInfos) 
	{
		#if debug
		doAssert(Std.is(obj, objType), "assertType", "expected type " + objType + ", but was " + Type.getClass(obj), posInfos);
		#end
	}
	
  /**
   * throws an assertion error in debug mode if obj is a class instance.
   */
	public static inline function assertIsClassInstance (obj:Dynamic, ?posInfos:PosInfos) 
	{
		#if debug
		var isClassInstance = switch (Type.typeof(obj)) 
		{
			case TClass(_): true;
			default: false;
		}
		doAssert(isClassInstance, "assertType", "expected type " + obj + ", but was " + Type.getClass(obj), posInfos);
		#end
	}
	
	
	
	
	
}