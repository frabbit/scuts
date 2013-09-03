package scuts.ht;

#if !macro



import scuts.ht.classes.Monad;
import scuts.ht.instances.std.ArrayOf;
import scuts.ht.instances.std.OptionOf;
import scuts.core.Options;

import scuts.core.Validations;
import scuts.core.Promises;
using scuts.ht.Context;

private typedef A = utest.Assert;

class MonadTransformersTest 
{

  public function new() {}

  #if !excludeHtTests
  public function testOptionArrayTransformer () 
  {
    var a = Some([1,2,3]).arrayT();
    var actual = a.map_(function (x) return x + 1);
    A.same(Some([2,3,4]), actual);
  }

  public function testArrayOptionTransformer () 
  {
    var a = [Some(1)].optionT();
    var actual = a.map_(function (x) return x + 1);
    A.same([Some(2)], actual);
  }

  public function testArrayPromiseTransformer () 
  {
    var a = [Promises.pure(1)].promiseT();
    var actual = a.map_(function (x) return x + 1);
    A.same([Promises.pure(2)], actual);
  }

  public function testPromiseArrayTransformer () 
  {
    var a = Promises.pure([1]).arrayT();
    var actual = a.map_(function (x) return x + 1);
    A.same(Promises.pure([2]), actual);
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
  
  
  public function testValidationTransformer () 
  {
    var v = Some(Success(1)).validationT();

    var actual = v.map_(function (x) return x + 1);
    A.same(Some(Success(2)), actual);
  }

  
  public function testValidationTransformer2 () 
  {
    // this is failing currently
    var actual = Some(Success(1)).validationT().map_(function (x) return x + 1); // optionFunctor is used here, typing/inline problem
    A.same(Some(Success(2)), actual);
  }

  public function testFlatMapOnValidationTransformer () 
  {

    var v = Some(Success(1));
    var actual = v.validationT()
      .flatMap_(
        function (x) return Some(Success(x + 1)).validationT());

    A.same(Some(Success(2)), actual);
  }
  
  
  public function testChainedArrayTransformer () 
  {
    var actual = Some([1,2,3]).arrayT().map_(function (x) return x + 1).map_(function (x) return x + 1);
    A.same(Some([3,4,5]), actual);
  }
  
  
  public function testChainedFlatMapOptionTransformer () 
  {
    var actual = [Some(1)].optionT()
    .flatMap_(function (x) return [Some(x + 1)].optionT())
    .flatMap_(function (x) return [Some(x + 1)].optionT());
    
    A.same([Some(3)], actual);
    
  }
  
  
  public function testChainedFlatMapArrayTransformer () 
  {
    var actual = Some([1,2,3]).arrayT()
    .flatMap_(function (x) return Some([x + 1]).arrayT())
    .flatMap_(function (x) return Some([x + 1]).arrayT());
    
    A.same(Some([3,4,5]), actual);
    
  }


  public function testLiftingNestedComplex () 
  {
    var actual = Some([Some(Promises.pure(1))]).arrayT().optionT().promiseT()
    .flatMap_(function (x) return Some([Some(Promises.pure(x + 1))]).arrayT().optionT().promiseT())
    .flatMap_(function (x) return Some([Some(Promises.pure(x + 2))]).arrayT().optionT().promiseT())
    .flatMap_(function (x) return Some([Some(Promises.pure(x + 3))]).arrayT().optionT().promiseT());
    
    A.same(Some([Some(Promises.pure(7))]), actual);
    
  }

  public function testLiftingNestedVeryComplex () 
  {
    var actual = Some([Some(Promises.pure(Success(1)))]).arrayT().optionT().promiseT().validationT()
    .flatMap_(function (x) return Some([Some(Promises.pure(Success(x + 1)))]).arrayT().optionT().promiseT().validationT());
    
    A.same(Some([Some(Promises.pure(Success(2)))]), actual);
    
  }
  
  public function testNestedComplexWithRunT () 
  {
    var actual = Some([Some(Promises.pure(Success(1)))]).arrayT().runT().arrayT().optionT().runT().optionT().runT().optionT().promiseT().runT().promiseT().validationT()
    .flatMap_(function (x) return Some([Some(Promises.pure(Success(x + 1)))]).arrayT().optionT().promiseT().validationT());
    
    A.same(Some([Some(Promises.pure(Success(2)))]), actual);
    
  }

  public function testLiftingNested () 
  {
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
  
  #end
}



#end