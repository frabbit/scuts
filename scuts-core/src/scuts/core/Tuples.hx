
package scuts.core;

class Tuples {
  @:noUsing public static function tup2 <A,B>(a:A, b:B):Tup2<A,B> {
    return Tup2.create(a,b);
  }

  @:noUsing public static function tup3 <A,B,C>(_1:A, _2:B, _3:C) 
  {
    return Tup3.create(_1, _2, _3);
  }

  @:noUsing public static function tup4 <A,B,C,D>(_1:A, _2:B, _3:C, _4:D) 
  {
    return Tup4.create(_1, _2, _3, _4);
  }

  @:noUsing public static function tup5 <A,B,C,D,E>(_1:A, _2:B, _3:C, _4:D, _5:E) 
  {
    return Tup5.create(_1, _2, _3, _4, _5);
  }

  @:noUsing public static function tup6 <A,B,C,D,E,F>(_1:A, _2:B, _3:C, _4:D, _5:E, _6:F) 
  {
    return Tup6.create(_1, _2, _3, _4, _5, _6);
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
  
  public static inline function first  <A,B>(t:Tup2<A,B>) return t._1;
  public static inline function second <A,B>(t:Tup2<A,B>) return t._2;
  

  public static inline function into <A,B,C>(t:Tup2<A,B>, f:A->B->C) return f(t._1, t._2);


  /**
   * Compares two tuples for equality based on equal functions for the parameter types.
   */
  public static function eq <A,B>(t1:Tup2<A,B>, t2:Tup2<A,B>, eq1:A->A->Bool, eq2:B->B->Bool) {
    return eq1(t1._1, t2._1) && eq2(t1._2, t2._2);
  }
}

class Tup3s 
{
  /**
   * Swaps the first 2 values of `t`.
   * 
   * `Tup3.create(1,2,3).swap(); // (2,1,3)`
   */
  public static function swap <A,B,C>(t:Tup3<A,B,C>) return Tup3.create(t._2, t._1, t._3);
  
  public static inline function first  <A,B,C>(t:Tup3<A,B,C>) return t._1;
  public static inline function second <A,B,C>(t:Tup3<A,B,C>) return t._2;
  public static inline function third <A,B,C>(t:Tup3<A,B,C>) return t._3;
  

  public static inline function into <A,B,C,D>(t:Tup3<A,B,C>, f:A->B->C->D) return f(t._1, t._2, t._3);


  /**
   * Compares two tuples for equality based on equal functions for the parameter types.
   */
  public static function eq <A,B,C>(t1:Tup3<A,B,C>, t2:Tup3<A,B,C>, eq1:A->A->Bool, eq2:B->B->Bool, eq3:C->C->Bool) {
    return eq1(t1._1, t2._1) && eq2(t1._2, t2._2) && eq3(t1._3, t2._3);
  }
}

class Tup4s 
{
  /**
   * Swaps the first 2 values of `t`.
   * 
   * `Tup3.create(1,2,3).swap(); // (2,1,3)`
   */
  public static function swap <A,B,C,D>(t:Tup4<A,B,C,D>) return Tup4.create(t._2, t._1, t._3,t._4);
  
  public static inline function first  <A,B,C,D>(t:Tup4<A,B,C,D>) return t._1;
  public static inline function second <A,B,C,D>(t:Tup4<A,B,C,D>) return t._2;
  public static inline function third <A,B,C,D>(t:Tup4<A,B,C,D>) return t._3;
  public static inline function fourth <A,B,C,D>(t:Tup4<A,B,C,D>) return t._4;
  

  public static inline function into <A,B,C,D,E>(t:Tup4<A,B,C,D>, f:A->B->C->D->E) return f(t._1, t._2, t._3,t._4);


  /**
   * Compares two tuples for equality based on equal functions for the parameter types.
   */
  public static function eq <A,B,C,D>(t1:Tup4<A,B,C,D>, t2:Tup4<A,B,C,D>, eq1:A->A->Bool, eq2:B->B->Bool, eq3:C->C->Bool, eq4:D->D->Bool) {
    return eq1(t1._1, t2._1) && eq2(t1._2, t2._2) && eq3(t1._3, t2._3) && eq4(t1._4, t2._4);
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
