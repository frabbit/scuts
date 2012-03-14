package scuts.core.extensions;



import haxe.Log;
import haxe.PosInfos;
import scuts.core.types.Future;
import scuts.core.types.Option;
import scuts.Scuts;
//import scuts.mcore.Make;


import scuts.core.types.Either;


class DynamicExt
{

  /**
   * Converts v into a Some Option.
   */
  public static inline function toOption < T > (v:T):Option<T> {
    #if debug
    if (v == null) 
      Scuts.error("Cannot wrap null into an Option, use nullToOption instead");
    #end
    return Some(v);
  }

  public static inline function nullOrError < T,S > (v:T, err:String):T {
    return if (v != null) v else cast Scuts.error(err);
  }
  
  /**
   * Converts v into an Option, based on the nulliness of v.
   */
  public static inline function nullToOption < T > (v:T):Option<T> {
    return v != null ? Some(v) : None;
  }
  
  public static inline function nullToArray < T > (v:T):Array<T> {
    return v != null ? [v] : [];
  }
  
  /**
   * Converts v into an Either, based on the nulliness of v.
   * If v is null, right is used as the Right value for the resulting Either.
   */
  public static inline function nullToLeft < A,B > (v:A, right:B):Either<A,B> {
    return v != null ? Left(v) : Right(right);
  }
  
  /**
   * Returns v or elseValue, based on the nulliness of v.
   */
  public static inline function nullGetOrElseConst < T > (v:T, elseValue:T):T {
    return v != null ? v : elseValue;
  }
  
  
  /**
   * Returns v or elseValue, based on the nulliness of v.
   */
  public static inline function nullGetOrElse < T > (v:T, elseValue:Void->T):T {
    return v != null ? v : elseValue();
  }
  
  /**
   * Converts v into a left Either.
   */
  public static inline function toEitherLeft < A,B > (v:A):Either<A,B> return Left(v)
  
  /**
   * Converts v into a right Either.
   */
  public static inline function toEitherRight < A,B > (v:B):Either<A,B> return Right(v)
  
  /**
   * Converts v into a Future and deliver it immediately.
   */
  public static inline function toFuture<T>(val:T):Future<T> 
  {
    return new Future().deliver(val);
  }
  
  public static inline function toArrayFuture<T>(t:T):Array<Future<T>> 
  {
    return [toFuture(t)];
  }
  
  /**
   * Checks if v is an Object.
   */
  public static inline function isObject <T>(v:T):Bool {
    return Reflect.isObject(v);
  }
  
  /**
   * Creates an Array containing the elemen e num times.
   */
  public static function replicateToArray<T>(e:T, num:Int):Array<T> 
  {
    var res = [];
    for (_ in 0...num) {
      res.push(e);
    }
    return res;
  }
  
  @:macro public static function lazy <T>(e:haxe.macro.Expr.ExprRequire<T>):haxe.macro.Expr.ExprRequire<Void->T>
  {
    return scuts.core.macros.Lazy.mkExpr(e);
  }
  /**
   * Turns a constant value into a constant function.
   */
  public static function lazyConstant<T>(value:T):Void->T 
  {
    return function () return value;
  }
  

  
}