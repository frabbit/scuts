package scuts.ht;




import scuts.ht.classes.Monad;
import scuts.ht.instances.std.ArrayOf;
import scuts.ht.instances.std.OptionOf;
import scuts.core.Options;

import scuts.core.Validations;

using scuts.ht.Context;

private typedef A = utest.Assert;

class MonadTransformersTest 
{

  public function new() {}

  
  public function testArrayTransformerMonad () 
  {
    var actual = Some([1,2,3]).arrayT().map_(function (x) return x + 1);
    A.same(Some([2,3,4]), actual);
  }
  
  
  public function testUsingBehaviour () 
  {
    var actual = Some([1,2,3]).map_(function (x) return [1]);
    A.same(Some([1]), actual);
  }
  
  
  public function testUsingBehaviour2 () 
  {
    
    
    var actual = Some([1,2,3]).map_(function (x) return [1]);
    A.same(Some([1]), actual);
  }
  
  
  public function testValidationTransformerMonad () 
  {
    var v = Some(Success(1)).validationT();

    var actual = v.map_(function (x) return x + 1);
    A.same(Some(Success(2)), actual);
  }

  // Failing Test
  #if failing_tests
  public function testValidationTransformerMonadFailing () 
  {
    
    var v = Some(Success(1));
    // this is failing currently
    var actual = v.validationT().map_(function (x) return x + 1); // optionFunctor is used here, typing/inline problem
    A.same(Some(Success(2)), actual);
    
  }
  #end
  
  
  public function testFlatMapOnValidationTransformerMonad () 
  {
    var v = Some(Success(1));
    var actual = v.validationT().flatMap_(function (x) return Some(Success(x + 1)).validationT());
    A.same(Some(Success(2)), actual);
  }
  
  
  public function testChainedArrayTransformerMonad () 
  {
    var actual = Some([1,2,3]).arrayT().map_(function (x) return x + 1).map_(function (x) return x + 1);
    A.same(Some([3,4,5]), actual);
  }
  
  
  public function testChainedFlatMapOptionTransformerMonad () 
  {
    var actual = [Some(1)].optionT()
    .flatMap_(function (x) return [Some(x + 1)].optionT())
    .flatMap_(function (x) return [Some(x + 1)].optionT());
    
    A.same([Some(3)], actual);
    
  }
  
  
  public function testChainedFlatMapArrayTransformerMonad () 
  {
    var actual = Some([1,2,3]).arrayT()
    .flatMap_(function (x) return Some([x + 1]).arrayT())
    .flatMap_(function (x) return Some([x + 1]).arrayT());
    
    A.same(Some([3,4,5]), actual);
    
  }

  
  public function testLiftingNested () 
  {

    //inline function runFT<X,T>(x:X->Option<Array<Option<T>>>) return x.arrayT().optionT();
    
    var actual = Some([Some(1)]).arrayT().optionT()
    .flatMap_(function (x) return Some([Some(x + 1)]).arrayT().optionT())
    .flatMap_(function (x) return Some([Some(x + 1)]).arrayT().optionT());
    
    A.same(Some([Some(3)]), actual);
    
  }
  
  
  public function testLiftingNested2 () 
  {
    inline function runT<X,T>(x:Option<Option<Array<Option<T>>>>) return x.optionT().arrayT().optionT();
    
    var actual = runT(Some(Some([Some(1)])))
    .flatMap_(function (x) return runT(Some(Some([Some(x + 1)]))))
    .flatMap_(function (x) return runT(Some(Some([Some(x + 1)]))));
    
    A.same(Some(Some([Some(3)])), actual);
  }

  
  public function testChainedFlatMapOptionMonad () 
  {
    var actual = Some(1).flatMap_(function (x) return Some(x + 1)).flatMap_(function (x) return Some(x + 1));
    
    A.same(Some(3), actual);
  }
  
}