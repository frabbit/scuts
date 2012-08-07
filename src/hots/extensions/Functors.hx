package hots.extensions;
import hots.Of;


import hots.classes.Functor;

class Functors 
{
  public static inline function map <F,A,B> (of:Of<F, A>, f:A->B, m:Functor<F>):Of<F,B> return m.map(of, f)
}