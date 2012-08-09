package hots;
#if macro
private typedef IR = hots.macros.ImplicitResolver;
import haxe.macro.Expr;

#end

import scuts.core.types.Option;

private typedef Of_<M,A> = Dynamic;
private typedef OfOf_<M,A,B> = Dynamic;



class Identity 
{
  
  @:macro public static function pure <M,A,B>(e:String):ExprOf<Of_<M,B>> 
  {
    return IR.implicitByType("hots.classes.Pointed<"+e+">");
  }
  
  @:macro public static function flatMap <M,A,B>(e:ExprOf<Of_<M,A>>, f:ExprOf<A->Of_<M,B>>):ExprOf<Of_<M,B>> 
  {
    return IR.apply(macro hots.extensions.Monads.flatMap, [e,f]);
  }
  
  @:macro public static function filter <M,A>(e:ExprOf<Of_<M,A>>, f:ExprOf<A->Bool>):ExprOf<Of_<M,A>> 
  {
    return IR.apply(macro hots.extensions.MonadZeros.filter, [e,f]);
  }
  
  @:macro public static function map <M,A,B>(e:ExprOf<Of_<M,A>>, f:ExprOf<A->B>):ExprOf<Of_<M,B>> 
  {
    return IR.apply(macro hots.extensions.Monads.map, [e,f]);
  }
  
  
  @:macro public static function eq <T>(e1:ExprOf<T>, e2:ExprOf<T>):ExprOf<Bool> 
  {
    return IR.apply(macro hots.extensions.Eqs.eq, [e1,e2]);
  }

  @:macro public static function show <T>(e1:ExprOf<T>):ExprOf<String> 
  {
    return IR.apply(macro hots.extensions.Shows.show, [e1]);
  }
  
  @:macro public static function append <T>(e1:ExprOf<T>, e2:ExprOf<T>):ExprOf<T> 
  {
    return IR.apply(macro hots.extensions.Monoids.append, [e1,e2]);
  }
  
  @:macro public static function next <M,A,B,C>(e1:ExprOf<OfOf<M,A,B>>, e2:ExprOf<OfOf<M,B,C>>):ExprOf<OfOf<M,A,C>>
  {
    return IR.apply(macro hots.extensions.Arrows.next, [e1,e2]);
  }
  
  @:macro public static function optionT (e1:ExprOf<Dynamic>):ExprOf<Dynamic>
  {
    return IR.apply(macro hots.box.OptionBox.optionT, [e1]);
  }
  
  @:macro public static function optionFT (e1:ExprOf<Dynamic>):ExprOf<Dynamic>
  {
    return IR.apply(macro hots.box.OptionBox.boxFT, [e1]);
  }
  
  
  @:macro public static function arrayT (e1:ExprOf<Dynamic>):ExprOf<Dynamic>
  {
    return IR.apply(macro hots.box.ArrayBox.arrayT, [e1]);
  }
  
  @:macro public static function arrayFT (e1:ExprOf<Dynamic>):ExprOf<Dynamic>
  {
    return IR.apply(macro hots.box.ArrayBox.boxFT, [e1]);
  }
  
  
  
  
  
}