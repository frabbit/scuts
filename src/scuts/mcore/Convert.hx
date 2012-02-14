package scuts.mcore;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)

import haxe.macro.Expr;
import haxe.macro.Context;
import scuts.Scuts;

using scuts.core.extensions.ArrayExt;


class Convert 
{

	public static function stringToComplexType (s:String, ?pos:Position):ComplexType
	{
		if (pos == null) pos = Context.currentPos();
		s = "{ var a:" + s + ";}";
		//trace(s);
		var e = ExtendedContext.parse(s, pos);
    
		return switch (e.expr) {
			case EBlock(b):
				switch (b[0].expr) {
					case EVars(v):
						v[0].type;
					default:Scuts.macroError("assert");
				}
			default: Scuts.macroError("assert");
		}
    
	}
	
	public static function complexTypeToType (t:ComplexType):haxe.macro.Type
	{
    
    var ctAsString = Print.complexTypeStr(t);
		var e = Parse.parse("{ var a : $0 = null; a;}", [ctAsString]);
		return Context.typeof(e);
	}
	
  public static function complexTypeToFullQualifiedComplexType (c:ComplexType):ComplexType
  {
    var ct = complexTypeToFullQualifiedComplexType;
    
    function convFields (fields:Array<Field>) {
      return fields.map(function (f) {
        var k = switch (f.kind) {
          case FFun(f):
            var newF = {
              args: f.args.map(function (a) return if (a.type == null) a else { name: a.name, opt: a.opt, type: ct(a.type), value: a.value}),
              expr: f.expr,
              params: f.params,
              ret: if (f.ret != null) ct(f.ret) else f.ret
            };
            FFun(newF);
          case FVar(t, e):
            FVar(ct(t), e);
          case FProp(get, set, t, e):
            FProp(get, set, ct(t), e);
        }
        return {
          access: f.access,
          doc: f.doc,
          kind: k,
          meta: f.meta,
          name: f.name,
          pos: f.pos
        }
      });
    }
    
    function convTypePath (p:TypePath) {
      // pack must be changed to fq paths
      // try to typeof
      
      var qname = p.pack.join(".") + (p.pack.length > 0 ? "." : "") + p.name;
      
      var testE = "{ var a: " + qname + ((p.params.length > 0) ? ("<" + p.params.map(function (_) return "Int").join(",") + ">") : "") + " = null; a;}";
      
      // todo type parameter constraints can cause problems here.
      
     
      var pos = Context.makePosition({min:0, max:0, file: "Convert.complexTypeToFullQualifiedComplexType"});
      
      var expr = try {
      Context.parse(testE, pos);
      } catch (e:Dynamic) {
        trace(e);
        null;
      }
      
      //trace(qname);
      
      
      
      var packAndName = {
        try {
          var t1 = Context.typeof(expr);
          switch (t1) {
            case haxe.macro.Type.TInst( t, p): 
              var defType = t.get();
              { p:defType.pack, n:defType.name};
            case haxe.macro.Type.TEnum( t, p): 
              var defType = t.get();
              { p:defType.pack, n:defType.name};
            default:
              throw "not implemented";
              
          };
        } catch (e:Dynamic) {
          {p:p.pack, n:p.name};
        }
      }
        
      
      var params = p.params.map(function (tp) {
        return switch (tp) {
          case TPExpr(e): tp; 
          case TypeParam.TPType(t): TPType(ct(t));
        }
      });
      
      
      return {
        name: packAndName.n,
        pack: packAndName.p,
        params: params ,
        sub: p.sub
        
      };
    }
    
    return switch (c) {
      case TAnonymous(fields):
        
        TAnonymous(convFields(fields));
      case TExtend(p, fields):
        TExtend(convTypePath(p), convFields(fields));
      case TFunction(args, ret):
        var newArgs = args.map(function (a) return ct(a));
        var newRet = ct(ret);
        TFunction(newArgs, newRet);
      case TOptional(t): TOptional(ct(t));
      case TParent(t):
        TParent(ct(t));
      case TPath(p):
        TPath(convTypePath(p));
    }
  }
  
	public static function typeToComplexType (t:haxe.macro.Type, ?pos:Position):ComplexType
	{
    if (pos == null) pos = Context.currentPos();
    
    var s = Print.typeStr( t, true);
    
    
    
		return stringToComplexType(s, pos);
	}
	
	
	public static function exprToType (e:Expr) {
    
		return switch (e.expr) {
			case EConst(c):
				switch (c) {
					case CType(t):
						stringToComplexType(t, e.pos);
					default: throw "Expression " + Print.exprStr(e) + " is not a Type";
				}
      case EType(_, _):
        stringToComplexType(Print.exprStr(e), e.pos);
			default: throw "Expression " + Print.exprStr(e) + " is not a Type";
		}
	}
  /* from MacroTools */
  /*
  public static function exprToType(expr:Expr):Type
    {
      return 
        try switch (expr.expr) 
          {
            case EConst(c):
              switch (c) {
                case CType(s): Context.getType(s);
                default: throw expr;
              }
            default: throw expr;
          } 
        catch (e:Dynamic) 
          {
            throw "Unsupported Expression, Type expected";
          }
      
    }
  */
	
}


#end