package scuts.core.extensions;
import scuts.core.types.Option;
import scuts.core.types.Either;
using scuts.core.extensions.OptionExt;
/**
 * ...
 * @author 
 */

class Function0Ext 
{
  public static function tryToOption <T>(f:Void->T):Void->Option<T>
  {
    return function () return try Some(f()) catch (e:Dynamic) None;
  }
  
  public static function evalToOption <T>(f:Void->T):Option<T>
  {
    return try Some(f()) catch (e:Dynamic) None;
  }
  
  public static function toEffect <T>(f:Void->T):Void->Void
  {
    return function () f();
  }
  
  public static function lazyThunk <X>(f:Void->X):Void->X
  {
    var cur = None;
    return function () {
      return switch (cur) {
        case Some(x): x;
        case None: 
          var x = f();
          cur = Some(x);
          x;
      }
    }
  }
  
  public static function promote <T,X>(f:Void->T):X->T
  {
    return function (x) return f();
  }
  
  /*
   * macro stuff
   * 
  public static function tryToEither <T,X,Y>(f:Void->T, handler:X->Y):Void->Either<Y, T>
  {
    return function () return try Right(f()) catch (e:X) Left(handler(e));
  }
  
  public static function evalToEither <T,X,Y>(f:Void->T, handler:X->Y):Either<Y, T>
  {
    return try Right(f()) catch (e:X) Left(handler(e));
  }
  */
  
}