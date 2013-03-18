package scuts.core;



using scuts.core.Functions;


class Io<T>
{
  public var unsafePerformIo(default, null) : Void->T;
  
  public function new (unsafe : Void->T) 
  {
    this.unsafePerformIo = unsafe;
  }
}


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