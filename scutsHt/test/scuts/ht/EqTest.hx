package scuts.ht;



import scuts.core.Options;
import scuts.core.Tuples;
import scuts.core.Validations.Validation;

using scuts.ht.Context;

private typedef A = utest.Assert;



class EqTest
{

  public function new() {}
 
  
  public function testNestedStructure () 
  {
    var a = Some([Tup2.create(1,2), Tup2.create(2,3)]);
    var b = Some([Tup2.create(1,2), Tup2.create(2,3)]);
    var c = Some([Tup2.create(3,2), Tup2.create(2,3)]);
    
    //Assert.areEqual(a, b);
    A.isTrue(a.eq_(b));
    A.isTrue(a.notEq_(c));
    
    
    
  }

  
  public function testNestedStructure2 () 
  {
    var d:Validation<String,String> = Success("gh");
    
    var a = Some([Tup2.create(1,Some(Tup2.create(d,1.1))), Tup2.create(3,Some(Tup2.create(d,1.1)))]);
    var b = Some([Tup2.create(1,Some(Tup2.create(d,1.1))), Tup2.create(3,Some(Tup2.create(d,1.1)))]);
    var c = Some([Tup2.create(1,Some(Tup2.create(d,1.1))), Tup2.create(3,Some(Tup2.create(d,1.2)))]);
    
    A.isTrue(a.eq_(b));
    A.isTrue(a.notEq_(c));

  }
  
  
}