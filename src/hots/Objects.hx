package hots;
import hots.classes.Applicative;
import hots.classes.Applicative;
import hots.classes.Arrow;
import hots.classes.Eq;
import hots.classes.Functor;
import hots.classes.Monad;
import hots.classes.MonadZero;
import hots.classes.Monoid;
import hots.classes.Pointed;
import hots.classes.Semigroup;
import hots.classes.Show;
import hots.extensions.Shows;
import hots.instances.ArrayEq;
import hots.instances.ArrayMonoid;
import hots.instances.ArrayOfApplicative;
import hots.instances.ArrayOfFoldable;
import hots.instances.ArrayOfFunctor;
import hots.instances.ArrayOfMonad;
import hots.instances.ArrayOfMonadZero;
import hots.instances.ArrayOfPointed;
import hots.instances.ArraySemigroup;
import hots.instances.ArrayShow;
import hots.instances.ArrayTOfApplicative;
import hots.instances.ArrayTOfFunctor;
import hots.instances.ArrayTOfMonad;
import hots.instances.ArrayTOfPointed;
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
import hots.instances.LazyListOfFoldable;
import hots.instances.LazyListOfFoldable;
import hots.instances.OptionEq;
import hots.instances.OptionMonoid;
import hots.instances.OptionOfApplicative;
import hots.instances.OptionOfFunctor;
import hots.instances.OptionOfMonad;
import hots.instances.OptionOfPointed;
import hots.instances.OptionSemigroup;
import hots.instances.OptionShow;
import hots.instances.OptionTOfApplicative;
import hots.instances.OptionTOfFunctor;
import hots.instances.OptionTOfMonad;
import hots.instances.OptionTOfMonad;
import hots.instances.OptionTOfPointed;
import hots.instances.StringEq;
import hots.instances.StringMonoid;
import hots.instances.StringOrd;
import hots.instances.StringSemigroup;
import hots.instances.StringShow;
import hots.instances.Tup2Eq;
import hots.instances.Tup2Semigroup;
import hots.instances.Tup3Semigroup;
import hots.instances.ValidationEq;
import hots.instances.ValidationOfApplicative;
import hots.instances.ValidationOfFunctor;
import hots.instances.ValidationOfPointed;
import hots.instances.ValidationSemigroup;
import hots.instances.ValidationTOfApplicative;
import hots.instances.ValidationTOfFunctor;
import hots.instances.ValidationTOfMonad;
import hots.instances.ValidationTOfPointed;
import scuts.core.types.Option;
import scuts.core.types.Tup2;
import scuts.core.types.Validation;

import hots.Of;

class Objects 
{
  
   // eqs
  
  public static var floatEq      (default, null) = new FloatEq();
  public static var intEq        (default, null) = new IntEq();
  public static var boolEq       (default, null) = new BoolEq();
  public static var stringEq     (default, null) = new StringEq();
  public static var dateEq       (default, null) = new DateEq(floatEq);
  
  
  public static function eitherEq (eq1, eq2) return new EitherEq(eq1, eq2)
  public static function tup2Eq   (eq1, eq2) return new Tup2Eq(eq1, eq2)
  public static function optionEq (eqT)      return new OptionEq(eqT)
  public static function arrayEq  (eqT)      return new ArrayEq(eqT)
  public static function validationEq  <F,S>(eqF,eqS):Eq<Validation<F,S>> return new ValidationEq(eqF,eqS)
  
  // enumerations
  
  
  
  // show
  public static var stringShow                (default, null) = new StringShow();
  public static var intShow                   (default, null) = new IntShow();
  public static var floatShow                 (default, null) = new FloatShow();
  
  public static function arrayShow             (showT)        return new ArrayShow(showT)
  public static function optionShow            (showT)        return new OptionShow(showT)
  public static function tup2Show         <A,B>(show1, show2) return Shows.create(function (t:Tup2<A,B>) return "(" + show1.show(t._1) + ", " + show2.show(t._2) + ")")
  public static function validationShow        (showF, showS) {
    return Shows.create(function (v) return switch (v) 
    { 
      case Success(s): "Success(" + showS.show(s) + ")";
      case Failure(f): "Failure(" + showF.show(f) + ")";
    });
  }
  // num
  
  public static var intNum       (default, null) = new IntNum(intEq, intShow);
  
  // ords
  
  public static var intOrd       (default, null)  = new IntOrd(intEq);
  public static var floatOrd     (default, null)  = new FloatOrd(floatEq);
  public static var stringOrd    (default, null)  = new StringOrd(stringEq);
  public static var dateOrd      (default, null)  = new DateOrd(dateEq, floatOrd);
  
  // functor
  
  public static var optionFunctor          (default, null) = new OptionOfFunctor();
  public static var arrayFunctor           (default, null) = new ArrayOfFunctor();
  public static var validationFunctor      (default, null) = new ValidationOfFunctor();
  
  public static function arrayTFunctor     <M>(base:Functor<M>) return new ArrayTOfFunctor(base)
  public static function optionTFunctor    <M>(base:Functor<M>) return new OptionTOfFunctor(base)
  public static function validationTFunctor    <M>(base:Functor<M>) return new ValidationTOfFunctor(base)
  
  // pointeds
  
  public static var optionPointed          (default, null) = new OptionOfPointed(optionFunctor);
  public static var arrayPointed           (default, null) = new ArrayOfPointed(arrayFunctor);
  public static var validationPointed      (default, null) = new ValidationOfPointed(validationFunctor);
  
  public static function arrayTPointed     <M>(base:Pointed<M>) return new ArrayTOfPointed(base, arrayTFunctor(base))
  public static function optionTPointed    <M>(base:Pointed<M>) return new OptionTOfPointed(base, optionTFunctor(base))
  public static function validationTPointed    <M>(base:Pointed<M>) return new ValidationTOfPointed(base, validationTFunctor(base))
  
  // applicatives
  
  public static var arrayApplicative           (default, null) = new ArrayOfApplicative(arrayPointed);
  public static var optionApplicative          (default, null) = new OptionOfApplicative(optionPointed);
  public static function validationApplicative (semiFailure) return new ValidationOfApplicative(semiFailure,validationPointed)
  
  public static function arrayTApplicative  <M>(base:Applicative<M>) return new ArrayTOfApplicative(base, arrayTPointed(base))
  public static function optionTApplicative <M>(base:Applicative<M>) return new OptionTOfApplicative(base, optionTPointed(base))
  public static function validationTApplicative <M>(base:Applicative<M>) return new ValidationTOfApplicative(base, validationTPointed(base))
  
  
  
  // monads
  public static var arrayMonad                (default, null) = new ArrayOfMonad(arrayApplicative);
  public static var optionMonad               (default, null) = new OptionOfMonad(optionApplicative);
  
  public static function arrayTMonad      <M>(base:Monad<M>)  return new ArrayTOfMonad(base, arrayTApplicative(base))
  public static function optionTMonad     <M>(base:Monad<M>) return new OptionTOfMonad(base, optionTApplicative(base))
  public static function validationTMonad <M>(base:Monad<M>) return new ValidationTOfMonad(base, validationTApplicative(base))
  
  // monadZeros
  public static var arrayMonadZero         (default, null) = new ArrayOfMonadZero(arrayMonad);
  
  // categories
  public static var functionCategory       (default, null) = new FunctionCategory();
  
  public static function kleisliCategory   (m) return new KleisliCategory(m)
  
  // arrows
  public static var functionArrow          (default, null) = new FunctionArrow(functionCategory);
  
  public static function kleisliArrow      (m) return new KleisliArrow(m, kleisliCategory(m))
  
  
  
  // semigroups
  public static var arraySemigroup            (default, null) = new ArraySemigroup();
  public static var intSumSemigroup           (default, null) = new IntSumSemigroup(intNum);
  public static var stringSemigroup           (default, null) = new StringSemigroup();
  public static var intProductSemigroup       (default, null) = new IntProductSemigroup();
  public static var endoSemigroup             (default, null) = new EndoSemigroup();
  
  public static function dualSemigroup       (semiT)        return new DualSemigroup(semiT)
  
  public static function eitherSemigroup     (semiL, semiR)        return new EitherSemigroup(semiL, semiR)
  public static function tup2Semigroup       (semi1, semi2)        return new Tup2Semigroup(semi1, semi2)
  public static function tup3Semigroup       (semi1, semi2, semi3) return new Tup3Semigroup(semi1, semi2, semi3)
  public static function validationSemigroup (semiF, semiS)        return new ValidationSemigroup(semiF, semiS)
  public static function optionSemigroup     (semiT)               return new OptionSemigroup(semiT)
  
  // monoid
  public static var intSumMonoid              (default, null) = new IntSumMonoid(intSumSemigroup);
  public static var intProductMonoid          (default, null) = new IntProductMonoid(intProductSemigroup);
  public static var arrayMonoid               (default, null) = new ArrayMonoid(arraySemigroup);
  
  public static var stringMonoid              (default, null) = new StringMonoid(stringSemigroup);
  public static var endoMonoid                (default, null) = EndoMonoid.endo();
  
  public static function optionMonoid (semiT)   return new OptionMonoid(optionSemigroup(semiT))
  public static function dualMonoid   (monoidT) return new DualMonoid(monoidT, dualSemigroup(monoidT))
  
  // foldables
  
  public static var arrayFoldable             (default, null) = new ArrayOfFoldable();
  public static var lazyListFoldable          (default, null) = new LazyListOfFoldable();
  
  
}

private typedef O = Objects.Objects;

// Monads

private typedef OptionIn = Option<In>;
private typedef ArrayIn = Array<In>;

private typedef IOMonad<T> = ImplicitObject<Monad<T>>;
private typedef IMonad<T> = Implicit<Monad<T>>;

private typedef IOEq<T> = ImplicitObject<Eq<T>>;
private typedef IEq<T> = Implicit<Eq<T>>;

class ArrayEq_Obj 
{
  public static inline function implicitObj <T>(_:IOEq<Array<T>>, eqT:IEq<T>):Eq<Array<T>> return O.arrayEq(eqT)
}
class OptionEq_Obj
{
  public static inline function implicitObj <T>(_:IOEq<Option<T>>,eqT:IEq<T>):Eq<Option<T>> return O.optionEq(eqT)
}
class ValidationEq_Obj 
{ 
  public static inline function implicitObj <F,S>(_:IOEq<Validation<F,S>>,eqF:IEq<F>, eqS:IEq<S>):Eq<Validation<F,S>> return O.validationEq(eqF,eqS) 
}

class Tup2Eq_Obj 
{ 
  public static inline function implicitObj <A,B>(_:IOEq<Tup2<A,B>>,eq1:IEq<A>, eq2:IEq<B>):Eq<Tup2<A,B>> return O.tup2Eq(eq1,eq2) 
}

class IntEq_Obj 
{
  public static inline function implicitObj <A,B>(_:IOEq<Int>) return O.intEq
}

class FloatEq_Obj 
{
  public static inline function implicitObj <A,B>(_:IOEq<Float>) return O.floatEq
}

class StringEq_Obj 
{
  public static inline function implicitObj <A,B>(_:IOEq<String>) return O.stringEq
}
/// SHOWS

private typedef IOShow<T> = ImplicitObject<Show<T>>;
private typedef IShow<T> = Implicit<Show<T>>;


class ValidationShow_Obj 
{
  public static inline function implicitObj <F,S>(_:IOShow<Validation<F,S>>, f:IShow<F>, s:IShow<S>) return O.validationShow(f,s)
}

class IntShow_Obj 
{
  public static inline function implicitObj (_:IOShow<Int>) return O.intShow
}

class Tup2Show_Obj 
{
  public static inline function implicitObj <A,B>(_:IOShow<Tup2<A,B>>,a:IShow<A>,b:IShow<B>):Show<Tup2<A,B>> return O.tup2Show(a,b)
}
class OptionShow_Obj 
{
  public static inline function implicitObj <T>(_:IOShow<Option<T>>,a:IShow<T>) return O.optionShow(a)
}
class String_Show_Obj 
{
  public static inline function implicitObj (_:IOShow<String>):Show<String> return O.stringShow
}

class Float_Show_Obj 
{
  public static inline function implicitObj <F,S>(_:IShow<Float>):Show<Float> return O.floatShow
}

////////////////////////////////

class ArrayOf_Monad_Obj 
{
  public static inline function implicitObj (_:IOMonad<ArrayIn>):Monad<ArrayIn>
  {
    return O.arrayMonad;
  }
}

class OptionOf_Monad_Obj
{
  public static inline function implicitObj (_:IOMonad<OptionIn>):Monad<OptionIn> 
  {
    return O.optionMonad;
  }
}


private typedef ValidationIn<F> = Validation<F,In>

// Monad Transformers

class OptionTOf_Monad_Obj
{
  public static inline function implicitObj <M>(_:IOMonad<Of<M,OptionIn>>, base: IMonad<M>):Monad<Of<M,OptionIn>> return O.optionTMonad(base)
}

class ValidationTOf_Monad_Obj
{
  public static inline function implicitObj <M,F>(_:IOMonad<Of<M,ValidationIn<F>>>, base: IMonad<M>):Monad<Of<M,ValidationIn<F>>> return O.validationTMonad(base)
}



class ArrayTOf_Monad_Obj
{
  public static inline function implicitObj <M>(_:IOMonad<Of<M,ArrayIn>>, base: IMonad<M>):Monad<Of<M,ArrayIn>> return O.arrayTMonad(base)
}

private typedef IArrow<X> = ImplicitObject<Arrow<X>>;


class FunctionArrowObj 
{
  public static inline function implicitObj (_:IArrow<In->In>):Arrow<In->In> return O.functionArrow
}


private typedef IMonZero<T> = ImplicitObject<MonadZero<T>>;


class ArrayOf_MonadZero_Obj 
{
  public static inline function implicitObj (_:IMonZero<Array<In>>):MonadZero<Array<In>> return O.arrayMonadZero
}









// Monoids

private typedef IMon<T> = ImplicitObject<Monoid<T>>;

class Int_Sum_Monoid_Obj
{

  public static inline function implicitObj (_:IMon<Int>):Monoid<Int> return O.intSumMonoid
}

class Array_Monoid_Obj 
{
  public static inline function implicitObj <T>(_:IMon<Array<T>>):Monoid<Array<T>> return O.arrayMonoid
}

class String_Monoid_Obj 
{
  public static inline function implicitObj <T>(_:IMon<String>) return O.stringMonoid
}



// Semigroups

private typedef IOSemi<T> = ImplicitObject<Semigroup<T>>
private typedef ISemi<T> = Implicit<Semigroup<T>>

class Int_Sum_Semigroup_Obj
{
  public static inline function implicitObj (_:IOSemi<Int>) return O.intSumSemigroup
}


private typedef IOSemiValid<F,S> = IOSemi<Validation<F,S>>

class Validation_Semigroup_Obj 
{
  public static inline function implicitObj <F,S>(_:IOSemiValid<F,S>, semiF:ISemi<F>, semiS:ISemi<S>) return O.validationSemigroup(semiF, semiS)
}

class StringSemigroupObj
{
  public static inline function implicitObj <T>(_:IOSemi<String>) return O.stringSemigroup
}

class OptionSemigroupImp
{
  public static inline function implicitObj <T>(_:IOSemi<Option<T>>, s:ISemi<T>) return O.optionSemigroup(s)
}