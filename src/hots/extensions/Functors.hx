package hots.extensions;
import hots.Of;


import hots.classes.Functor;

class Functors 
{
  public static inline function map <M,A,B> (of:Of<M, A>, f:A->B, m:Functor<M>):Of<M,B> return m.map(of, f)
}