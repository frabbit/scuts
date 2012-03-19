package hots.macros;
#if (macro || display)
import haxe.macro.Type;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.PosInfos;
import hots.macros.utils.Utils;
import scuts.mcore.Cast;
import scuts.mcore.MContext;
import scuts.mcore.extensions.TypeExt;
import scuts.mcore.Make;
import scuts.mcore.Parse;
import scuts.mcore.Print;
import scuts.Scuts;

using scuts.core.extensions.OptionExt;
using scuts.mcore.extensions.TypeExt;
using scuts.mcore.extensions.ExprExt;
using scuts.core.extensions.EitherExt;
import scuts.core.types.Either;
using scuts.core.extensions.DynamicExt;
using scuts.core.extensions.ArrayExt;
using scuts.core.Log;
private typedef U = hots.macros.utils.Utils;

#end
/**
 * ...
 * @author 
 */

enum BoxError {
  TypeIsNoContainer(t:Type);
  InnerTypeIsNoContainer(t:Type, inner:Type);
}

enum UnboxError {
  TypeIsNoOfType(t:Type);
  InvalidOfType(t:Type);
  ConversionError(t:Type);
}
class Box 
{
  /**
    
    1. Check if the type is an Of type, if yes goto 4
    2. Check if type wraps another type, if no goto 9
    3. Convert the type M<A> into Of<M, A> and goto 8
    4. Check if inner type wraps another type, if no goto 9
    5. Convert the inner type M<A> into Of<M, A>
    6. Insert the wrapped inner type Of<M2, A> into the outer type Of<M1, _> => Of<M1, Of<M2, A>> and flatten/combine the resulting type => Of<Of<M1, M2>, A>
    7. Boxing successful
    8. Error boxing not possible
   
   */
  @:macro public static function box(e:Expr) return box1(e)
  
  @:macro public static function boxF(e:Expr) return boxF1(e)
  
  @:macro public static function unboxF(e:Expr) return unboxF1(e)
  
  @:macro public static function unbox(e:Expr) return unbox1(e)
  
  
  #if (macro || display)
  
   public static function unbox1(e:Expr):Expr 
  {
    var type = Context.follow(Context.typeof(e));

    return unboxOfTypeToType(type)
      .mapRight(function (x) return unsafeCast(e, x))
      .getOrElse(function (err) return handleUnboxError(err, e));
  }
  
  public static function box1(e:Expr):Expr 
  {
    var type = Context.typeof(e);
    var newType = boxTypeToOfType(type);
    
    return newType
      .mapRight(function (x) return unsafeCast(e,x))
      .getOrElse(function (err) return handleBoxError(err, e));
  }
  
  public static function unboxF1 (e:Expr):Expr {
    var errorNoFunction = function () return Scuts.macroError("Argument " + Print.expr(e) + " must be a function with 1-arity");
    
    var type = MContext.typeof(e).getOrElse(function () return Scuts.macroError("Cannot determine the type of expression " + e,e.pos));
    
    var fnParts = type.asFunction().getOrElse(errorNoFunction);

    var retBoxed = unboxOfTypeToType(fnParts._2);
     
    return switch (retBoxed) {
      case Left(error): handleUnboxError(error, e);
      case Right(type): unsafeCast(e, TFun(fnParts._1, type));
    };
  }
  
  public static function boxF1 (e:Expr) {
    var errorNoFunction = function () return Scuts.macroError("Argument " + Print.expr(e) + " must be a function with 1-arity");
    
    var type = MContext.typeof(e).getOrElse(function () return Scuts.macroError("Cannot determine the type of expression " + e,e.pos));
    
    var fnParts = type.asFunction().getOrElse(errorNoFunction);

    var retBoxed = boxTypeToOfType(fnParts._2);
     
    return switch (retBoxed) {
      case Left(error): handleBoxError(error, e);
      case Right(type): unsafeCast(e, TFun(fnParts._1, type));
    };
  }
  
  static function handleBoxError <T>(error:BoxError, expr:Expr):T
  {
    return Scuts.macroError(switch (error) {
      case InnerTypeIsNoContainer(t, inner): 
        "Cannot box expression " + Print.expr(expr) + " of type " + Print.type(t)
        + " because it's inner type '" + Print.type(inner) + "' is not a container type like 'Container<X>'";
      case TypeIsNoContainer(t): 
        "Cannot box expression " + Print.expr(expr) + " of type " + Print.type(t) 
        + " because it's not a container type like 'Container<X>'";
    }, expr.pos);
  }
  
  static function handleUnboxError <T>(error:UnboxError, expr:Expr):T 
  {
    return Scuts.macroError(switch (error) {
      case TypeIsNoOfType(t): "Cannot unbox expression " + Print.expr(expr) + " because it's no Of type";
      case InvalidOfType(t): "Cannot unbox expression " + Print.expr(expr) + " because it's no Of type";
      case ConversionError(t):
    }, expr.pos);
  }
  
  public static function boxTypeToOfType (type:Type):Either<BoxError, Type> 
  {
    
    return (if (Utils.isOfType(type)) 
    {
      var innerType = U.getOfElemType(type).extract();
      
      if (U.isContainerType(innerType)) 
      {
        var innerTypeAsOf = U.convertToOfType(innerType);
        
        var flattened = U.replaceOfElemType(type, innerTypeAsOf).map( function (x) return U.flattenOfType(x));
        
        Right(flattened.extract());
      } 
      else 
        Left(InnerTypeIsNoContainer(type, innerType));
    } 
    else if (U.isContainerType(type)) 
    {
      Right(U.convertToOfType(type));
    } 
    else 
    {
      Left(TypeIsNoContainer(type));
    });
  }
  
  
  /**
   * 
    Unboxing
    1: Check if the type is an Of type, if no goto error
    2: Check if Container type is an Of Type, if yes goto 5
    3: Check if Container type has inner In type, if no goto Error
    4: Convert Of<C<In>, E> into C<E> and goto Success
    5: Check if Container Elem type has inner In type, if no goto Error
    6: Convert Of<Of<A, D<In>>, E> into Of<A, D<E>>
    Success: Boxing successful
    Error: Error boxing not possible
   */
  public static function unboxOfTypeToType (type:Type):Either<UnboxError, Type> 
  {
    //trace("type before:" + Print.type(type));
    //var type = U.normalizeOfTypes(type);
    
    //trace("type after:" + Print.type(type));
    
    var err = function () return TypeIsNoOfType(type);
    return U.getOfParts(type) // 1
    .toRight(err) 
    .flatMapRight(function (t) // 2
    { 
      var container = Context.follow(t._1);
      var elemType = Context.follow(t._2);
      return if (U.isOfType(container)) //5
      {
        U.getOfElemType(container)
        .toRight(err)
        .flatMapRight(function (innerElemType) {
          return if (U.hasInnerInType(innerElemType)) // 6
          {
            
            U.getOfElemType(type)
            .flatMap(function (x) return U.replaceFirstInType(innerElemType, x)) // we have D<E>
            .flatMap(function (x) return U.replaceOfElemType(container, x))
            .toRight(err);
          } 
          else {
            // the current Of container type must have more than one In Type, which means a higher category.
            // We need to unbox the container type first and then we can unbox actual type.
            
            unboxOfTypeToType(container)
            .flatMapRight(function (x) {
              var of = U.makeOfType(x, elemType);
              return unboxOfTypeToType(of);
            });
            //Left(err())
          }
        });
      } 
      else // 3
      {
        
        if (U.hasInnerInType(container)) // 4
        {
          U.replaceFirstInType(container, elemType)
          .toRight(function () return Scuts.unexpected());
        }
        else Left(InvalidOfType(type));
      }
    });
  }

  static function unsafeCast (e:Expr, t:Type) 
  {
    var wildcards = Utils.getLocalTypeParameters(t);
    return Make.block([Make.varExpr("x", t.toComplexType(wildcards), Make.castExpr(e)), Make.constIdent("x")]);
  }

  #end
  
}