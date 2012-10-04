package hots;

import hots.Of;
/**
 * Represents a type constructor that needs two types to construct a real type.
 * 
 * f.e. Int->String can be represented as OfOf<In->In, Int, String>
 * 
 */

typedef OfOf<M,A,B> = Of<Of<M, A>, B>;



