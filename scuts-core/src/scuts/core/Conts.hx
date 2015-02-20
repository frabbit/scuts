package scuts.core;
import scuts.core.Conts;

using scuts.core.Functions;


@:callable abstract Cont<R, A>((A->R)->R) {
  public function new (x:(A->R)->R) this = x;
  public function run ():(A->R)->R return this;
}

class Conts
{
  public static function map<R,B,C>(x:Cont<R,B>, f:B->C):Cont<R,C>
  {
    return new Cont(function (z : C->R):R return x( z.compose(f)));
  }

  public static function flatMap<R,B,C>(x:Cont<R,B>, f:B->Cont<R,C>):Cont<R,C>
  {
    return new Cont(function (z : C->R):R {

      return x( function (b) return f(b)(z) );
    });
  }



  public static function pure<R,X>(x:X):Cont<R,X>
  {
    return new Cont(function (z : X->R):R {
      return z(x);
    });
  }

  public static function apply<R,A,B>(f:Cont<R,A->B>, v:Cont<R,A>):Cont<R,B>
  {
    function z (g:A->B) return map(v, function (x) return g(x));
    return flatMap( f, z);
  }


}