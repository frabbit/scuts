package scuts.core;

class Tup6<A,B,C,D,E,F> 
{
  
  public var _1(default, null):A;
  public var _2(default, null):B;
  public var _3(default, null):C;
  public var _4(default, null):D;
  public var _5(default, null):E;
  public var _6(default, null):F;
  
  function new (_1:A, _2:B, _3:C, _4:D, _5:E,_6:F) 
  {
    this._1 = _1;
    this._2 = _2;
    this._3 = _3;
    this._4 = _4;
    this._5 = _5;
    this._6 = _6;
  }
  
  public static function create <A,B,C,D,E,F>(_1:A, _2:B, _3:C, _4:D, _5:E, _6:F) 
  {
    return new Tup6(_1, _2, _3, _4, _5, _6);
  }
  
  public function toString () 
  {
    var s = Std.string;
    
    return "(" + s(_1) + ","
               + s(_2) + "," 
               + s(_3) + "," 
               + s(_4) + "," 
               + s(_5) + "," 
               + s(_6) + ")";
  }
  
}
