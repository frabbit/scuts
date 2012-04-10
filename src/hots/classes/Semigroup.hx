package hots.classes;
import hots.TC;

/**
 * ...
 * @author 
 */

interface Semigroup<A> implements TC 
{
  public function append (a1:A, a2:A):A;
}