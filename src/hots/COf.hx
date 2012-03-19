package hots;

import hots.Of;
/**
 * Represents a type constructor that needs two types to create a real type.
 */
typedef OfOf<M,A,B> = Of<Of<M, A>, B>;

typedef COf<M, A, B> = OfOf<M,A,B>;

