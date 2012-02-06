package hots;

/**
 * In is a Marker that represents an inner type inside of a type constructor, 
 * it corresponds to * in haskell
 * The haskel representation m a is translated to Of<M, A>
 * and m1 m2 a is translated to Of<Of<M1, M2>, A>
 * It should never occur in the real output, however there is problem that whenever a concrete 
 * type is used in code like FastList<In> a special version of this class is generated if the class
 * implements haxe.rtti.Generic, so we leave this type in the output
 * A concrete type like Option a is therefor represented by Of<Option<In>, A>.
 * erasure on all targets.
 * 
 * 
 *
 */
class In {}