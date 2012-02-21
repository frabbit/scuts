package scuts.mcore.extensions;
import scuts.mcore.Make;

private typedef Var = {name:String, ?type:ComplexType, ?expr:Expr};

class VarExt {
  public static function next (varDef:Var, name:String, ?type:ComplexType, ?expr:Expr) 
    return [varDef, {name:name, type:type, expr:expr}]
  
  public static function after (vars:Array<Var>, name:String, ?type:ComplexType, ?expr:Expr) 
    return [{name:name, type:type, expr:expr}, varDef]
}

class ArrayVarExt 
{
  public static inline function expr (vars:Array<Var>) return Make.vars(vars)
  
  public static function addFront (vars:Array<Var>, name:String, ?type:ComplexType, ?expr:Expr) return [{name:name, type:type, expr:expr}].concat(vars)
  public static function addBack (vars:Array<Var>, name:String, ?type:ComplexType, ?expr:Expr) return vars.concat([{name:name, type:type, expr:expr}])
  
}