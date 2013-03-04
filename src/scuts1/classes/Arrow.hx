package scuts1.classes;

import scuts1.core.OfOf;

import scuts.core.Tuples;
import scuts.Scuts;

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
interface Arrow<AR> extends Category<AR>
{
  /**
   * Lifts a Function into an Arrow (from Haskell Source)
   * 
   * haskell: arr :: (b -> c) -> a b c
   */
  public function arr <B,C>(f:B->C):OfOf<AR,B, C>;
  
  /**
   * Send the first component of the input through the argument
   * arrow, and copy the rest unchanged to the output. (from Haskell Source)
   * 
   * haskell: first :: a b c -> a (b,d) (c,d)
   */
  public function first <B,C,D>(f:OfOf<AR,B,C>):OfOf<AR, Tup2<B,D>, Tup2<C,D>>;
  
  /**
   * Send the second component of the input through the argument
   * arrow, and copy the rest unchanged to the output. (from Haskell Source)
   * 
   * haskell: second :: a b c -> a (d,b) (d,c)
   */
  public function second <B,C,D>(f:OfOf<AR,B, C>):OfOf<AR, Tup2<D,B>, Tup2<D,C>>;
  
  /**
   * Split the input between the two argument arrows and combine
   * their output.  Note that this is in general not a functor. (from Haskell Source)
   * 
   * haskell: (***) :: a b c -> a b' c' -> a (b,b') (c,c')
   */
  public function split <B,B1, C,C1,D >(f:OfOf<AR,B, C>, g:OfOf<AR, B1, C1>):OfOf<AR, Tup2<B,B1>, Tup2<C,C1>>;
  
  /**
   * Fanout: send the input to both argument arrows and combine
   * their output. (from Haskell Source)
   * 
   * haskell: (&&&) :: a b c -> a b c' -> a b (c,c')
   */
  public function fanout <B,C, C1>(f:OfOf<AR,B, C>, g:OfOf<AR, B, C1>):OfOf<AR, B, Tup2<C,C1>>;

}

