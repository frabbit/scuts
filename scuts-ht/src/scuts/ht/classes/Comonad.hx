package scuts.ht.classes;
import scuts.ht.classes.Cobind;
import scuts.ht.classes.Cojoin;
import scuts.ht.classes.Copure;
import scuts.Scuts;




 //class Comonad w where
 // (=>>) :: w a -> (w a -> b) -> w b haskell extract :: w a -> a

 /*
  *
 class Functor w => Comonad w where
  extract   :: w a -> a
  duplicate :: w a -> w (w a)
  extend    :: (w a -> b) -> (w a -> w b)

  extend f  = fmap f . duplicate
  duplicate = extend id

*/
interface Comonad<W> extends Cojoin<W> extends Cobind<W> extends Copure<W>
{
  //public function coJoin <A>(f:W<A>):Of<W, Of<W, A>>;
}