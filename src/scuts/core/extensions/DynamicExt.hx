package scuts.core.extensions;


import haxe.Log;
import haxe.PosInfos;
import scuts.core.types.Future;
import scuts.core.types.Option;



import scuts.core.types.Either;


class DynamicExt
{

  /*
  public static function toArrayOption <T>(a:T):Array<Option<T>> 
  {
    return if (a == null) [] else [Some(a)];
  }
  */
  
  public static inline function nullToOption < T > (v:T):Option<T> {
    return v != null ? Some(v) : None;
  }
  
  public static inline function nullToLeft < A,B > (v:A, right:B):Either<A,B> {
    return v != null ? Left(v) : Right(right);
  }
  
  
  public static inline function nullGetOrElse < T > (v:T, elseValue:T):T {
    return v != null ? v : elseValue;
  }
  
  
  public static inline function toEitherLeft < A,B > (v:A):Either<A,B> {
    return Left(v);
  }
  
  public static inline function toEitherRight < A,B > (v:B):Either<A,B> {
    return Right(v);
  }
  
  public static inline function toFuture<T>(val:T):Future<T> 
  {
    return new Future().deliver(val);
  }
  
  public static inline function toArrayFuture<T>(t:T):Array<Future<T>> 
  {
    return [toFuture(t)];
  }
  
  
  public static inline function isObject <T>(v:T):Bool {
    return Reflect.isObject(v);
  }
  
  public static function replicateToArray<T>(e:T, num:Int):Array<T> 
  {
    
    var res = [];
    for (_ in 0...num) {
      res.push(e);
    }
    return res;
  }
  
  /*
  public static function getOrElse <T>(o:T, elseValue:T):T
  {
    return if (o == null) elseValue else o;
  }
  */
  
  public static function lazyConstant<T>(value:T):Void->T 
  {
    return function () return value;
  }
  
  public static function logMe<T>(v:T, ?msg:String, ?pos:PosInfos):T 
  {
    var m = (if (msg != null) msg + ":" else "") + Std.string(v);
    Log.trace(m, pos);
    return v;
  }

  
}