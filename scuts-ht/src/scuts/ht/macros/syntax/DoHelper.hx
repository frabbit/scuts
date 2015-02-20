package scuts.ht.macros.syntax;
import scuts.ht.classes.Monad;
import scuts.ht.classes.MonadEmpty;




class DoHelper
{

  public static inline function getMonadEmpty <M,A>(o:scuts.ht.core.M<A>):MonadEmpty<M> return null;

  public static inline function getMonad <M,A>(o:scuts.ht.core.M<A>):Monad<M> return null;

}