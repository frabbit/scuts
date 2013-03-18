package scuts.ht.core;

/**
 * In is a Marker type that allows the representation
 * of a parametric type as a type constructor.
 * 
 * f.e. the type constructor Array must be represented as Array<In>
 */
abstract In(Dynamic) {
	function new (x) this = x;

}