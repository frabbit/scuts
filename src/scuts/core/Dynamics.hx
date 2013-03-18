package scuts.core;

import scuts.Scuts;


class Dynamics
{

  public static inline function nullOrError < T,S > (v:T, err:String):T 
  {
    return if (v != null) v else Scuts.error(err);
  }

  public static inline function nullToArray < T > (v:T):Array<T> 
  {
    return v != null ? [v] : [];
  }

  /**
   * Returns v or elseValue, based on the nulliness of v.
   */
  public static inline function nullGetOrElseConst < T > (v:T, elseValue:T):T 
  {
    return v != null ? v : elseValue;
  }
  
  /**
   * Returns v or elseValue, based on the nulliness of v.
   */
  public static inline function nullGetOrElse < T > (v:T, elseValue:Void->T):T 
  {
    return v != null ? v : elseValue();
  }

  /**
   * Checks if v is an Object.
   */
  public static inline function isObject <T>(v:T):Bool 
  {
    return Reflect.isObject(v);
  }
  
  /**
   * Turns a constant value into a constant function.
   */
  public static inline function thunk <T>(o:T):Void->T
  {
    return function () return o;
  }

  public static function nullEq <T> (v1:T, v2:T, eq:T->T->Bool):Bool {
    return (v1 == null && v2 == null)
      || (v1 != null && v2 != null && eq(v1,v2));
  }

}