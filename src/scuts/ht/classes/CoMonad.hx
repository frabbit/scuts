package scuts.ht.classes;
import scuts.ht.core.Of;
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
interface CoMonad<W> extends CoJoin<W> extends CoBind<W> extends CoPure<W>
{
  //public function coJoin <A>(f:Of<W,A>):Of<W, Of<W, A>>;
}