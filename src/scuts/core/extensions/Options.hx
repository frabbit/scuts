package scuts.core.extensions;

import haxe.PosInfos;
import scuts.core.types.Option;
import scuts.core.types.Either;
import scuts.Scuts;

using scuts.core.extensions.Options;

using scuts.core.extensions.Predicates;

class Options {

  public static function getOrElseConst <T>(o:Option<T>, elseValue:T):T
  {
    return switch (o) 
    {
      case Some(v): v;
      case None: elseValue;
    }
  }
  
  public static function orElse <T>(o:Option<T>, elseValue:Void->Option<T>):Option<T>
  {
    return switch (o) 
    {
      case Some(_): o;
      case None: elseValue();
    }
  }
  
  public static function orNull <T>(o:Option<T>):Null<T>
  {
    return switch (o) 
    {
      case Some(v): v;
      case None: null;
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
  
  public static function getOrError <T>(o:Option<T>, error:String, ?posInfos:PosInfos):T
  {
    return switch (o) 
    {
      case Some(v): v;
      case None: Scuts.error(error,posInfos);
    }
  }
  
  public static function toLeftConst <A,B>(o:Option<A>, right:B):Either<A,B>
  {
    return switch (o) 
    {
      case Some(v): Left(v);
      case None: Right(right);
    }
  }
  
  public static function toLeft <A,B>(o:Option<A>, right:Void->B):Either<A,B>
  {
    return switch (o) 
    {
      case Some(v): Left(v);
      case None: Right(right());
    }
  }
  
  public static function toRight <A,B>(o:Option<A>, left:Void->B):Either<B,A>
  {
    return switch (o) 
    {
      case Some(v): Right(v);
      case None: Left(left());
    }
  }
  
  public static function toRightConst <A,B>(o:Option<A>, left:B):Either<B,A>
  {
    return switch (o) 
    {
      case Some(v): Right(v);
      case None: Left(left);
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
  
  public static inline function isSome <T>(o:Option<T>):Bool {
    return switch (o) {
      case Some(_): true;
      case None: false;
    }
  }
  
  public static inline function isNone <T>(o:Option<T>):Bool {
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
  
  public static function ifSome <A,B> (o:Option<A>, ifVal:Void->Option<B>, elseVal:Void->Option<B>):Option<B>
  {
    return if (o.isSome()) ifVal() else elseVal();
  }
  
  public static function ifNone <A,B> (o:Option<A>, ifVal:Void->Option<B>, elseVal:Void->Option<B>):Option<B>
  {
    return if (o.isNone()) ifVal() else elseVal();
  }
  
  public static function flatten <T> (o:Option<Option<T>>):Option<T>
  {
    return switch (o) {
      case Some(v): v;
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
  
  public static function each < A> (o:Option<A> , f:A->Void):Void {
    switch (o) {
      case None:
      case Some(s): f(s);
    }
  }
  
  public static function withFilter <A> (o:Option<A>, filter:A->Bool) {
    return new WithFilter(o,filter);
  }
  
  public static function toString <A> (o:Option<A>, ?toStringA:A->String) {
    var toStr = toStringA == null ? Std.string : toStringA;
    return switch (o) {
      case Some(v): "Some(" + toStr(v) + ")";
      case None: "None";
    }
  }
  
}

private class WithFilter<A> 
{
  private var filter:A -> Bool;
  private var o:Option<A>;
  
  public function new (o:Option<A>, filter:A->Bool) {
    this.o = o;
    this.filter = filter;
  }
  
  public function flatMap <B>(f:A->Option<B>):Option<B> return o.filter(filter).flatMap(f)
  public function map <B>(f:A->B):Option<B> return o.filter(filter).map(f)
  public function withFilter (f:A->Bool):WithFilter<A> return o.withFilter(filter.and(f))
}

class OptionDynamicConversions {
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
  
  /**
   * Converts v into an Option, based on the nulliness of v.
   */
  public static inline function nullToOption < T > (v:T):Option<T> {
    return v != null ? Some(v) : None;
  }
}