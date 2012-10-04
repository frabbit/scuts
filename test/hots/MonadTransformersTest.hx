package hots;

import hots.classes.Monad;
import hots.of.ArrayOf;
import hots.of.OptionOf;
import scuts.core.types.Option;
import hots.Of;
using hots.Identity;
using hots.Hots;
using hots.ImplicitCasts;
using hots.ImplicitInstances;
private typedef A = utest.Assert;

import scuts.core.types.Validation;

class MonadTransformersTest 
{

  public function new() { }

  
  public function testArrayTransformerMonad () 
  {
    var actual = Some([1,2,3]).intoT().map(function (x) return x + 1);
    A.same(Some([2,3,4]), actual);
  }
  
  public function testUsingBehaviour () 
  {
    var actual = Some([1,2,3]).map(function (x) return [1]);
    A.same(Some([1]), actual);
  }
  
  public function testUsingBehaviour2 () 
  {
    var x: OptionOf<Array<Int>>= Some([1,2,3]);
    
    var actual = x.map(function (x) return [1]);
    A.same(Some([1]), actual);
  }
  
  
  public function testValidationTransformerMonad () 
  {
    var v = Some(Success(1));
    var actual = v.intoT().map(function (x) return x + 1);
    A.same(Some(Success(2)), actual);
  }
  
  public function testFlatMapOnValidationTransformerMonad () 
  {
    var v = Some(Success(1));
    var actual = v.intoT().flatMap((function (x) return Some(Success(x + 1))).intoT());
    A.same(Some(Success(2)), actual);
  }
  
  public function testChainedArrayTransformerMonad () 
  {
    var actual = Some([1,2,3]).intoT().map(function (x) return x + 1).map(function (x) return x + 1);
    A.same(Some([3,4,5]), actual);
  }
  
  public function testChainedFlatMapOptionTransformerMonad () 
  {
    var actual = [Some(1)].intoT()
    .flatMap((function (x) return [Some(x + 1)]).intoT())
    .flatMap((function (x) return [Some(x + 1)]).intoT());
    
    A.same([Some(3)], actual);
    
  }
  
  
  public function testChainedFlatMapArrayTransformerMonad () 
  {
    var actual = Some([1,2,3]).intoT()
    .flatMap((function (x) return Some([x + 1])).intoT())
    .flatMap((function (x) return Some([x + 1])).intoT());
    
    A.same(Some([3,4,5]), actual);
    
  }
  
  public function testLiftingNested () 
  {

    inline function runFT<X,T>(x:X->Option<Array<Option<T>>>) return x.intoT().intoT();
    
    var actual = Some([Some(1)]).intoT().intoT()
    .flatMap(runFT(function (x) return Some([Some(x + 1)])))
    .flatMap(runFT(function (x) return Some([Some(x + 1)])));
    
    A.same(Some([Some(3)]), actual);
    
  }
  
  public function testLiftingNested2 () 
  {
    inline function runFT<X,T>(x:X->Option<Option<Array<Option<T>>>>) return x.intoT().intoT().intoT();
    
    var actual = Some(Some([Some(1)])).intoT().intoT().intoT()
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