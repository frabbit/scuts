package scuts;


typedef Tup2<A,B> = scuts.core.types.Tup2<A,B>;
typedef Tup3<A,B,C> = scuts.core.types.Tup3<A,B,C>;
typedef Tup4<A,B,C,D> = scuts.core.types.Tup4<A,B,C,D>;
typedef Tup5<A,B,C,D,E> = scuts.core.types.Tup5<A,B,C,D,E>;

typedef Either<Left, Right> = scuts.core.types.Either<Left, Right>;
typedef FailureOrSuccess<Failure, Success> = Either<Failure, Success>;


typedef Option<T> = scuts.core.types.Option<T>;

typedef ProgressiveFuture<T> = scuts.core.types.ProgressiveFuture<T>;

typedef LazyIterator<T> = scuts.core.types.LazyIterator<T>;

typedef Ordering = scuts.core.types.Ordering;
