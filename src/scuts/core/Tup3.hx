package scuts.core;


class Tup3<A,B,C> 
{
  public var _1(default, null):A;
  public var _2(default, null):B;
  public var _3(default, null):C;
  
  function new (_1:A, _2:B, _3:C) 
  {
    this._1 = _1;
    this._2 = _2;
    this._3 = _3;
  }
  
  public static function create <A,B,C>(_1:A, _2:B, _3:C) 
  {
    return new Tup3(_1, _2, _3);
  }
  
  public function toString () 
  {
    var s = Std.string;
    return "(" + s(_1) + "," + s(_2) + "," + s(_3) + ")";
  }
  
  
}
