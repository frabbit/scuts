package hots.macros.syntax;
import hots.classes.Monad;
import hots.classes.MonadEmpty;




class DoHelper 
{

  public static inline function getMonadEmpty <M,A>(o:hots.Of<M,A>):MonadEmpty<M> return null
  
  public static inline function getMonad <M,A>(o:hots.Of<M,A>):Monad<M> return null
  
}