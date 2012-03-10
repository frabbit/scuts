package hots;


/**
 * Represents a value of the Category Cat.
 */
//COf<In->Of<M, In>, A, B> => Of<Of<In->Of<M, In>,A>, B>;
import hots.Of;
typedef OfOf<M,A,B> = { 
  /**
   * Don't use this property directly.
   * Use box functions extract the real type.
   */
  __internal_hots_OfOf__:{m:M, t1:A, t2:B} 
  
}


typedef COf<M,A,B> = OfOf<M, A, B>


