package hots.instances;
import hots.Objects;
import scuts.Assert;
import utest.Assert;

using hots.Identity;
using hots.ImplicitCasts;
using hots.Objects;

class ArrayOfMonadTest 
{

  public function new() 
  {
    
  }
  
  /*
   (return x) >>= f == f x
    m >>= return == m
   (m >>= f) >>= g == m >>= (\x -> f x >>= g) 
  */
   
   //TODO this currently fails because m.pure(3) gets inlined and accesses a private field (m.applicative.pure), 
   //see MonadAbstract and this causes the known inlining problem
   public function testLaws () {
     
     
     /*
      var m = Objects.arrayMonad;
      
      var val = 3;
      var f = function (x) return [x + 1];
     
      Assert.equals(f(val),  m.pure(3).flatMap(f));
      */
      Assert.fail();
   }
   
}