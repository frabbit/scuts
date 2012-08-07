package hots;


// Of is like a newtype, it's compiled as Dynamic, but at compilation time it is a full featured type.
#if flash
@:native('Object')
#else
@:native('Dynamic')
#end
class Of<M,A> {}