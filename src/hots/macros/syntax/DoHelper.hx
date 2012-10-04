package hots.macros.syntax;
import hots.classes.Monad;
import hots.classes.MonadZero;



class DoHelper 
{

  public static inline function getMonadZero <M,A>(o:hots.Of<M,A>):MonadZero<M> return null
  
  public static inline function getMonad <M,A>(o:hots.Of<M,A>):Monad<M> return null
  
}