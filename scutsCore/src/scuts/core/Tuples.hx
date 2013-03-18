
package scuts.core;

class Tuples {
  public static function tup2 <A,B>(a:A, b:B):Tup2<A,B> {
    return Tup2.create(a,b);
  }

  public static function tup3 <A,B,C>(_1:A, _2:B, _3:C) 
  {
    return Tup3.create(_1, _2, _3);
  }

  public static function tup4 <A,B,C,D>(_1:A, _2:B, _3:C, _4:D) 
  {
    return Tup4.create(_1, _2, _3, _4);
  }
}

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

class Tup5<A,B,C,D,E> 
{
  public var _1(default, null):A;
  public var _2(default, null):B;
  public var _3(default, null):C;
  public var _4(default, null):D;
  public var _5(default, null):E;
  
  function new (_1:A, _2:B, _3:C, _4:D, _5:E) 
  {
    this._1 = _1;
    this._2 = _2;
    this._3 = _3;
    this._4 = _4;
    this._5 = _5;
  }
  public static function create <A,B,C,D, E>(_1:A, _2:B, _3:C, _4:D, _5:E) 
  {
    return new Tup5(_1, _2, _3, _4, _5);
  }
  public function toString () 
  {
    var s = Std.string;
    return "(" +s( _1) + "," + s(_2) + "," + s(_3) + "," + s(_4) + "," + s(_5) + ")";
  }
  
}

class Tup2s 
{
  /**
   * Swaps the values of a tuple.
   * 
   * Tup2.create(1,2).swap(); // (2,1)
   */
  public static function swap <A,B>(t:Tup2<A,B>) return Tup2.create(t._2, t._1);
  
  public static function first  <A,B>(t:Tup2<A,B>) return t._1;
  public static function second <A,B>(t:Tup2<A,B>) return t._2;
  
  /**
   * Compares two tuples for equality based on equal functions for the parameter types.
   */
  public static function eq <A,B>(t1:Tup2<A,B>, t2:Tup2<A,B>, eq1:A->A->Bool, eq2:B->B->Bool) {
    return eq1(t1._1, t2._1) && eq2(t1._2, t2._2);
  }
}

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
