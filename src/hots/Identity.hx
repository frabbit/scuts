package hots;

#if macro
import haxe.macro.Expr;

private typedef IR = hots.macros.implicits.Resolver;
#end

private typedef D = Dynamic;

class Identity 
{
  /*
   * provides a pure to every instance, the context must be explicitly passed as a String.
   * 
   * Example (with using):
   * 
   * 5.pure("Array<In>")
   * 5.pure("Option<In>")
   */
  @:macro public static function pure (x:ExprOf<D>, e:String):Expr 
  {
    var pointed = IR.resolveImplicitObjByType("hots.classes.Pure<" + e + ">");
    
    return IR.resolve(macro hots.extensions.Pointeds.pure, [x,pointed]);
  }
  
  /*
   * 
   */
  @:macro public static function flatMap (e:ExprOf<D>, f:Expr):Expr 
  {
    return IR.resolve(macro hots.extensions.Monads.flatMap, [e,f]);
  }
  
  // Functor
  @:macro public static function map (e:ExprOf<D>, f:Expr):Expr 
  {
    return IR.resolve(macro hots.extensions.Functors.map, [e,f]);
  }
  
  // Foldable
  @:macro public static function foldLeft (e:ExprOf<D>, init:Expr, f:Expr):Expr 
  {
    return IR.resolve(macro hots.extensions.Foldables.foldLeft, [e,init,f]);
  }
  
  @:macro public static function foldRight (e:ExprOf<D>, init:Expr, f:Expr):Expr 
  {
    return IR.resolve(macro hots.extensions.Foldables.foldRight, [e,init,f]);
  }
  
  
  // Eq
  @:macro public static function eq (e1:ExprOf<D>, e2:Expr):Expr 
  {
    return IR.resolve(macro hots.extensions.Eqs.eq, [e1,e2]);
  }

  // Show
  @:macro public static function show (e1:ExprOf<D>):Expr 
  {
    return IR.resolve(macro hots.extensions.Shows.show, [e1]);
  }
  
  // Semigroup
  @:macro public static function append (e1:ExprOf<D>, e2:Expr):Expr 
  {
    return IR.resolve(macro hots.extensions.Monoids.append, [e1,e2]);
  }
  
  // Arrow
  @:macro public static function next (e1:ExprOf<D>, e2:Expr):Expr
  {
    return IR.resolve(macro hots.extensions.Arrows.next, [e1,e2]);
  }

  
  
  
  /**
   * intoT tries to upcast the passed value e into monad transformer, an implicitUpcastT 
   * must be available in the using Context for this type.
   * 
   * Example:
   *  [[1]].intoT() // ArrayOfT<Array<In>, Int>
   *  [Some(1)].intoT() // ArrayOfT<Option<In>, Int>
   */
  @:macro public static function intoT (e:ExprOf<D>):Expr
  {
    var e1 = IR.applyImplicitUpcast(e, false);
    var r = IR.applyImplicitUpcastT(e1, true, false);
    return r;
  }
  
  /**
   * runT is the opposite of intoT, it tries to downcast the passed transformer value e into 
   * its normal representation, an implicitDowncastT must be available in the using Context 
   * for this type.
   * 
   * Example:
   *  [[1]].intoT().runT()     // Array<Array<Int>>
   *  [Some(1)].intoT().runT() // Array<Option<Int>>
   */
  @:macro public static function runT (e:ExprOf<D>):Expr
  {
    var e1 = IR.applyImplicitDowncastT(e, true, false);
    
    return try IR.applyImplicitDowncast(e1, true, false) catch (e:Error) e1;
  }
  
  
}