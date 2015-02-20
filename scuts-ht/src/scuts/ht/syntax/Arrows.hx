package scuts.ht.syntax;

import scuts.ht.classes.Arrow;
import scuts.ht.classes.Category;
import scuts.core.Tuples;

class Arrows
{

  public static function arr<A,B, AR>(f:A->B, a:Arrow<AR>):AR<A, B> return a.arr(f);

  public static function split <B,B1, C,C1,D, AR>(f:AR<B, C>, g:AR<B1, C1>, arr:Arrow<AR>):AR<Tup2<B,B1>, Tup2<C,C1>> return arr.split(f,g);

  public static function first <B,C,D, AR>(f:AR<B,C>, arr:Arrow<AR>):AR<Tup2<B,D>, Tup2<C,D>> return arr.first(f);

  public static function second <B,C,D, AR>(f:AR<B, C>, arr:Arrow<AR>):AR<Tup2<D,B>, Tup2<D,C>> return arr.second(f);

  public static function fanout <B,C, C1, AR>(f:AR<B, C>, g:AR<B, C1>, arr:Arrow<AR>):AR<B, Tup2<C,C1>> return arr.fanout(f,g);



}