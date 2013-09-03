package scuts.core;

import scuts.Scuts;


class Dynamics
{

  

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

  
}