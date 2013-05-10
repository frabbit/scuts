
package scuts.ht;

import scuts.ht.classes.MonadOr;

typedef Of<M,A> = scuts.ht.core.Of<M,A>;
typedef OfOf<M,A,B> = scuts.ht.core.OfOf<M,A,B>;
typedef In = scuts.ht.core.In;

typedef ShowInstances = scuts.ht.instances.Shows;
typedef MonadInstances = scuts.ht.instances.Monads;
typedef MonadEmptyInstances = scuts.ht.instances.MonadEmptys;
typedef ApplicativeInstances = scuts.ht.instances.Applicatives;
typedef BindInstances = scuts.ht.instances.Binds;
typedef SemigroupInstances = scuts.ht.instances.Semigroups;
typedef ArrowInstances = scuts.ht.instances.Arrows;
typedef FunctorInstances = scuts.ht.instances.Functors;
typedef EqInstances = scuts.ht.instances.Eqs;

typedef MonoidInstances = scuts.ht.instances.Monoids;
typedef CategoryInstances = scuts.ht.instances.Categorys;
typedef ApplyInstances = scuts.ht.instances.Applys;
typedef PureInstances = scuts.ht.instances.Pures;
typedef OrdInstances = scuts.ht.instances.Ords;
typedef NumInstances = scuts.ht.instances.Nums;

typedef FoldableInstances = scuts.ht.instances.Foldables;

typedef Pures = scuts.ht.syntax.Pures;
typedef PuresM = scuts.ht.syntax.PuresM;

typedef Applicatives = scuts.ht.syntax.Applicatives;
typedef ApplicativesM = scuts.ht.syntax.ApplicativesM;
typedef Monads = scuts.ht.syntax.Monads;
typedef MonadsM = scuts.ht.syntax.MonadsM;
typedef Applys = scuts.ht.syntax.Applys;
typedef ApplysM = scuts.ht.syntax.ApplysM;
typedef Functors = scuts.ht.syntax.Functors;
typedef FunctorsM = scuts.ht.syntax.FunctorsM;


typedef Eqs = scuts.ht.syntax.Eqs;
typedef EqsM = scuts.ht.syntax.EqsM;

typedef Binds = scuts.ht.syntax.Binds;
typedef BindsM = scuts.ht.syntax.BindsM;
typedef Foldables = scuts.ht.syntax.Foldables;
typedef FoldablesM = scuts.ht.syntax.FoldablesM;
typedef Shows = scuts.ht.syntax.Shows;
typedef ShowsM = scuts.ht.syntax.ShowsM;


typedef Semigroups = scuts.ht.syntax.Semigroups;
typedef SemigroupsM = scuts.ht.syntax.SemigroupsM;
typedef Ords = scuts.ht.syntax.Ords;
typedef OrdsM = scuts.ht.syntax.OrdsM;

typedef Nums = scuts.ht.syntax.Nums;
typedef NumsM = scuts.ht.syntax.NumsM;
typedef Categorys = scuts.ht.syntax.Categorys;
typedef CategorysM = scuts.ht.syntax.CategorysM;
typedef Arrows = scuts.ht.syntax.Arrows;
typedef ArrowsM = scuts.ht.syntax.ArrowsM;


typedef Do = scuts.ht.syntax.Do;


//typedef Transformers = scuts.ht.syntax.Transformers;
typedef ArrayTransformer = scuts.ht.syntax.Transformers.ArrayTransformer;
typedef PromiseTransformer = scuts.ht.syntax.Transformers.PromiseTransformer;
typedef ValidationTransformer = scuts.ht.syntax.Transformers.ValidationTransformer;
typedef LazyTransformer = scuts.ht.syntax.Transformers.LazyTransformer;
typedef OptionTransformer = scuts.ht.syntax.Transformers.OptionTransformer;

typedef FunctionSyntax = scuts.ht.syntax.FunctionSyntax;

typedef Arrow<X> = scuts.ht.classes.Arrow<X>;
typedef Foldable<X> = scuts.ht.classes.Foldable<X>;
typedef Applicative<X> = scuts.ht.classes.Applicative<X>;
typedef Monad<X> = scuts.ht.classes.Monad<X>;
typedef MonadEmpty<X> = scuts.ht.classes.MonadEmpty<X>;
typedef MonadOr<X> = scuts.ht.classes.MonadOr<X>;
typedef MonadPlus<X> = scuts.ht.classes.MonadPlus<X>;
typedef Semigroup<X> = scuts.ht.classes.Semigroup<X>;
typedef Monoid<X> = scuts.ht.classes.Monoid<X>;
typedef Pure<X> = scuts.ht.classes.Pure<X>;
typedef Bind<X> = scuts.ht.classes.Bind<X>;
typedef Functor<X> = scuts.ht.classes.Functor<X>;
typedef Num<X> = scuts.ht.classes.Num<X>;
typedef Ord<X> = scuts.ht.classes.Ord<X>;
typedef Eq<X> = scuts.ht.classes.Eq<X>;
typedef Zero<X> = scuts.ht.classes.Zero<X>;
typedef Apply<X> = scuts.ht.classes.Apply<X>;
typedef Show<X> = scuts.ht.classes.Show<X>;


typedef Ht = scuts.ht.core.Ht;


typedef FunctionBoxing = scuts.ht.core.Boxing.FunctionBoxing;