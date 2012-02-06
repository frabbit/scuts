package scuts.core.extensions;

import scuts.core.types.Option;
import scuts.Scuts;

class OptionExt {

  public static inline function isSome (o:Option<Dynamic>):Bool {
    return switch (o) {
      case Some(_): true;
      case None: false;
    }
  }
  
  public static inline function isNone (o:Option<Dynamic>):Bool {
    return !isSome(o);
  }
  
  // TODO remove me
  public static inline function value <T>(o:Option<T>):T {
    return extract(o);
  }
  
  public static inline function extract <T>(o:Option<T>):T {
    return switch (o) {
      case Some(v): v;
      case None: Scuts.error("Cannot extract value from Option None");
    }
  }
  
  public static function filter <T> (o:Option<T>, filter:T->Bool):Option<T>
	{
		return switch (o) {
      case Some(v): filter(v) ? Some(v) : None;
      case None: None;
    }
	}
  public static function flatMap < S, T > (o:Option<S>, f:S->Option<T>):Option<T>
  {
    return switch (o) {
      case Some(v): f(v);
      case None: None;
    }
  }
  
  public static function getOrElse <T>(o:Option<T>, elseValue:T):T
  {
    return if (isSome(o)) value(o) else elseValue;
  }
  
  public static inline function map < S, T > (o:Option<S>, f:S->T):Option<T> {
    return switch (o) {
      case Some(v): Some(f(v));
      case None: None;
    }
    
  }
  
}