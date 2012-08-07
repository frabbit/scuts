package hots;



// other types
typedef Option<T> = scuts.core.types.Option<T>;

typedef Resolver = hots.macros.Resolver;

// classes
typedef Functor<T> = hots.classes.Functor<T>;
typedef Applicative<T> = hots.classes.Applicative<T>;
typedef Monad<T> = hots.classes.Monad<T>;
typedef MonadTrans<T> = hots.classes.MonadTrans<T>;
typedef Monoid<T> = hots.classes.Monoid<T>;
typedef Foldable<T> = hots.classes.Foldable<T>;
typedef Arrow<T> = hots.classes.Arrow<T>;
typedef ArrowZero<T> = hots.classes.ArrowZero<T>;
typedef Category<T> = hots.classes.Category<T>;




// Array
typedef ArrayEq = hots.instances.ArrayEq;
typedef ArrayMonoid = hots.instances.ArrayMonoid;
typedef ArrayRead = hots.instances.ArrayRead;
typedef ArrayShow = hots.instances.ArrayShow;

// ArrayOf
typedef ArrayTBox = hots.instances.ArrayTBox;
typedef ArrayBox = hots.instances.ArrayBox;
typedef ArrayOf<X> = hots.instances.ArrayOf<X>;
typedef ArrayOfMonad = hots.instances.ArrayOfMonad;
typedef ArrayOfFunctor = hots.instances.ArrayOfFunctor;
typedef ArrayOfFoldable = hots.instances.ArrayOfFoldable;
typedef ArrayOfCollection = hots.instances.ArrayOfCollection;
typedef ArrayOfMonadTrans = hots.instances.ArrayOfMonadTrans;
typedef ArrayOfMonoid = hots.instances.ArrayOfMonoid;
typedef ArrayOfPointed = hots.instances.ArrayOfPointed;
typedef ArrayOfApplicative = hots.instances.ArrayOfApplicative;


// ArrayTOf

typedef ArrayTOf<M,X> = hots.instances.ArrayTOf<M,X>;
typedef ArrayTOfFunctor = hots.instances.ArrayTOfFunctor;
typedef ArrayTOfApplicative = hots.instances.ArrayTOfApplicative;
typedef ArrayTOfMonad = hots.instances.ArrayTOfMonad;

// Option
typedef OptionMonoid = hots.instances.OptionMonoid;

// OptionOf

typedef OptionTBox = hots.instances.OptionTBox;
typedef OptionBox = hots.instances.OptionBox;
typedef OptionOf<X> = hots.instances.OptionOf<X>;
typedef OptionOfMonad = hots.instances.OptionOfMonad;
typedef OptionOfFunctor = hots.instances.OptionOfFunctor;

// OptionTOf
typedef OptionTOf<M,X> = hots.instances.OptionTOf<M,X>;

typedef OptionTOfApplicative = hots.instances.OptionTOfApplicative;
typedef OptionTOfFunctor = hots.instances.OptionTOfFunctor;
typedef OptionTOfMonad = hots.instances.OptionTOfMonad;
typedef OptionTOfMonadZero = hots.instances.OptionTOfMonadZero;
typedef OptionTOfPointed = hots.instances.OptionTOfPointed;

// String
typedef StringOrd = hots.instances.StringOrd;
typedef StringEq = hots.instances.StringEq;
typedef StringMonoid = hots.instances.StringMonoid;

// Kleisli
typedef KleisliOf<M,A,B> = hots.instances.KleisliOf<M,A,B>;
typedef KleisliArrow = hots.instances.KleisliArrow;


// Int
typedef IntSumMonoid = hots.instances.IntSumMonoid;

// Tuples
typedef Tup2Monoid = hots.instances.Tup2Monoid;
typedef Tup3Monoid = hots.instances.Tup3Monoid;


// Float
//typedef FloatMonoid = hots.instances.FloatMonoid;


typedef Predicate1Monoid = hots.instances.Predicate1Monoid;


// boxing
typedef KleisliBox = hots.instances.KleisliBox;
typedef FunctionBox = hots.instances.FunctionBox;

typedef ListBox = hots.instances.ListBox;
typedef ListOfFoldable = hots.instances.ListOfFoldable;
typedef ListOfCollection = hots.instances.ListOfCollection;

// types

typedef Tup2LeftOf<L,R> = hots.instances.Tup2LeftOf<L,R>;
typedef ListOf<X> = hots.instances.ListOf<X>;



// Extensions

typedef OfOfExt = hots.extensions.OfOfExt;

