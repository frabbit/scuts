package hots.classes;
import hots.OfOf;
import hots.TC;
import scuts.core.types.Tup2;
import scuts.Scuts;


interface ArrowZero<AR> implements Arrow<AR>, implements TC 
{
  public function zero <B,C>():OfOf<AR, B, C>;
}