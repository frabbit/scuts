package scuts.core;

import scuts.core.Io;

using scuts.core.Functions;

class Ios 
{
  public static function map<A,B>(a:Io<A>, f:A->B):Io<B>
  {
    return new Io(a.unsafePerformIo.map(f));
  }
  
  @:noUsing public static function pure<A>(a:A):Io<A>
  {
    return new Io(function () return a);
  }
  
  public static function flatMap<A,B>(a:Io<A>, f:A->Io<B>):Io<B>
  {
    return new Io(a.unsafePerformIo.flatMap(function (a) return f(a).unsafePerformIo));
  }
}