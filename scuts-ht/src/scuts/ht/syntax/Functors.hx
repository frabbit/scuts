package scuts.ht.syntax;

import scuts.ht.core.Of;


import scuts.ht.classes.Functor;

class Functors 
{
  
  public static inline function map <F,A,B> (x:Of<F, A>, f:A->B, functor:Functor<F>):Of<F,B> 
  	return functor.map(x, f);
  
  

}