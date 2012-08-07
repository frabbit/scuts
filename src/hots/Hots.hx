package hots;

#if !macro
import hots.classes.Arrow;
import hots.classes.MonadZero;
import hots.classes.Show;
import hots.instances.ArrayOfMonadZero;
import hots.instances.FloatShow;
import hots.instances.FunctionArrow;
import hots.instances.IntShow;
import hots.instances.OptionSemigroup;
import hots.instances.StringShow;


#end

#if macro

import scuts.Scuts;
import hots.macros.generators.GenEq;
import hots.macros.Implicits;
import hots.macros.Resolver;
import haxe.macro.Context;
import hots.macros.Registry;
import hots.macros.Box;
import haxe.macro.Expr;
import haxe.macro.Type;
import scuts.mcore.Print;
#end

private typedef Of_<M,A> = Dynamic;



class Identity 
{
  
  @:macro public static function flatMap <M,A,B>(e:ExprOf<Of_<M,A>>, f:ExprOf<A->Of_<M,B>>):ExprOf<Of_<M,B>> 
  {
    return Implicits.apply(macro hots.extensions.Monads.flatMap, [e,f]);
  }
  
  @:macro public static function filter <M,A>(e:ExprOf<Of_<M,A>>, f:ExprOf<A->Bool>):ExprOf<Of_<M,A>> 
  {
    return Implicits.apply(macro hots.extensions.MonadZeros.filter, [e,f]);
  }
  
  @:macro public static function map <M,A,B>(e:ExprOf<Of_<M,A>>, f:ExprOf<A->B>):ExprOf<Of_<M,B>> 
  {
    return Implicits.apply(macro hots.extensions.Monads.map, [e,f]);
  }
  
  
  @:macro public static function eq <T>(e1:ExprOf<T>, e2:ExprOf<T>):ExprOf<Bool> 
  {
    return Implicits.apply(macro hots.extensions.Eqs.eq, [e1,e2]);
  }

  @:macro public static function show <T>(e1:ExprOf<T>):ExprOf<String> 
  {
    return Implicits.apply(macro hots.extensions.Shows.show, [e1]);
  }
  /*
  @:macro public static function append <T>(e1:ExprOf<T>, e2:ExprOf<T>):ExprOf<T> 
  {
    return Implicits.apply(macro hots.extensions.Monoids.append, [e1,e2]);
  }
  */
  
}



class Hots 
{
  /*
  @:macro public static function tc(exprOrType:Expr, typeClass:ExprOf<Class<TC>>, ?contextInstances:ExprRequire<Array<TC>>) 
  {
    return Resolver.tc1(exprOrType, typeClass, contextInstances);
  }
  */
  
  @:macro public static function monoid(expr:Expr, ?supplied:Array<Expr>) 
  {
    if (supplied == null) supplied = [];
    var needed = macro { function get <T>(m:T, t:hots.classes.Monoid<T>) { }; get.curry()($expr); };
    return Implicits.getImplicitObj(needed, supplied, None);
  }
  
  @:macro public static function eq(exprOrType:Expr, ?contextInstances:ExprRequire<Array<TC>>) 
  {
    return Resolver.tc1(exprOrType, macro hots.classes.Eq, contextInstances );
  }
  
  
  @:noUsing @:macro public static function register():Array<Field> 
  {
    return Registry.buildClass();
  }
  /*
  @:macro public static function box(e:Expr, ?times:Int = 1) return Box.box(e, times)
  
  
  @:macro public static function boxF<A,B>(e:ExprRequire<A->B>, ?times:Int = 1) return Box.boxF(e, times)
  
  @:macro public static function unboxF<A,B,C>(e:Expr , ?times:Int = 1) return Box.unboxF(e, times)
    
  
  @:macro public static function unbox<A,B>(e:Expr , ?times:Int = 1) return Box.unbox(e, times)
  */
  
  @:macro public static function implicit (e:Array<Expr>):Expr return Implicits.register(e)
  
  @:macro public static function tc (type:String):Expr return Implicits.implicitType(type)
  
  @:macro public static function genEq (type:Expr):Type return GenEq.forType(type)
  
  @:macro public static function _ (f:Expr, ?params:Array<Expr>):Expr {
    
    return Implicits.apply(f, params);
  }
  
  
  @:macro public static function _box (o:ExprOf<Dynamic>, f:Expr, ?params:Array<Expr>):Expr 
  {
    // TODO this is a workaround, currently there is a compiler issue which reverses the first two arguments if params are supplied
    if (params != null) {
      var x = o;
      o = f;
      f = x;
    }
    
    
    if (params == null) params = [];
    
    var fun = switch (f.expr) {
      case EConst(c): switch (c) 
      {
        case CIdent(s):s;
        default: Scuts.macroError("parameter f must be an identifier for a function",f.pos);
      }
      default: Scuts.macroError("parameter f must be an identifier for a function", f.pos);
    }
    
    
    var p1 = macro var x = $o.box();
    
    var p2 = Context.parse("x." + fun, Context.currentPos());
    
    var m = macro { $p1; $p2; };
    trace(Print.expr(m));
    return Implicits.apply(m, params);
  }
}


#if !macro

typedef ArrayBox = hots.box.ArrayBox;
/*
typedef Monads = hots.extensions.Monads;
typedef Shows = hots.extensions.Shows;
typedef Monoids = hots.extensions.Monoids;
*/
import hots.instances.ArrayMonoid;
import hots.box.OptionBox;
import hots.instances.OptionOf;
import hots.instances.OptionTOf;
import hots.classes.Monad;
import hots.classes.Monoid;
import hots.classes.Monoid;
import hots.classes.Semigroup;
import hots.classes.Semigroup;
import hots.classes.Semigroup;
import hots.instances.ArrayOf;
import hots.instances.ArrayTOf;
import hots.instances.ArrayOfMonad;
import hots.instances.StringSemigroup;
import hots.instances.IntSumMonoid;
import hots.instances.StringMonoid;
import hots.instances.ValidationSemigroup;
import hots.instances.ValidationSemigroup;
import hots.instances.OptionMonoid;
import scuts.core.types.Option;
import scuts.core.types.Tup2;
import scuts.core.types.Validation;
import hots.box.ArrayBox;
import hots.instances.OptionOfMonad;
import hots.instances.OptionTOfMonad;
// implicits


typedef IConv<A,B> = ImplicitConversion<A,B>;
typedef IObj<A> = ImplicitObject<A>;


// Transformers

class OptionToOptionTOfConv 
{
  public static inline function implicit <M, T>(_:IConv<Of<M, Option<T>>, OptionTOf<M,T>>, a:Of<M, Option<T>>):OptionTOf<M,T> 
  {
    return OptionBox.boxT(a);
  }
}

class FArrayOptionToOptionTOfConv 
{
  public static function implicit <X, T>(_:IConv<X->Array<Option<T>>, X->OptionTOf<Array<In>,T>>, a:X->Array<Option<T>>):X->OptionTOf<Array<In>,T> 
  {
    return OptionBox.boxFT(ArrayBox.boxF(a));
  }
}

class FOptionToOptionTOfConv 
{
  public static inline function implicit <M, T,X>(_:IConv<X->Of<M, Option<T>>, X->OptionTOf<M,T>>, a:X->Of<M, Option<T>>):X->OptionTOf<M,T> 
  {
    return OptionBox.boxFT(a);
  }
}


class ArrayToArrayTOfConv 
{
  public static inline function implicit <M,T>(_:IConv<Of<M, Array<T>>, ArrayTOf<M,T>>, a:Of<M, Array<T>>):ArrayTOf<M,T> 
  {
    return ArrayBox.boxT(a);
  }
}

class ArrayTOfToArrayConv 
{
  public static inline function implicit <M,T>(_:IConv<ArrayTOf<M,T>, Of<M, Array<T>>>, a:ArrayTOf<M,T>) 
  {
    return ArrayBox.unboxT(a);
  }
}

class OptionTOfMonadObj
{
  public static inline function implicitObj <M>(_:IObj<Monad<Of<M,Option<In>>>>):Monad<M>->Monad<Of<M,Option<In>>> 
  {
    return OptionTOfMonad.get;
  }
}


class FunctionArrowObj 
{
  public static inline function implicitObj (_:IObj<Arrow<In->In>>):Arrow<In->In> 
  {
    return FunctionArrow.get();
  }
}

class FunctionArrowConv 
{
  public static inline function implicit <A,B>(_:IConv<A->B, OfOf<In->In, A, B>>, f:A->B):OfOf<In->In, A, B>
  {
    return hots.box.FunctionBox.asArrow(f);
  }
}

class ArrayMonadObj 
{
  public static var monad(default, null) = ArrayOfMonad.get();
  public static inline function implicitObj <T>(_:IObj<Monad<Array<T>>>):Monad<Array<In>>
  {
    return monad;
  }
}

class ArrayMonadZeroObj 
{
  public static var m(default, null) = ArrayOfMonadZero.get();
  public static inline function implicitObj (_:IObj<MonadZero<Array<In>>>):MonadZero<Array<In>> 
  {
    return ArrayOfMonadZero.get();
  }
}

class ArrayToArrayOfConv 
{
  public static inline function implicit <T>(_:IConv<Array<T>, ArrayOf<T>>, a:Array<T>) 
  {
    return ArrayBox.box(a);
  }
}

class FArrayToArrayOfConv 
{
  public static inline function implicit <T,X>(_:IConv<X->Array<T>, X->ArrayOf<T>>, a:X->Array<T>) 
  {
    return ArrayBox.boxF(a);
  }
}



class FOptionToOptionOfConv 
{
  public static inline function implicit <T,X>(_:IConv<X->Option<T>, X->OptionOf<T>>, a:X->Option<T>) 
  {
    return OptionBox.boxF(a);
  }
}

class OptionToOptionOfConv 
{
  public static inline function implicit <T>(_:IConv<Option<T>, OptionOf<T>>, a:Option<T>):OptionOf<T> 
  {
    return OptionBox.box(a);
  }
}


class OptionOfToOptionConv 
{
  public static inline function implicit <T>(_:IConv<OptionOf<T>, Option<T>>, a:OptionOf<T>)
  {
    return OptionBox.unbox(a);
  }
  public static inline function implicitRet <T>(a:OptionOf<T>)
  {
    return OptionBox.unbox(a);
  }
}

class ArrayOfToArrayConv 
{
  public static inline function implicit <T>(_:IConv<ArrayOf<T>, Array<T>>, a:ArrayOf<T>) 
  {
    return ArrayBox.unbox(a);
  }
  
  public static inline function implicitRet <T>(a:ArrayOf<T>) 
  {
    return ArrayBox.unbox(a);
  }
}

class FArrayOfToArrayConv 
{
  public static inline function implicit <X,T>(_:IConv<X->ArrayOf<T>, X->Array<T>>, a:X->ArrayOf<T>) 
  {
    return ArrayBox.unboxF(a);
  }
  
  public static inline function implicitRet <X,T>(a:X->ArrayOf<T>) 
  {
    return ArrayBox.unboxF(a);
  }
}




class OptionSemigroupImp
{
  public static inline function implicitObj <T>(_:IObj<Semigroup<Option<T>>>, s:Implicit<Semigroup<T>>) 
  {
    return new OptionSemigroup(s);
  }
}

class OptionOfMonadObj
{
  public static inline function implicitObj <T>(_:IObj<Monad<Option<In>>>):Monad<Option<In>> 
  {
    return OptionOfMonad.get();
  }
}



class StringSemigroupObj
{
  public static inline function implicitObj <T>(_:IObj<Semigroup<String>>) 
  {
    return StringSemigroup.get();
  }
}

class IntSumMonoidObj
{
  public static inline function implicitObj (_:IObj<Monoid<Int>>):Monoid<Int> 
  {
    return IntSumMonoid.get();
  }
}
/*
class IntSumSemigroupObj
{
  public static inline function implicitObj (_:IObj<Semigroup<Int>>):Monoid<Int> 
  {
    return IntSumMonoid.get();
  }
}
*/
class ArrayMonoidObj 
{
  public static function implicitObj <T>(_:IObj<Monoid<Array<T>>>):Monoid<Array<T>> 
  {
    return ArrayMonoid.get();
  }
}

class StringMonoidObj 
{
  public static inline function implicitObj <T>(_:IObj<Monoid<String>>) 
  {
    return StringMonoid.get();
  }
}

class ValidationSemigroupObj 
{
  public static inline function implicitObj <F,S>(_:IObj<Semigroup<Validation<F,S>>>):Implicit<Semigroup<F>>->Implicit<Semigroup<S>>->Semigroup<Validation<F,S>>
  {
    return ValidationSemigroup.get;
  }
}
class FloatShowObj 
{
  public static inline function implicitObj <F,S>(_:IObj<Show<Float>>):Show<Float>
  {
    return FloatShow.get();
  }
}

class IntShowObj 
{
  public static inline function implicitObj <F,S>(_:IObj<Show<Int>>):Show<Int>
  {
    return IntShow.get();
  }
}



class StringShowObj 
{
  public static inline function implicitObj <F,S>(_:IObj<Show<String>>):Show<String>
  {
    return StringShow.get();
  }
}

#end