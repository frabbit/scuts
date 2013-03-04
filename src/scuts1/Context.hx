
package hots;

import scuts1.classes.MonadOr;

typedef Of<M,A> = scuts1.core.Of<M,A>;
typedef OfOf<M,A,B> = scuts1.core.OfOf<M,A,B>;
typedef In = scuts1.core.In;

typedef MonadInstances = scuts1.instances.Monads;
typedef BindInstances = scuts1.instances.Binds;
typedef SemigroupInstances = scuts1.instances.Semigroups;
typedef ArrowInstances = scuts1.instances.Arrows;
typedef FunctorInstances = scuts1.instances.Functors;
typedef EqInstances = scuts1.instances.Eqs;
typedef ShowInstances = scuts1.instances.Shows;
typedef MonoidInstances = scuts1.instances.Monads;
typedef CategoryInstances = scuts1.instances.Categorys;
typedef ApplyInstances = scuts1.instances.Applys;
typedef PureInstances = scuts1.instances.Pures;

typedef Pures = scuts1.syntax.Pures;
typedef Monads = scuts1.syntax.Monads;
typedef Applys = scuts1.syntax.Applys;
typedef Functors = scuts1.syntax.Functors;
typedef Eqs = scuts1.syntax.Eqs;
typedef Shows = scuts1.syntax.Shows;
typedef Binds = scuts1.syntax.Binds;
typedef Foldables = scuts1.syntax.Foldables;
typedef Applicatives = scuts1.syntax.Applicatives;
typedef Monoids = scuts1.syntax.Monoids;
typedef Semigroups = scuts1.syntax.Semigroups;
typedef Ords = scuts1.syntax.Ords;
typedef Categories = scuts1.syntax.Categorys;
typedef Arrows = scuts1.syntax.Arrows;

typedef Do = scuts1.syntax.Do;

typedef ArrayTransformer = scuts1.syntax.Transformers.ArrayTransformer;
typedef PromiseTransformer = scuts1.syntax.Transformers.PromiseTransformer;
typedef ValidationTransformer = scuts1.syntax.Transformers.ValidationTransformer;
typedef LazyTransformer = scuts1.syntax.Transformers.LazyTransformer;
typedef OptionTransformer = scuts1.syntax.Transformers.OptionTransformer;

typedef FunctionSyntax = scuts1.syntax.FunctionSyntax;

typedef Arrow<X> = scuts1.classes.Arrow<X>;
typedef Monad<X> = scuts1.classes.Monad<X>;
typedef MonadEmpty<X> = scuts1.classes.MonadEmpty<X>;
typedef MonadOr<X> = scuts1.classes.MonadOr<X>;
typedef MonadPlus<X> = scuts1.classes.MonadPlus<X>;
typedef Pointed<X> = scuts1.classes.Pointed<X>;
typedef Semigroup<X> = scuts1.classes.Semigroup<X>;
typedef Monoid<X> = scuts1.classes.Monoid<X>;
typedef Pure<X> = scuts1.classes.Pure<X>;
typedef Bind<X> = scuts1.classes.Bind<X>;
typedef Functor<X> = scuts1.classes.Functor<X>;
typedef Num<X> = scuts1.classes.Num<X>;
typedef Ord<X> = scuts1.classes.Ord<X>;
typedef Eq<X> = scuts1.classes.Eq<X>;
typedef Zero<X> = scuts1.classes.Zero<X>;
typedef Apply<X> = scuts1.classes.Apply<X>;

typedef Hots = scuts1.core.Hots;
