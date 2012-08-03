package scuts.core.types;

using scuts.core.extensions.Functions;

class Io<T>
{
  public var unsafePerformIo(default, null) : Void->T;
  
  public function new (unsafe : Void->T) 
  {
    this.unsafePerformIo = unsafe;
  }
}
