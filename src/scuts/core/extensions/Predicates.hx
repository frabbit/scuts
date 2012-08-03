package scuts.core.extensions;
import scuts.core.types.Predicate0;
import scuts.core.types.Predicate1;
import scuts.core.types.Predicate2;
import scuts.core.types.Thunk;

class Predicates {
  public static function constTrue0 () return true
  public static function constFalse0 () return false
  
  public static function constTrue1  <A>(t:A) return true
  public static function constFalse1 <A>(t:A) return false
  
  public static function constTrue2  <A,B>(a:A, b:B) return true
  public static function constFalse2 <A,B>(a:A, b:B) return false
}

class Predicates0 
{
  /**
   * Logical and (&&) operator for predicates without arguments.
   */
  public static function and (p1:Predicate0, p2:Predicate0):Predicate0
  {
    return function () return p1() && p2();
  }
  
  /**
   * Logical not (!) for predicates without arguments.
   */
  public static function not (p:Predicate0):Predicate0
  {
    return function () return !p();
  }
  
  /**
   * Logical or (||) operator for predicates without arguments.
   */
  public static function or (p1:Predicate0, p2:Predicate0):Predicate0
  {
    return function () return p1() || p2();
  }
  
  /**
   * If Else Conditional for Predicates without arguments.
   */
  public static function ifElse <A>(p:Predicate0, ifVal:Thunk<A>, elseVal:Thunk<A>):Thunk<A>
  {
    return function () return if (p()) ifVal() else elseVal();
  }
  
}

class Predicates1
{

  /**
   * Logical and (&&) operator for predicates with one argument.
   */
  public static function and < A > (p1:Predicate1<A>, p2:Predicate1<A>):Predicate1<A>
  {
    return function (a) return p1(a) && p2(a);
  }
  
  
  /**
   * Logical not (!) for predicates with one argument.
   */
  public static function not < A > (p:Predicate1<A>):Predicate1<A>
  {
    return function (a) return !p(a);
  }
  
  /**
   * Logical or (||) operator for predicates with one argument.
   */
  public static function or < A > (p1:Predicate1<A>, p2:Predicate1<A>):Predicate1<A>
  {
    return function (a) return p1(a) || p2(a);
  }
  
  /**
   * If Else Conditional for Predicates with one argument.
   */
  public static function ifElse <A,R>(p:Predicate1<A>, ifVal:Thunk<R>, elseVal:Thunk<R>):A->R
  {
    return function (a) return if (p(a)) ifVal() else elseVal();
  }
  
}

class Predicates2 
{
  /**
   * Logical and (&&) operator for predicates with two arguments.
   */
  public static function and <A,B>(p1:Predicate2<A,B>, p2:Predicate2<A,B>):Predicate2<A,B>
  {
    return function (a,b) return p1(a,b) && p2(a,b);
  }
  
  /**
   * Logical not (!) for predicates with two argument.
   */
  public static function not <A,B>(p:Predicate2<A,B>):Predicate2<A,B>
  {
    return function (a,b) return !p(a,b);
  }
  
  /**
   * Logical or (||) operator for predicates with two arguments.
   */
  public static function or  <A,B>(p1:Predicate2<A,B>, p2:Predicate2<A,B>):Predicate2<A,B>
  {
    return function (a,b) return p1(a,b) || p2(a,b);
  }
  
  /**
   * If Else Conditional for Predicates with two arguments.
   */
  public static function ifElse <A,B,R>(p:Predicate2<A,B>, ifVal:Thunk<R>, elseVal:Thunk<R>):A->B->R
  {
    return function (a,b) return if (p(a,b)) ifVal() else elseVal();
  }
 
  
}