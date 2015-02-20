package scuts.core;

import scuts.core.Tuples;

@:callable abstract State<ST,X>(ST->Tup2<ST, X>)
{

  public function new (f:ST->Tup2<ST, X>) this = f;

  public function run ():ST->Tup2<ST, X> return this;
}

class States
{

  public static function map<ST,A,B>(x:State<ST,A>, f:A->B):State<ST,B>
  {
    return new State(function (s:ST)
    {
      var t = x(s);
      return Tup2.create(t._1, f(t._2));
    });
  }

  @:noUsing public static function pure<ST, A>(x:A):State<ST,A>
  {
    return new State(function (s:ST) return Tup2.create(s, x));
  }

  public static function flatMap<ST,A,B>(x:State<ST,A>, f: A->State<ST,B>):State<ST,B>
  {
    return new State(function (s:ST) {
      var z = x(s);
      return f(z._2)(z._1);
    });
  }
}