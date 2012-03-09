package scuts.mcore.extensions;

import haxe.macro.Expr;

import scuts.mcore.extensions.ExprDefExt;
import utest.Assert;

private typedef E = ExprDefExt;

class ExprDefExtTest 
{

  public function new() 
  {
    
  }
  
  public function testEq() 
  {
    var a = EBlock([]);
    var b = EBlock([]);

    Assert.isTrue(E.eq(a,b));
  }
  
}