package scuts.core.extensions;

import scuts.core.types.Io;

using scuts.core.extensions.Functions;

class Ios 
{
  public static function map<A,B>(a:Io<A>, f:A->B):Io<B>
  {
    return new Io(a.unsafePerformIo.map(f));
  }
  
  public static function pure<A>(a:A):Io<A>
  {
    return new Io(function () return a);
  }
  
  public static function flatMap<A,B>(a:Io<A>, f:A->Io<B>):Io<B>
  {
    return new Io(a.unsafePerformIo.flatMap(function (a) return f(a).unsafePerformIo));
  }
}