package hots;
import hots.box.ArrayBox;
import hots.classes.Monad;
import hots.extensions.Monads;
import scuts.core.types.Option;
import hots.Of;
using hots.Identity;
using hots.Hots;
using hots.ImplicitCasts;
using hots.Objects;
using hots.box.ArrayBox;
using hots.box.OptionBox;
private typedef A = utest.Assert;

import scuts.core.types.Validation;

class MonadTransformersTest 
{

  public function new() { }

  public function testArrayTransformerMonad () 
  {
    var actual = Some([1,2,3]).arrayT().map(function (x) return x + 1);
    A.same(Some([2,3,4]), actual);
  }
  
  
  public function testValidationTransformerMonad () 
  {
    var v = Some(Success(1));
    var actual = v.validationT().map(function (x) return x + 1);
    A.same(Some(Success(2)), actual);
  }
  
  public function testFlatMapOnValidationTransformerMonad () 
  {
    var v = Some(Success(1));
    var actual = v.validationT().flatMap((function (x) return Some(Success(x + 1))).validationFT());
    A.same(Some(Success(2)), actual);
  }
  
  
  
  public function testChainedArrayTransformerMonad () 
  {
    var actual = Some([1,2,3]).arrayT().map(function (x) return x + 1).map(function (x) return x + 1);
    
    A.same(Some([3,4,5]), actual);
    
  }
  
  
  public function testChainedFlatMapOptionTransformerMonad () 
  {
    var actual = [Some(1)].optionT()
    .flatMap((function (x) return [Some(x + 1)]).optionFT())
    .flatMap((function (x) return [Some(x + 1)]).optionFT());
    
    A.same([Some(3)], actual);
    
  }
  
  
  public function testChainedFlatMapArrayTransformerMonad () 
  {
    var actual = Some([1,2,3]).arrayT()
    .flatMap((function (x) return Some([x + 1])).arrayFT())
    .flatMap((function (x) return Some([x + 1])).arrayFT());
    
    A.same(Some([3,4,5]), actual);
    
  }
  
  
  
  
  public function testLiftingNested () 
  {

    inline function runFT<X,T>(x:X->Option<Array<Option<T>>>) return x.arrayFT().optionFT();
    
    var actual = Some([Some(1)]).arrayT().optionT()
    .flatMap(runFT(function (x) return Some([Some(x + 1)])))
    .flatMap(runFT(function (x) return Some([Some(x + 1)])));
    
    A.same(Some([Some(3)]), actual);
    
  }
  
  public function testLiftingNested2 () 
  {

    inline function runFT<X,T>(x:X->Option<Option<Array<Option<T>>>>) return x.optionFT().arrayFT().optionFT();
    
    var actual = Some(Some([Some(1)])).optionT().arrayT().optionT()
    .flatMap(runFT(function (x) return Some(Some([Some(x + 1)]))))
    .flatMap(runFT(function (x) return Some(Some([Some(x + 1)]))));
    
    A.same(Some(Some([Some(3)])), actual);
    
  }

  public function testChainedFlatMapOptionMonad () 
  {
    
    var actual = Some(1).flatMap(function (x) return Some(x + 1)).flatMap(function (x) return Some(x + 1));
    
    A.same(Some(3), actual);
    
    
  }

  
  
}