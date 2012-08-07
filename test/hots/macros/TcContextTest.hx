package hots.macros;

import hots.classes.Monoid;
import hots.instances.OptionMonoid;
import hots.instances.ArrayMonoid;
import utest.Assert;

using hots.macros.Resolver;

private class PrivateClass<Z> {
  
  public function new () {}
  public function test2 () 
  {
    var a:Array<Z> = null;
    var m = a.tc(Monoid);
    
    Assert.isTrue(m != null);
  }
  
  public static function test <X> () 
  {
    var a:Array<X> = null;
    var m = a.tc(Monoid);
    
    Assert.isTrue(m != null);
  }
}

class ModuleClass<Z> {
  
  public function new () {}
  public function test2 () 
  {
    var a:Array<Z> = null;
    var m = a.tc(Monoid);
    
    Assert.isTrue(m != null);
  }
  
  public static function test <X> () 
  {
    var a:Array<X> = null;
    var m = a.tc(Monoid);
    
    Assert.isTrue(m != null);
  }
}

class ResolverTest<Z> 
{

  public function new() {}
  
  public function test_resolve_with_unknown_types () 
  {
    var a = [];
    var m = a.tc(Monoid);
    Assert.isTrue(m != null);
  }
  
  public function test_resolve_with_type_params <X> () 
  {
    var a:Array<X> = null;
    var m = a.tc(Monoid);
    
    Assert.isTrue(m != null);
  }
  
  public function test_resolve_with_class_params () 
  {
    var a:Array<Z> = null;
    var m = a.tc(Monoid);
    
    Assert.isTrue(m != null);
  }
  
  public function test_resolve_with_function_type_params_in_private_class () 
  {
    PrivateClass.test();
  }
  
  public function test_resolve_with_function_type_params_in_other_module_class () 
  {
    ModuleClass.test();
  }
  
  public function test_resolve_with_class_type_params_in_private_class () 
  {
    new PrivateClass().test2();
  }
  
  public function test_resolve_with_class_type_params_in_other_module_class () 
  {
    new ModuleClass().test2();
  }
  
}