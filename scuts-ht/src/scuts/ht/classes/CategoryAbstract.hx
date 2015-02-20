package scuts.ht.classes;

import scuts.Scuts;



class CategoryAbstract<Cat> implements Category<Cat>
{
  public function id <A>(a:A):Cat<A, A> return Scuts.abstractMethod();
  /**
   * aka (.)
   */
  public function dot <A,B,C>(g:Cat<B, C>, f:Cat<A, B>):Cat<A, C> return Scuts.abstractMethod();

  /**
   * aka >>>
   */
  public function next <A,B,C>(f:Cat<A, B>, g:Cat<B, C>):Cat<A, C> return dot(g,f);

  /**
   * aka <<<
   */
  public function back <A,B,C>(g:Cat<B, C>, f:Cat<A, B>):Cat<A, C> return dot(g,f);

}
