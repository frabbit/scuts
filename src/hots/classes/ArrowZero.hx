package hots.classes;
import hots.COf;
import hots.TC;
import scuts.core.types.Tup2;
import scuts.Scuts;


interface ArrowZero<AR> implements Arrow<AR>, implements TC 
{
  public function zero <B,C>():COf<AR, B, C>;
}