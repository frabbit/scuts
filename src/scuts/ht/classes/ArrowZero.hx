package scuts.ht.classes;

/**
 * The Arrow type class in Haskell:
 * 
 * class Category a => Arrow a where
 *
 *   -- | Lift a function to an arrow.
 *   arr :: (b -> c) -> a b c
 *
 *   -- | Send the first component of the input through the argument
 *   --   arrow, and copy the rest unchanged to the output.
 *   first :: a b c -> a (b,d) (c,d)
 *
 *   -- | A mirror image of 'first'.
 *   --
 *   --   The default definition may be overridden with a more efficient
 *   --   version if desired.
 *   second :: a b c -> a (d,b) (d,c)
 *   second f = arr swap >>> first f >>> arr swap
 *     where
 *       swap :: (x,y) -> (y,x)
 *       swap ~(x,y) = (y,x)
 *
 *   -- | Split the input between the two argument arrows and combine
 *   --   their output.  Note that this is in general not a functor.
 *   --
 *   --   The default definition may be overridden with a more efficient
 *   --   version if desired.
 *   (***) :: a b c -> a b' c' -> a (b,b') (c,c')
 *   f *** g = first f >>> second g
 *
 *   -- | Fanout: send the input to both argument arrows and combine
 *   --   their output.
 *   --
 *   --   The default definition may be overridden with a more efficient
 *   --   version if desired.
 *   (&&&) :: a b c -> a b c' -> a b (c,c')
 *   f &&& g = arr (\b -> (b,b)) >>> f *** g
 */

import scuts.ht.core.OfOf;

import scuts.core.Tup2;
import scuts.Scuts;


interface ArrowZero<AR> extends Arrow<AR> 
{
  public function zero <B,C>():OfOf<AR, B, C>;
}