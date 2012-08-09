package hots.classes;
import hots.OfOf;

import scuts.core.types.Tup2;
import scuts.Scuts;


interface ArrowZero<AR> implements Arrow<AR> 
{
  public function zero <B,C>():OfOf<AR, B, C>;
}