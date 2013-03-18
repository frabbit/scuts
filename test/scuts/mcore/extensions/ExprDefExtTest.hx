package scuts.mcore.ast;

import haxe.macro.Expr;

import scuts.mcore.ast.ExprDefs;
import utest.Assert;

private typedef E = ExprDefs;

class ExprDefsTest 
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