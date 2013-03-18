package scuts.mcore;

#if macro


import haxe.macro.Expr;
import haxe.macro.Context;


import scuts.Scuts;

using scuts.core.Arrays;
using scuts.core.Eithers;
using scuts.core.Validations;
using scuts.core.Functions;
using scuts.core.Options;

class Convert 
{

	public static function stringToComplexType (s:String, ?pos:Position):Validation<Error, ComplexType>
	{
		if (pos == null) pos = Context.currentPos();
		
		//trace(s);

    function extractType (e:Expr) return switch (e.expr) 
    {
			case EBlock(b): switch (b[0].expr) 
      {
        case EVars(v): v[0].type.toSuccess();
        default:       Scuts.unexpected();
      }
			default: Scuts.unexpected();
    }

    var e = MCore.parse("{ var a:" + s + ";}", pos);
    return e.flatMap(extractType);
    
	}

	public static function complexTypeToType (t:ComplexType):Option<haxe.macro.Type>
	{
    var ctAsString = Print.complexType(t);
		
    var e = Parse.parse("{ var a : $0 = null; a;}", [ctAsString]);
    
    
		return MCore.typeof(e);
	}

  public static function typeToComplexType (t:haxe.macro.Type):Validation<Error, ComplexType>
  {
    return try {
      Success(haxe.macro.TypeTools.toComplexType(t));
    } catch (e:Error) {
      Failure(e);
    }
    
  }
	
  public static function complexTypeToFullQualifiedComplexType (c:ComplexType):Validation<Error, ComplexType>
  {
    var ct = complexTypeToFullQualifiedComplexType;
    
    function convFields (fields:Array<Field>):Validation<Error, Array<Field>> 
    {
      function convField (f:Field) 
      {
        function convFunction (f:Function) 
        {
          function convArgs () 
          {
            function createArg (a, t) return { name: a.name, opt: a.opt, type: t, value: a.value };
            
            function mapArg (a:FunctionArg) return if (a.type == null) Success(a) else ct(a.type).map(createArg.bind(a));
            
            return f.args.map(mapArg).catIfAllSuccess();
          }
          function createFunction (args, r) return { args: args, expr: f.expr, params: f.params, ret: r };
          
          return 
            if (f.ret != null) ct(f.ret).zipLazy(convArgs).map(createFunction.flip().tupled());
            else               convArgs().map(createFunction.bind(_,f.ret));
        }
        
        
        function createField (k) return { access: f.access, doc: f.doc, kind: k, meta: f.meta, name: f.name, pos: f.pos };
        
        var k = switch (f.kind) 
        {
          case FFun(f):               convFunction(f).map(FieldType.FFun);
          case FVar(t, e):            ct(t).map(FieldType.FVar.bind(_,e));
          case FProp(get, set, t, e): ct(t).map(FieldType.FProp.bind(get, set, _, e));
        }
        
        return k.map(createField);
      }
      
      return fields.map(convField).catIfAllSuccess();
    }
    
    function convTypePath (p:TypePath):Validation<Error, TypePath> 
    {
      // pack must be changed to fq paths
      
      var qname = p.pack.join(".") + (p.pack.length > 0 ? "." : "") + p.name;
      
      var testE = "{ var a: " + qname + ((p.params.length > 0) ? ("<" + p.params.map(function (_) return "Int").join(",") + ">") : "") + " = null; a;}";
      
      var pos = Context.makePosition({min:0, max:0, file: "Convert.complexTypeToFullQualifiedComplexType"});
 
      
      function exprToTypePath (expr:Expr):Validation<Error, TypePath>
      {
        function toTp (params) 
        {
          function extractPackAndNameFromType (t:haxe.macro.Type) return switch t 
          {
            case TInst( tr, _): var dt = tr.get(); { p:dt.pack, n:dt.name};
            case TEnum( tr, _): var dt = tr.get(); { p:dt.pack, n:dt.name};
            default:                            Scuts.notImplemented();
          }
          function extractPackAndName () return { p:p.pack, n:p.name };
          
          var packAndName = MCore.typeof(expr).map(extractPackAndNameFromType).getOrElse(extractPackAndName);
          
          return { name: packAndName.n, pack: packAndName.p, params: params, sub: p.sub };
        }
        
        function convParam (tp) return switch (tp) 
        {
          case TPExpr(_): tp.toSuccess(); 
          case TPType(t): ct(t).map(TPType);
        }
        
        return p.params.map(convParam).catIfAllSuccess().map(toTp);
      }
      
      return MCore.parse(testE, pos).flatMap(exprToTypePath);
    }
    
    function funcToFullQualified (args:Array<ComplexType>, ret) 
    {
      var newArgs = args.map(ct).catIfAllSuccess();
      var newRet = ct(ret);
      return newArgs.zip(newRet).map(TFunction.tupled());
    }
    
    return switch (c) 
    {
      case TAnonymous(fields):   convFields(fields).map(ComplexType.TAnonymous);
      case TExtend(p, fields):   convTypePath(p).zip(convFields(fields)).map(TExtend.tupled());
      case TFunction(args, ret): funcToFullQualified(args, ret);
      case TOptional(t):         ct(t).map(TOptional);
      case TParent(t):           ct(t).map(TParent);
      case TPath(p):             convTypePath(p).map(TPath);
    }
  }
  
	
	
	
	// public static function exprToType (e:Expr):Option<ComplexType> return switch (e.expr) 
 //  {
 //    case EConst(c): switch (c) 
 //    {
 //      case CType(t): stringToComplexType(t, e.pos).option();
 //      default:       None;
 //    }
 //    case EType(_, _): stringToComplexType(Print.expr(e), e.pos).option();
 //    default:          None;
 //  }
	
}


#end