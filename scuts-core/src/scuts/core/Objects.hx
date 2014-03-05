package scuts.core;

#if macro 

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.TypeTools;

#end


class Objects
{
  public static inline function field (v:{}, field:String):Dynamic return Reflect.field(v, field);
  
  public static inline function setField  <T>(v:{}, field:String, value:Dynamic):{}
  {
    Reflect.setField(v, field, value);
    return v;
  }
  
  public static inline function hasField (v:{}, field:String):Bool return Reflect.hasField(v, field);

  public static inline function fields (v:{}, field:String):Array<String> return Reflect.fields(v);

  macro public static inline function copyWith (x:ExprOf<{}>, n:ExprOf<{}>):Expr 
  {
  	var baseType = Context.typeof(x);
  	var t = Context.follow(baseType);
  	return switch [t, n.expr] {
  		case [TAnonymous(a), EObjectDecl(fields2)]:
  			var fields1 = a.get().fields;
  			var fields1 = [for (f in fields1) f.name => f];
  			var fields2 = [for (f in fields2) f.field => f];

  			for (k in fields2.keys()) {
  				if (!fields1.exists(k)) Context.error('x has no field $k specified in n', n.pos);
  			}

  			function getExpr(k:String) {
  				return if (fields2.exists(k)) fields2[k].expr else macro $x.$k;
  			}

  			var resFields = [for (k in fields1.keys()) { field : fields1[k].name, expr : getExpr(k)}];

  			var e = { expr : ECheckType({expr:EObjectDecl(resFields), pos:n.pos}, TypeTools.toComplexType(baseType)), pos : n.pos }; 
  			

  			return e;

  			// all fields are part of x


  		case _ : Context.error("unsupported arguments, x should be an Anonymous Object and n should be EObjectDecl.", x.pos);
  	}
  }
  
}