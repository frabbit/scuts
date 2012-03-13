package scuts.core.extensions;
import scuts.core.types.Option;
import scuts.core.types.Either;
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