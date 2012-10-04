package hots;


/*
 * Represents a type constructor that needs one type to construct a real type.
 * 
 * f.e. Array<T> can be represented as Of<Array<In>, T>
 * 
 */

abstract Of<M,A> {}
