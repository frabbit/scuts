package hots;

import hots.Of;
/**
 * Represents a type constructor that needs two types to construct a real type.
 */
#if flash
@:native('Object')
#else
@:native('Dynamic')
#end
typedef OfOf<M,A,B> = Of<OfT<M, A>, B>;



