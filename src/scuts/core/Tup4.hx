package scuts.core;


class Tup4<A,B,C,D> 
{
  public var _1(default, null):A;
  public var _2(default, null):B;
  public var _3(default, null):C;
  public var _4(default, null):D;
  
  function new (_1:A, _2:B, _3:C, _4:D) 
  {
    this._1 = _1;
    this._2 = _2;
    this._3 = _3;
    this._4 = _4;
  }
  public static function create <A,B,C,D>(_1:A, _2:B, _3:C, _4:D) 
  {
    return new Tup4(_1, _2, _3, _4);
  }
  public function toString () 
  {
    var s = Std.string;
    return "(" + s(_1) + "," + s(_2) + "," + s(_3) + "," + s(_4) + ")";
  }
  
  
}
