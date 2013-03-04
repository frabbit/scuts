package scuts1.macros.syntax;
import scuts1.classes.Monad;
import scuts1.classes.MonadEmpty;




class DoHelper 
{

  public static inline function getMonadEmpty <M,A>(o:scuts1.core.Of<M,A>):MonadEmpty<M> return null;
  
  public static inline function getMonad <M,A>(o:scuts1.core.Of<M,A>):Monad<M> return null;
  
}