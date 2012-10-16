package scuts.core;

import haxe.PosInfos;
import scuts.core.Option;
import scuts.core.Either;
import scuts.core.Ordering;
import scuts.core.Tup2;
import scuts.Scuts;

using scuts.core.Options;

using scuts.core.Predicates;



class Options {

  @:noUsing public static inline function none <A>():Option<A> 
  {
    return None;
  }
  
  @:noUsing public static function pure <A>(a:A):Option<A> 
  {
    return Some(a);
  }
  
  public static function zipWith <A,B,C>(a:Option<A>, b:Option<B>, f:A->B->C):Option<C> return switch (a) 
  {
    case Some(v): switch (b) 
    {
      case Some(v2): Some(f(v,v2));
      case None: None;
    }
    case None: None;
  }
  
  public static function zip <A,B,C>(a:Option<A>, b:Option<B>):Option<Tup2<A,B>> 
  {
    return zipWith(a,b, Tup2.create);
  }

  
  public static function compareBy <T>(a:Option<T>, b:Option<T>, compareT:T->T->Ordering):Ordering return switch(a) 
  {
    case None: switch (b) {
      case None: EQ;
      case Some(_): LT;
    }
    case Some(v1): switch (b) {
      case None: GT;
      case Some(v2): compareT(v1,v2);
    }
  }
  
  public static function append <T>(o1:Option<T>, o2:Option<T>, appendT:T->T->T):Option<T> return switch (o1) 
  {
    case Some(s1): switch (o2) 
    {
      case Some(s2): Some(appendT(s1,s2));
      case None :    None;
    }
    case None: None;
  }
  
  public static function getOrElseConst <T>(o:Option<T>, elseValue:T):T return switch (o) 
  {
    case Some(v): v;
    case None:    elseValue;
  }
  
  public static function orElse <T>(o:Option<T>, elseValue:Void->Option<T>):Option<T> return switch (o) 
  {
    case Some(_): o;
    case None:    elseValue();
  }
  
  public static function orNull <T>(o:Option<T>):Null<T> return switch (o) 
  {
    case Some(v): v;
    case None:    null;
  }
  
  public static function getOrElse <T>(o:Option<T>, elseValue:Void->T):T return switch (o) 
  {
    case Some(v): v;
    case None:    elseValue();
  }
  
  public static function getOrError <T>(o:Option<T>, error:String, ?posInfos:PosInfos):T return switch (o) 
  {
    case Some(v): v;
    case None:    Scuts.error(error,posInfos);
  }

  public static function toLeftConst <A,B>(o:Option<A>, right:B):Either<A,B> return switch (o) 
  {
    case Some(v): Left(v);
    case None:    Right(right);
  }
  
  public static function toLeft <A,B>(o:Option<A>, right:Void->B):Either<A,B> return switch (o) 
  {
    case Some(v): Left(v);
    case None:    Right(right());
  }
  
  public static function toRight <A,B>(o:Option<A>, left:Void->B):Either<B,A> return switch (o) 
  {
    case Some(v): Right(v);
    case None:    Left(left());
  }
  
  public static function toRightConst <A,B>(o:Option<A>, left:B):Either<B,A> return switch (o) 
  {
    case Some(v): Right(v);
    case None:    Left(left);
  }
  
  public static function eq <T>(a:Option<T>, b:Option<T>, eqT:T->T->Bool):Bool return switch (a) 
  {
    case None: switch (b) 
    {
      case None:     true;
      case Some(_):  false;
    }
    case Some(v1): switch (b) 
    {
      case None:     false;
      case Some(v2): eqT(v1, v2);
    }
  }
  
  public static inline function isSome <T>(o:Option<T>):Bool return switch (o) 
  {
    case Some(_): true;
    case None:    false;
  }
  
  public static inline function isNone <T>(o:Option<T>):Bool 
  {
    return !isSome(o);
  }
    
  public static  function extract <T>(o:Option<T>):T return switch (o) 
  {
    case Some(v): v;
    case None:    Scuts.error("Cannot extract value from Option None");
  }
  
  
  public static function filter <T> (o:Option<T>, filter:T->Bool):Option<T> return switch (o) 
  {
    case Some(v): if (filter(v)) Some(v) else None;
    case None:    None;
  }
  
  public static function ifSome <A,B> (o:Option<A>, ifVal:Void->Option<B>, elseVal:Void->Option<B>):Option<B>
  {
    return if (o.isSome()) ifVal() else elseVal();
  }
  
  public static function ifNone <A,B> (o:Option<A>, ifVal:Void->Option<B>, elseVal:Void->Option<B>):Option<B>
  {
    return if (o.isNone()) ifVal() else elseVal();
  }
  
  public static function flatten <T> (o:Option<Option<T>>):Option<T> return switch (o) 
  {
    case Some(v): v;
    case None:    None;
  }
  
  public static function flatMap < S, T > (o:Option<S>, f:S->Option<T>):Option<T> return switch (o) 
  {
    case Some(v): f(v);
    case None:    None;
  }
  
  public static function map < S, T > (o:Option<S>, f:S->T):Option<T> return switch (o) 
  {
    case Some(v): Some(f(v));
    case None:    None;
  }
  
  public static function each < A> (o:Option<A> , f:A->Void):Void switch (o) 
  {
    case None:
    case Some(s): f(s);
  }
  
  
  public static function toString <A> (o:Option<A>, ?aToString:A->String) 
  {
    var toStr = aToString == null ? Std.string : aToString;
    return switch (o) 
    {
      case Some(v): "Some(" + toStr(v) + ")";
      case None:    "None";
    }
  }
  
}

class OptionDynamicConversions 
{
  /** 
   * Converts v into a Some.
   */
  public static inline function toOption < T > (v:T):Option<T> 
  {
    #if debug
    if (v == null) Scuts.error("Cannot wrap null into an Option, use nullToOption instead");
    #end
    return Some(v);
  }
  
  /**
   * Converts v into an Option, based on the nulliness of v.
   */
  public static inline function nullToOption < T > (v:T):Option<T> 
  {
    return v != null ? Some(v) : None;
  }
}