package scuts1.classes;

import scuts1.classes.Applicative;
import scuts1.core.Of;


import scuts.Scuts;


interface Monad<M> extends Applicative<M> extends Bind<M>
{
  
  /**
   * flattens a nested monadic value.
   * 
   * aka: join
   */
  public function flatten <A> (x:Of<M, Of<M,A>>):Of<M,A>;
}

















