package hots.macros;
#if (macro || display)
import haxe.macro.Context;
import haxe.macro.Expr;
import hots.macros.utils.Utils;
import scuts.mcore.Cast;
import scuts.mcore.Make;
import scuts.mcore.Print;
import scuts.Scuts;

using scuts.core.extensions.OptionExt;
using scuts.mcore.extensions.TypeExt;
using scuts.mcore.extensions.ExprExt;
using scuts.core.extensions.EitherExt;
import scuts.core.types.Either;
using scuts.core.extensions.DynamicExt;
private typedef U = hots.macros.utils.Utils;
#end
/**
 * ...
 * @author 
 */

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
  @:macro public static function box(e:Expr) 
  {
    return mkBox(e);
  }
  #if (macro || display)
  public static function mkBox(e:Expr) 
  {
    
    var type = Context.typeof(e);
    var error1 = function () return 
      Scuts.macroError("Cannot box expression " + Print.expr(e)
        + " because it's inner type '" + Print.type(type) + "' is not a container type like 'Container<X>'");
        
    var error2 = function (inner) return 
      Scuts.macroError("Cannot box expression " + Print.expr(e) + " because it's inner type '" + Print.type(inner) + "' is not a container type like 'Container<X>'");
        
    var newType = if (Utils.isOfType(type)) 
    {
      
      var innerType = U.getOfElemType(type).extract();
      
      if (U.isContainerType(innerType)) 
      {
        var innerTypeAsOf = U.convertToOfType(innerType);
        
        trace(innerTypeAsOf);
        
        var flattened = U.replaceOfElemType(type, innerTypeAsOf).map( function (x) return U.flattenOfType(x));
        
        
        flattened.extract();
      } 
      else 
        error2(innerType);
    } 
    else if (U.isContainerType(type)) 
    {
      U.convertToOfType(type);
    } 
    else 
    {
      error1();
    }
    
    return e.unsafeCastTo(newType.toComplexType());
  }
  #end
  
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
  @:macro public static function unbox(e:Expr) {
    return mkUnbox(e);
  }
  
  #if (macro || display)
  public static function mkUnbox(e:Expr) 
  {
    
    
    
    var error = function () return "Cannot unbox expression " + Print.expr(e) + " because it's no Of type";
    var type = Context.typeof(e);
    
    /**
     * Do({
     * var t <- U.getOfParts(type).toLeft(error)
     * var container = t._1;
     * var elemType = t._2;
     * if (U.isOfType(container))
     *    Do({
     *      innerElemType <- U.getOfElemType(container).toLeft(error)
            if (U.hasInnerInType(innerElemType)) {
              Do({
                elemType <- U.getOfElemType(type);
                mapped <- U.replaceContainerElemType(innerElemType, elemType)
                last <- U.replaceOfElemType(container, mapped)
                last.toLeft(error);
              })
            else Right(error());
          });
     * else if (U.hasInnerInType(container))
            U.replaceContainerElemType(container, elemType)).toLeft(error);
       else Right(error());
     * })
     */
    
    var newType = U.getOfParts(type) // 1
    .toLeft(error) 
    .flatMapLeft(function (t) {
      // 2
      var container = t._1;
      var elemType = t._2;
      return if (U.isOfType(container)) 
      {
        //5
        U.getOfElemType(container).toLeft(error)
        .flatMapLeft(function (innerElemType) 
          return if (U.hasInnerInType(innerElemType)) 
          {
            // 6
            U.getOfElemType(type)
              .flatMap(function (x) return U.replaceContainerElemType(innerElemType, x)) // we have D<E>
              .flatMap(function (x) return U.replaceOfElemType(container, x))
              .toLeft(error);
          } 
          else error().toEitherRight()
        );
      } 
      else 
      {
        // 3
        if (U.hasInnerInType(container)) 
        {
          // 4
          U.replaceContainerElemType(container, elemType).toLeft(error);
        }
        else error().toEitherRight();
      }
    });
      
    
    var t = newType.getOrElse(function (b) return Scuts.macroError(b));
    return e.unsafeCastTo(t.toComplexType());
  }
  #end
  
}