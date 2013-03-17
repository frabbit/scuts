package scuts.ht;
import scuts.core.Option;
import scuts.core.Tup2;

using scuts.ht.Identity;
using scuts.ht.ImplicitCasts;
using scuts.ht.ImplicitInstances;

import scuts.core.Validation;

private typedef A = utest.Assert;

class EqTest 
{

  public function new() { }
 
  
  public static function testNestedStructure () 
  {
    var a = Some([Tup2.create(1,2), Tup2.create(2,3)]);
    var b = Some([Tup2.create(1,2), Tup2.create(2,3)]);
    var c = Some([Tup2.create(3,2), Tup2.create(2,3)]);
    
    A.isTrue(a.eq(b));
    A.isTrue(!a.eq(c));
  }
  public static function testNestedStructure2 () 
  {
    var d:Validation<String,String> = Success("gh");
    
    var a = Some([Tup2.create(1,Some(Tup2.create(d,1.1))), Tup2.create(3,Some(Tup2.create(d,1.1)))]);
    var b = Some([Tup2.create(1,Some(Tup2.create(d,1.1))), Tup2.create(3,Some(Tup2.create(d,1.1)))]);
    var c = Some([Tup2.create(1,Some(Tup2.create(d,1.1))), Tup2.create(3,Some(Tup2.create(d,1.2)))]);
    
    A.isTrue(a.eq(b));
    A.isTrue(!a.eq(c));
  }
  
  
}