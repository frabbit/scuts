package scuts.core.extensions;

import scuts.core.types.Option;
import scuts.core.types.Either;
import scuts.Scuts;

class OptionExt {

  public static function getOrElseConst <T>(o:Option<T>, elseValue:T):T
  {
    return switch (o) 
    {
      case Some(v): v;
      case None: elseValue;
    }
  }
  
  public static function getOrElse <T>(o:Option<T>, elseValue:Void->T):T
  {
    return switch (o) 
    {
      case Some(v): v;
      case None: elseValue();
    }
  }
  
  public static function toLeft <A,B>(o:Option<A>, right:B):Either<A,B>
  {
    return switch (o) 
    {
      case Some(v): Left(v);
      case None: Right(right);
    }
  }
  
  public static function eq <T>(a:Option<T>, b:Option<T>, eqT:T->T->Bool):Bool 
  {
    return switch (a) 
    {
      case None: 
        switch (b) 
        {
          case None: true;
          case Some(_): false;
        }
      case Some(v1):
        switch (b) 
        {
          case None: false;
          case Some(v2): eqT(v1, v2);
        }
    }
  }
  
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
  
  
  public static inline function map < S, T > (o:Option<S>, f:S->T):Option<T> {
    return switch (o) {
      case Some(v): Some(f(v));
      case None: None;
    }
    
  }
  
}