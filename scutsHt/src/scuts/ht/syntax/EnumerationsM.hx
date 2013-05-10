package scuts.ht.syntax;

import scuts.ds.LazyLists;

#if macro
import haxe.macro.Expr;
private typedef R = scuts.ht.macros.implicits.Resolver;
#end





class EnumerationsM 
{


  macro public static function toEnum_ <T>(i:ExprOf<Int>, enumType:String):ExprOf<T>
  {
    var e = 
      R.resolveImplicitObjByType("scuts.ht.classes.Enumeration<" + enumType + ">");
    
    return R.resolve(macro scuts.ht.syntax.Enumerations.toEnum, [i, e], 2);
  }

  macro public static function pred_ <T>(a:ExprOf<T>):ExprOf<T>
  {
    return R.resolve(macro scuts.ht.syntax.Enumerations.pred, [a], 2);
  }
  
  macro public static function succ_ <T>(a:ExprOf<T>):ExprOf<T>
  {
    return R.resolve(macro scuts.ht.syntax.Enumerations.succ, [a], 2);
  }
  


  macro public static function fromEnum_ <T>(i:ExprOf<T>):ExprOf<Int>
  {
    return R.resolve(macro scuts.ht.syntax.Enumerations.fromEnum, [i], 2);
  }
  
  macro public static function enumFrom_ <T>(a:ExprOf<T>):ExprOf<LazyList<T>>
  {
    return R.resolve(macro scuts.ht.syntax.Enumerations.enumFrom, [a], 2);
  }
  
  macro public static function enumFromTo_ <T>(a:ExprOf<T>, b:ExprOf<T>):ExprOf<LazyList<T>>
  {
    return R.resolve(macro scuts.ht.syntax.Enumerations.enumFromTo, [a,b], 3);
  }
  
  macro public static function enumFromThenTo_ <T>(a:ExprOf<T>, b:ExprOf<T>, c:ExprOf<T>):ExprOf<LazyList<T>>
  {
    return R.resolve(macro scuts.ht.syntax.Enumerations.enumFromThenTo, [a,b,c], 4);
  }

}
