package hots.classes;

import hots.classes.Applicative;
import hots.Of;


import scuts.Scuts;


interface Monad<M> implements Applicative<M>, implements Bind<M>
{
  
  /**
   * flattens a nested monadic value.
   * 
   * aka: join
   */
  public function flatten <A> (x:Of<M, Of<M,A>>):Of<M,A>;
}

















