package scuts.mcore.extensions;

#if macro

import scuts.mcore.Make;
import haxe.macro.Expr;

private typedef Var = {name:String, ?type:ComplexType, ?expr:Expr};

class Vars 
{
  public static function next (varDef:Var, name:String, ?type:ComplexType, ?expr:Expr) 
  {
    return [varDef, { name:name, type:type, expr:expr } ];
  }
  
  public static function after (varDef:Var, name:String, ?type:ComplexType, ?expr:Expr) 
  {
    return [ { name:name, type:type, expr:expr }, varDef];
  }
}

class ArrayVars 
{
  public static inline function toExpr (vars:Array<Var>) return Make.vars(vars)

}

#end