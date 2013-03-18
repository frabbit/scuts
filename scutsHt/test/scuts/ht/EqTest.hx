package scuts.ht;

import massive.munit.Assert;
import org.hamcrest.core.IsEqual;
import org.hamcrest.MatchersBase;

import scuts.core.Options;
import scuts.core.Tuples;
import scuts.core.Validations.Validation;

using scuts.ht.Context;





class EqTest extends MatchersBase
{

  public function new() super();
 
  @Test
  public function testNestedStructure () 
  {
    var a = Some([Tup2.create(1,2), Tup2.create(2,3)]);
    var b = Some([Tup2.create(1,2), Tup2.create(2,3)]);
    var c = Some([Tup2.create(3,2), Tup2.create(2,3)]);
    
    //Assert.areEqual(a, b);
    scuts.Assert.isTrue(a.eq_(b));
    scuts.Assert.isTrue(a.notEq_(c));
    
    
  }

  @Test
  public function testNestedStructure2 () 
  {
    var d:Validation<String,String> = Success("gh");
    
    var a = Some([Tup2.create(1,Some(Tup2.create(d,1.1))), Tup2.create(3,Some(Tup2.create(d,1.1)))]);
    var b = Some([Tup2.create(1,Some(Tup2.create(d,1.1))), Tup2.create(3,Some(Tup2.create(d,1.1)))]);
    var c = Some([Tup2.create(1,Some(Tup2.create(d,1.1))), Tup2.create(3,Some(Tup2.create(d,1.2)))]);
    
    scuts.Assert.isTrue(a.eq_(b));
    scuts.Assert.isTrue(a.notEq_(c));

  }
  
  
}