package hots.macros;
#if (macro || display)
import haxe.Log;
import haxe.macro.Type;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.PosInfos;
import hots.macros.utils.Utils;
import hots.Of;
import scuts.mcore.cache.ExprCache;
import scuts.mcore.Cast;
import scuts.mcore.MContext;
import scuts.mcore.extensions.TypeExt;
import scuts.mcore.Make;
import scuts.mcore.Parse;
import scuts.mcore.Print;
import scuts.Scuts;

using scuts.core.extensions.Options;
using scuts.mcore.extensions.TypeExt;
using scuts.mcore.extensions.ExprExt;
using scuts.core.extensions.Eithers;
import scuts.core.types.Either;
using scuts.core.extensions.Dynamics;
using scuts.core.extensions.Arrays;
using scuts.core.extensions.Iterators;
using scuts.core.Log;
using scuts.mcore.Check;
private typedef U = hots.macros.utils.Utils;
enum BoxError {
  TypeIsNoContainer(t:Type);
  InnerTypeIsNoContainer(t:Type, inner:Type);
}

enum UnboxError {
  TypeIsNoOfType(t:Type);
  InvalidOfType(t:Type);
  ConversionError(t:Type);
}
#end



class Box 
{
  
  #if (macro || display)
  static var cache = new ExprCache(true).enableCache(false) #if !display .printOnGenerate("Box Times") #end;
  #end
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
  @:macro public static function box(e:Expr, ?times:Int = 1) 
  {
    return (0...times).foldLeft(function (acc, _) return box1(acc), e);
  }
  
  
  @:macro public static function boxF<A,B>(e:ExprRequire<A->B>, ?times:Int = 1) 
    return (0...times).foldLeft(function (acc, _) return boxF1(acc), e)
  
  @:macro public static function unboxF<A,B,C>(e:Expr /*ExprRequire<A->Of<B,C>>*/, ?times:Int = 1) 
    return (0...times).foldLeft(function (acc, _) return unboxF1(acc), e)
  
  @:macro public static function unbox<A,B>(e:Expr /*ExprOf<Of<A,B>>*/, ?times:Int = 1) {
    return (0...times).foldLeft(function (acc, _) return unbox1(acc), e);
  }
  
  
  #if (macro || display)
  
  public static function unbox1(e:Expr):Expr 
  {
    function f() 
    {
      var o = MContext.typeof(e);
      //trace(o);
      var type = MContext.followAliases(o.extract());
      //trace(type);
      return unboxOfTypeToType(type)
        .mapRight(function (x) return unsafeCast(e, type, x))
        .getOrElse(function (err) return handleUnboxError(err, e));
    }
    return cache.call(f, function () return [Print.expr(e), e.pos]);
  }
  
  public static function box1(e:Expr):Expr 
  {
    function f() 
    {
      var type = MContext.followAliases(Context.typeof(e));
      var newType = boxTypeToOfType(type);
    
      return newType
        .mapRight(function (x) return unsafeCast(e, type,x))
        .getOrElse(function (err) return handleBoxError(err, e));
    }
    return cache.call(f, function () return [Print.expr(e), e.pos]);
  }
  
  public static function unboxF1 (e:Expr):Expr 
  {
    function f() 
    {
      var errorNoFunction = function () return Scuts.macroError("Argument " + Print.expr(e) + " must be a function with 1-arity");
      
      var type = MContext.typeof(e).getOrElse(function () return Scuts.macroError("Cannot determine the type of expression " + e,e.pos));
      
      var fnParts = type.asFunction().getOrElse(errorNoFunction);

      var retBoxed = unboxOfTypeToType(fnParts._2);
       
      return switch (retBoxed) 
      {
        case Left(error): handleUnboxError(error, e);
        case Right(type): unsafeCast(e, type, TFun(fnParts._1, type));
      };
    }
    return cache.call(f,function () return e);
  }
  
  public static function boxF1 (e:Expr) 
  {
    function f() 
    {
      var errorNoFunction = function () return Scuts.macroError("Argument " + Print.expr(e) + " must be a function with 1-arity");
      
      var type = MContext.typeof(e).getOrElse(function () return Scuts.macroError("Cannot determine the type of expression " + e,e.pos));
      
      var fnParts = type.asFunction().getOrElse(errorNoFunction);

      var retBoxed = boxTypeToOfType(fnParts._2);
       
      return switch (retBoxed) {
        case Left(error): handleBoxError(error, e);
        case Right(type): unsafeCast(e, type, TFun(fnParts._1, type));
      };
    }
    return cache.call(f, function () return e);
  }
  
  static function handleBoxError <T>(error:BoxError, expr:Expr):T
  {
    var msg = switch (error) 
    {
      case InnerTypeIsNoContainer(t, inner): 
        "Cannot box expression " + Print.expr(expr) + " of type " + Print.type(t)
        + " because it's inner type '" + Print.type(inner) + "' is not a container type like 'Container<X>'";
      case TypeIsNoContainer(t): 
        "Cannot box expression " + Print.expr(expr) + " of type " + Print.type(t) 
        + " because it's not a container type like 'Container<X>'";
    }
    return Scuts.macroError(msg, expr.pos);
  }
  
  static function handleUnboxError <T>(error:UnboxError, expr:Expr):T 
  {
    var msg = switch (error) 
    {
      case TypeIsNoOfType(t): "Cannot unbox expression " + Print.expr(expr) + " because it's type " + Print.type(t) + " is no Of type";
      case InvalidOfType(t): "Cannot unbox expression " + Print.expr(expr) + " because it's no Of type";
      case ConversionError(t):
    }
    
    return Scuts.macroError(msg, expr.pos);
  }
  
  public static function boxTypeToOfType (type:Type):Either<BoxError, Type> 
  {
    var type = MContext.followAliases(type);
    
    return (if (Utils.isOfType(type)) 
    {
      var innerType = MContext.followAliases(U.getOfElemType(type).extract());
      
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
    
    var err = function () return TypeIsNoOfType(type);
    return U.getOfParts(MContext.followAliases(type)) // 1
    .toRight(err) 
    .flatMapRight(function (t) // 2
    { 
      var container = MContext.followAliases(t._1);
      var elemType = MContext.followAliases(t._2);
      return if (U.isOfType(container)) //5
      {
        U.getOfElemType(container).map(function (x) return MContext.followAliases(x))
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
            // the current Of container type must have more than one In Type, which means a higher category (Arrow instances f.e.).
            // We need to unbox the container type first and then we can unbox actual type.
            
            unboxOfTypeToType(container)
            .flatMapRight(function (x) {
              var of = U.makeOfType(x, elemType);
              return unboxOfTypeToType(of);
            });
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
  

  static function unsafeCast (e:Expr, fromType:Type, toType:Type) 
  {
    var wildcards = MContext.getLocalTypeParameters(toType);
    
    return Cast.unsafeCastFromTo(e, MContext.followAliases(fromType), toType, wildcards);
  }

  #end
  
}