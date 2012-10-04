package hots;

/**
 * In is a Marker type that can used to provide implicit objects for the using context.
 * 
 * To provide an implicit Eq-Instance you have to create a function with one parameter
 * that takes as a first parameter a variable of this type combined with the real type class instance
 * type. 
 * 
 * f.e. Myprovider works this way, it takes a parameter of ImplicitObject parametrized with the
 * type class instance Eq<Array<T>> and returns exactly the inner type of ImplicitObject.
 * 
 * class MyProvider
 * {
 *    public static inline function implicitObj <T>(_:ImplicitObject<Eq<Array<T>>>, eqT:Eq<T>):Eq<Array<T>> return myArrayEq
 * }
 * 
 */
class ImplicitObject<X> {}