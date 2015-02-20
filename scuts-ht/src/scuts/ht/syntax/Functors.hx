package scuts.ht.syntax;



import scuts.ht.classes.Functor;

class Functors
{

  public static inline function map <F,A,B> (x:F<A>, f:A->B, functor:Functor<F>):F<B>
  	return functor.map(x, f);



}