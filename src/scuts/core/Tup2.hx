package scuts.core;

class Tup2<A,B> 
{
  public var _1(default, null):A;
  public var _2(default, null):B;
  
  function new (_1:A, _2:B) 
  {
    this._1 = _1;
    this._2 = _2;
  }
  
  public static function create <A,B>(_1:A, _2:B) 
  {
    return new Tup2<A,B>(_1, _2);
  }
  
  public function toString () 
  {
    var s = Std.string;
    return "(" + s(_1) + "," + s(_2) + ")";
  }
}
