package hots.classes;

import hots.OfOf;
import hots.TC;
import scuts.core.types.Tup2;
import scuts.Scuts;

interface Arrow<AR> implements Category<AR>, implements TC
{
  public function arr <B,C>(f:B->C):OfOf<AR,B, C>;
  
  public function first <B,C,D>(f:OfOf<AR,B,C>):OfOf<AR, Tup2<B,D>, Tup2<C,D>>;
  
  public function second <B,C,D>(f:OfOf<AR,B, C>):OfOf<AR, Tup2<D,B>, Tup2<D,C>>;
  
  public function split <B,B1, C,C1,D >(f:OfOf<AR,B, C>, g:OfOf<AR, B1, C1>):OfOf<AR, Tup2<B,B1>, Tup2<C,C1>>;
  
  public function fanout <B,C, C1>(f:OfOf<AR,B, C>, g:OfOf<AR, B, C1>):OfOf<AR, B, Tup2<C,C1>>;

}

