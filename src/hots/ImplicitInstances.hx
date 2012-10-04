package hots;
import hots.classes.Applicative;
import hots.classes.Arrow;
import hots.classes.Category;
import hots.classes.Eq;
import hots.classes.Foldable;
import hots.classes.Functor;
import hots.classes.Monad;
import hots.classes.MonadZero;
import hots.classes.Monoid;
import hots.classes.Ord;
import hots.classes.Pure;
import hots.classes.Semigroup;
import hots.classes.Show;
import hots.extensions.Eqs;
import hots.In;
import hots.instances.ArrayOrd;
import hots.instances.ArrayPure;
import hots.instances.ArrayTPure;
import hots.instances.BoolOrd;
import hots.instances.ImListApplicative;
import hots.instances.ImListFoldable;
import hots.instances.ImListFunctor;
import hots.instances.ImListMonad;
import hots.instances.ImListMonadZero;
import hots.instances.ImListMonadZero;
import hots.instances.ImListPure;
import hots.instances.ImListShow;
import hots.instances.LazyListApplicative;
import hots.instances.LazyListFunctor;
import hots.instances.LazyListMonad;
import hots.instances.LazyListMonadZero;
import hots.instances.LazyListPure;
import hots.instances.LazyListShow;
import hots.instances.LazyTFunctor;
import hots.instances.OptionMonadZero;
import hots.instances.OptionOrd;
import hots.instances.OptionPure;
import hots.instances.OptionTPure;
import hots.instances.PromisePure;
import hots.instances.StateApplicative;
import hots.instances.StateFunctor;
import hots.instances.StateMonad;
import hots.instances.StatePure;
import hots.instances.Tup2Ord;
import hots.instances.ValidationMonad;
import hots.instances.ValidationPure;
import hots.instances.ValidationTPure;
import scuts.core.types.Either;
import scuts.core.types.ImList;
import scuts.core.types.LazyList;
import scuts.core.types.LazyList;
import scuts.core.types.State;
import scuts.core.types.Tup3;



import hots.instances.ArrayEq;
import hots.instances.ArrayMonoid;
import hots.instances.ArrayApplicative;
import hots.instances.ArrayFoldable;
import hots.instances.ArrayFunctor;
import hots.instances.ArrayMonad;
import hots.instances.ArrayMonadZero;
import hots.instances.ArraySemigroup;
import hots.instances.ArrayShow;
import hots.instances.ArrayTApplicative;
import hots.instances.ArrayTFunctor;
import hots.instances.ArrayTMonad;
import hots.instances.BoolEq;
import hots.instances.DateEq;
import hots.instances.DateOrd;
import hots.instances.DualMonoid;
import hots.instances.DualSemigroup;
import hots.instances.EitherEq;
import hots.instances.EitherSemigroup;
import hots.instances.EndoMonoid;
import hots.instances.EndoSemigroup;
import hots.instances.FloatEq;
import hots.instances.FloatOrd;
import hots.instances.FloatShow;
import hots.instances.FunctionArrow;
import hots.instances.FunctionCategory;
import hots.instances.IntEq;
import hots.instances.IntNum;
import hots.instances.IntOrd;
import hots.instances.IntProductMonoid;
import hots.instances.IntProductSemigroup;
import hots.instances.IntShow;
import hots.instances.IntSumMonoid;
import hots.instances.IntSumSemigroup;
import hots.instances.KleisliArrow;
import hots.instances.KleisliCategory;
import hots.instances.LazyListFoldable;
import hots.instances.OptionEq;
import hots.instances.OptionMonoid;
import hots.instances.OptionApplicative;
import hots.instances.OptionFunctor;
import hots.instances.OptionMonad;
import hots.instances.OptionSemigroup;
import hots.instances.OptionShow;
import hots.instances.OptionTApplicative;
import hots.instances.OptionTFunctor;
import hots.instances.OptionTMonad;
import hots.instances.PromiseApplicative;
import hots.instances.PromiseFunctor;
import hots.instances.PromiseMonad;
import hots.instances.PromiseMonadZero;
import hots.instances.StringEq;
import hots.instances.StringMonoid;
import hots.instances.StringOrd;
import hots.instances.StringSemigroup;
import hots.instances.StringShow;
import hots.instances.Tup2Eq;
import hots.instances.Tup2Semigroup;
import hots.instances.Tup3Semigroup;
import hots.instances.ValidationEq;
import hots.instances.ValidationApplicative;
import hots.instances.ValidationFunctor;
import hots.instances.ValidationSemigroup;
import hots.instances.ValidationTApplicative;
import hots.instances.ValidationTFunctor;
import hots.instances.ValidationTMonad;

import scuts.core.types.Option;
import scuts.core.types.Promise;
import scuts.core.types.Tup2;
import scuts.core.types.Validation;

import hots.extensions.Shows;

import hots.Of;

/****
 * 
 * 
 * 
 * This Module Provides implicit objects for various types from scuts and the haxe standard libary. The Objects class
 * is used as a storage for the various kinds of instances
 * 
 * 
 * 
 */
class Objects 
{
  
  // eqs
  @:implicit public static var floatOrd     (default, null):Ord<Float>  = new FloatOrd(floatEq);
  @:implicit public static var floatEq      (default, null):Eq<Float> = new FloatEq();
  
  @:implicit public static var intEq        (default, null):Eq<Int> = new IntEq();
  
  @:implicit public static var boolEq       (default, null):Eq<Bool> = new BoolEq();
  @:implicit public static var stringEq     (default, null):Eq<String> = new StringEq();
  @:implicit public static var dateEq       (default, null):Eq<Date> = new DateEq(floatEq);
  
  @:implicit public static function eitherEq <A,B>(eq1:Eq<A>, eq2:Eq<B>):Eq<Either<A,B>> return new EitherEq(eq1, eq2)
  @:implicit public static function tup2Eq   <A,B>(eq1:Eq<A>, eq2:Eq<B>):Eq<Tup2<A,B>> return new Tup2Eq(eq1, eq2)
  @:implicit public static function tup3Eq   <A,B,C>(eq1, eq2, eq3):Eq<Tup3<A,B,C >> 
  {
    var eq = function (a:Tup3<A,B,C>, b:Tup3<A,B,C>) {
      return eq1.eq(a._1, b._1) && eq2.eq(a._2, b._2) && eq3.eq(a._3, b._3);
    }
    return Eqs.create(eq);
  }
  @:implicit public static function optionEq <T>(eqT:Eq<T>):Eq<Option<T>>      return new OptionEq(eqT)
  @:implicit public static function arrayEq  <T>(eqT:Eq<T>):Eq<Array<T>>      return new ArrayEq(eqT)
  @:implicit public static function validationEq  <F,S>(eqF:Eq<F>,eqS:Eq<S>):Eq<Validation<F,S>> return new ValidationEq(eqF,eqS)
  
  // show
  @:implicit public static var stringShow                (default, null):Show<String> = new StringShow();
  @:implicit public static var intShow                   (default, null):Show<Int> = new IntShow();
  @:implicit public static var floatShow                 (default, null):Show<Float> = new FloatShow();
  
  @:implicit public static function lazyListShow          <T>(showT:Show<T>):Show<LazyList<T>>        return new LazyListShow(showT)
  @:implicit public static function imListShow            <T>(showT:Show<T>):Show<ImList<T>>        return new ImListShow(showT)
  @:implicit public static function arrayShow             <T>(showT:Show<T>):Show<Array<T>>        return new ArrayShow(showT)
  @:implicit public static function optionShow            <T>(showT:Show<T>):Show<Option<T>>        return new OptionShow(showT)
  
  @:implicit public static function tup2Show         <A,B>(show1:Show<A>, show2:Show<B>):Show<Tup2<A,B>> 
  {
    return Shows.create(function (t:Tup2<A,B>) return "(" + show1.show(t._1) + ", " + show2.show(t._2) + ")");
  }
  
  @:implicit public static function validationShow        <F,S>(showF, showS):Show<Validation<F,S>> 
  {
    return Shows.create(function (v) return switch (v) 
    { 
      case Success(s): "Success(" + showS.show(s) + ")";
      case Failure(f): "Failure(" + showF.show(f) + ")";
    });
  }
  // num
  
  @:implicit public static var intNum       (default, null) = new IntNum(intEq, intShow);
  
  // ords
  
  @:implicit public static var intOrd       (default, null):Ord<Int>  = new IntOrd(intEq);
  
  @:implicit public static var stringOrd    (default, null)  = new StringOrd(stringEq);
  @:implicit public static var dateOrd      (default, null)  = new DateOrd(dateEq, floatOrd);
  @:implicit public static var boolOrd       (default, null) = new BoolOrd(boolEq);
  
  @:implicit public static function optionOrd       <A>(a:Ord<A>) return new OptionOrd(a, optionEq(a))
  @:implicit public static function arrayOrd       <A>(a:Ord<A>) return new ArrayOrd(a, arrayEq(a))
  @:implicit public static function tup2Ord       <A,B>(a:Ord<A>, b:Ord<B>) return new Tup2Ord(a,b, tup2Eq(a,b))
  // functor
  
  @:implicit public static var optionFunctor          (default, null):Functor<Option<In>> = new OptionFunctor();
  
  @:implicit public static function stateFunctor          <S>():Functor<S->Tup2<S,In>> return new StateFunctor()
  
  
  @:implicit public static var promiseFunctor          (default, null):Functor<Promise<In>> = new PromiseFunctor();
  @:implicit public static var arrayFunctor           (default, null):Functor<Array<In>> = new ArrayFunctor();
  @:implicit public static var lazyListFunctor           (default, null):Functor<LazyList<In>> = new LazyListFunctor();
  @:implicit public static var imListFunctor           (default, null):Functor<ImList<In>> = new ImListFunctor();
  @:implicit public static function validationFunctor  <F>():Functor<Validation<F,In>> return new ValidationFunctor()
  
  @:implicit public static function lazyTFunctor          <M>(f:Functor<M>):Functor<Void->Of<M,In>> return new LazyTFunctor(f)
  
  @:implicit public static function arrayTFunctor     <M>(base:Functor<M>):Functor<Of<M, Array<In>>> return new ArrayTFunctor(base)
  @:implicit public static function optionTFunctor    <M>(base:Functor<M>):Functor<Of<M, Option<In>>> return new OptionTFunctor(base)
  @:implicit public static function validationTFunctor    <M, F>(base:Functor<M>):Functor<Of<M, Validation<F, In>>> return new ValidationTFunctor(base)
  
  // pure
  @:implicit public static var promisePure         (default, null):Pure<Promise<In>> = new PromisePure();
  @:implicit public static var optionPure          (default, null):Pure<Option<In>> = new OptionPure();
  @:implicit public static var arrayPure           (default, null):Pure<Array<In>> = new ArrayPure();
  @:implicit public static var lazyListPure        (default, null):Pure<LazyList<In>> = new LazyListPure();
  @:implicit public static var imListPure          (default, null):Pure<ImList<In>> = new ImListPure();
  @:implicit public static function validationPure <F>():Pure<Validation<F,In>> return new ValidationPure()
  
  @:implicit public static function statePure <S>():Pure<S->Tup2<S,In>> return new StatePure()
  
  @:implicit public static function arrayTPure        <M>(base:Pure<M>):Pure<Of<M, Array<In>>> return new ArrayTPure(base)
  @:implicit public static function optionTPure       <M>(base:Pure<M>):Pure<Of<M, Option<In>>> return new OptionTPure(base)
  @:implicit public static function validationTPure   <M,F>(base:Pure<M>):Pure<Of<M, Validation<F,In>>> return new ValidationTPure(base)
  
  // applicatives
  
  @:implicit public static var arrayApplicative            (default, null):Applicative<Array<In>> = new ArrayApplicative(arrayPure, arrayFunctor);
  @:implicit public static var promiseApplicative          (default, null):Applicative<Promise<In>> = new PromiseApplicative(promisePure, promiseFunctor);
  @:implicit public static var optionApplicative           (default, null):Applicative<Option<In>> = new OptionApplicative(optionPure, optionFunctor);
  @:implicit public static var lazyListApplicative         (default, null):Applicative<LazyList<In>> = new LazyListApplicative(lazyListPure, lazyListFunctor);
  @:implicit public static var imListApplicative           (default, null):Applicative<ImList<In>> = new ImListApplicative(imListPure, imListFunctor);
  
  @:implicit public static function stateApplicative           <S>():Applicative<State<S,In>> return new StateApplicative(statePure(), stateFunctor())
  
  @:implicit public static function validationApplicative <F>(semiFailure:Semigroup<F>):Applicative<Validation<F,In>> 
    return new ValidationApplicative(semiFailure,validationPure(), validationFunctor())
  
  @:implicit public static function arrayTApplicative  <M>(base:Applicative<M>):Applicative<Of<M,Array<In>>>  
    return new ArrayTApplicative(base, arrayTPure(base), arrayTFunctor(base))
    
  @:implicit public static function optionTApplicative <M>(base:Applicative<M>):Applicative<Of<M,Option<In>>>
    return new OptionTApplicative(base, optionTPure(base), optionTFunctor(base))
    
  @:implicit public static function validationTApplicative <M,F>(base:Applicative<M>):Applicative<Of<M,Validation<F,In>>>
    return new ValidationTApplicative(base, validationTPure(base), validationTFunctor(base))
  
  
  
  // monads
  @:implicit public static var arrayMonad                (default, null):Monad<Array<In>> = new ArrayMonad(arrayApplicative);
  @:implicit public static var optionMonad               (default, null):Monad<Option<In>> = new OptionMonad(optionApplicative);
  @:implicit public static var promiseMonad              (default, null):Monad<Promise<In>> = new PromiseMonad(promiseApplicative);
  @:implicit public static var lazyListMonad             (default, null):Monad<LazyList<In>> = new LazyListMonad(lazyListApplicative);
  @:implicit public static var imListMonad               (default, null):Monad<ImList<In>> = new ImListMonad(imListApplicative);
  
  @:implicit public static function stateMonad           <S>():Monad<State<S,In>> return new StateMonad(stateApplicative())
  
  @:implicit public static function validationMonad  <F>(semiFailure:Semigroup<F>):Monad<Validation<F,In>> 
    return new ValidationMonad(semiFailure, validationApplicative(semiFailure))
  
  @:implicit public static function arrayTMonad      <M>(base:Monad<M>):Monad<Of<M, Array<In>>>  return new ArrayTMonad(base, arrayTApplicative(base))
  @:implicit public static function optionTMonad     <M>(base:Monad<M>):Monad<Of<M, Option<In>>> return new OptionTMonad(base, optionTApplicative(base))
  @:implicit public static function validationTMonad <M,F>(base:Monad<M>):Monad<Of<M, Validation<F, In>>> return new ValidationTMonad(base, validationTApplicative(base))
  
  // monadZeros
  @:implicit public static var arrayMonadZero         (default, null):MonadZero<Array<In>> = new ArrayMonadZero(arrayMonad);
  @:implicit public static var promiseMonadZero         (default, null):MonadZero<Promise<In>> = new PromiseMonadZero(promiseMonad);
  @:implicit public static var lazyListMonadZero         (default, null):MonadZero<LazyList<In>> = new LazyListMonadZero(lazyListMonad);
  @:implicit public static var imListMonadZero         (default, null):MonadZero<ImList<In>> = new ImListMonadZero(imListMonad);
  @:implicit public static var optionMonadZero         (default, null):MonadZero<Option<In>> = new OptionMonadZero(optionMonad);
  // categories
  @:implicit public static var functionCategory       (default, null):Category<In->In> = new FunctionCategory();
  @:implicit public static function kleisliCategory   (m) return new KleisliCategory(m)
  
  // arrows
  @:implicit public static var functionArrow          (default, null):Arrow<In->In> = new FunctionArrow(functionCategory);
  
  @:implicit public static function kleisliArrow      <M>(m:Monad<M>):Arrow<In->Of<M, In>> return new KleisliArrow(m, kleisliCategory(m))
  
  // semigroups
  @:implicit public static function arraySemigroup <T>():Semigroup<Array<T>> return new ArraySemigroup()
  
  @:implicit public static var intSumSemigroup           (default, null):Semigroup<Int> = new IntSumSemigroup(intNum);
  @:implicit public static var stringSemigroup           (default, null):Semigroup<String> = new StringSemigroup();
  public static var intProductSemigroup       (default, null) = new IntProductSemigroup();
  @:implicit public static var endoSemigroup             (default, null) = new EndoSemigroup();
  
  public static function dualSemigroup       (semiT)        return new DualSemigroup(semiT)
  
  @:implicit public static function eitherSemigroup     <L,R>(semiL, semiR):Semigroup<Either<L,R>>        return new EitherSemigroup(semiL, semiR)
  @:implicit public static function tup2Semigroup       <A,B>(semi1, semi2):Semigroup<Tup2<A,B>>        return new Tup2Semigroup(semi1, semi2)
  @:implicit public static function tup3Semigroup       <A,B,C>(semi1:Semigroup<A>, semi2:Semigroup<B>, semi3:Semigroup<C>):Semigroup<Tup3<A,B,C>> return new Tup3Semigroup(semi1, semi2, semi3)
  @:implicit public static function validationSemigroup <F,S>(semiF, semiS):Semigroup<Validation<F,S>>        return new ValidationSemigroup(semiF, semiS)
  @:implicit public static function optionSemigroup     (semiT)               return new OptionSemigroup(semiT)
  
  // monoid
  @:implicit public static var intSumMonoid              (default, null):Monoid<Int> = new IntSumMonoid(intSumSemigroup);
  
  public static var intProductMonoid          (default, null) = new IntProductMonoid(intProductSemigroup);
  
  @:implicit public static function arrayMonoid               <T>():Monoid<Array<T>> return new ArrayMonoid(arraySemigroup())
  
  @:implicit public static var stringMonoid              (default, null):Monoid<String> = new StringMonoid(stringSemigroup);
  @:implicit public static var endoMonoid                (default, null) = EndoMonoid.endo();
  
  @:implicit public static function optionMonoid <T>(semiT:Semigroup<T>):Monoid<Option<T>> return new OptionMonoid(optionSemigroup(semiT))
  @:implicit public static function dualMonoid   (monoidT) return new DualMonoid(monoidT, dualSemigroup(monoidT))
  
  // foldables
  @:implicit public static var arrayFoldable             (default, null):Foldable<Array<In>> = new ArrayFoldable();
  @:implicit public static var lazyListFoldable          (default, null):Foldable<LazyList<In>> = new LazyListFoldable();
  @:implicit public static var imListFoldable          (default, null):Foldable<ImList<In>> = new ImListFoldable();
  
  
}