package hots.classes;

/**
 * ...
 * @author 
 */

interface Extend<W> implements Functor<W>
{
  public function extend <A,B>(f:Of<W,A>->B ):Of<W,A>->Of<W,B>;
  
  public function duplicate<A,B>(val:Of<W,A>):Of<W, Of<W,A>>;
  
 
  
}