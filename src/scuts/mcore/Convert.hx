package scuts.mcore;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)


private typedef MType = haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import scuts.core.Option;
import scuts.core.Validation;
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

    var e = MContext.parse("{ var a:" + s + ";}", pos);
    return e.flatMap(extractType);
    
	}

	public static function complexTypeToType (t:ComplexType):Option<MType>
	{
    var ctAsString = Print.complexType(t);
		
    var e = Parse.parse("{ var a : $0 = null; a;}", [ctAsString]);
    
    
		return MContext.typeof(e);
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
            
            function mapArg (a:FunctionArg) return if (a.type == null) Success(a) else ct(a.type).map(createArg.partial1(a));
            
            return f.args.map(mapArg).catIfAllSuccess();
          }
          function createFunction (args, r) return { args: args, expr: f.expr, params: f.params, ret: r };
          
          return 
            if (f.ret != null) ct(f.ret).zipSuccessLazy(convArgs).map(createFunction.flip().tupled());
            else               convArgs().map(createFunction.partial2(f.ret));
        }
        
        
        function createField (k) return { access: f.access, doc: f.doc, kind: k, meta: f.meta, name: f.name, pos: f.pos };
        
        var k = switch (f.kind) 
        {
          case FFun(f):               convFunction(f).map(FieldType.FFun);
          case FVar(t, e):            ct(t).map(FieldType.FVar.partial2(e));
          case FProp(get, set, t, e): ct(t).map(FieldType.FProp.partial1_2_4(get, set, e));
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
          function extractPackAndNameFromType (t:MType) return switch t 
          {
            case TInst( tr, p): var dt = tr.get(); { p:dt.pack, n:dt.name};
            case TEnum( tr, p): var dt = tr.get(); { p:dt.pack, n:dt.name};
            default:                            Scuts.notImplemented();
          }
          function extractPackAndName () return { p:p.pack, n:p.name };
          
          var packAndName = MContext.typeof(expr).map(extractPackAndNameFromType).getOrElse(extractPackAndName);
          
          return { name: packAndName.n, pack: packAndName.p, params: params, sub: p.sub };
        }
        
        function convParam (tp) return switch (tp) 
        {
          case TPExpr(e): tp.toSuccess(); 
          case TPType(t): ct(t).map(TPType);
        }
        
        return p.params.map(convParam).catIfAllSuccess().map(toTp);
      }
      
      return MContext.parse(testE, pos).flatMap(exprToTypePath);
    }
    
    function funcToFullQualified (args:Array<ComplexType>, ret) 
    {
      var newArgs = args.map(ct).catIfAllSuccess();
      var newRet = ct(ret);
      return newArgs.zipSuccess(newRet).map(TFunction.tupled());
    }
    
    return switch (c) 
    {
      case TAnonymous(fields):   convFields(fields).map(ComplexType.TAnonymous);
      case TExtend(p, fields):   convTypePath(p).zipSuccess(convFields(fields)).map(TExtend.tupled());
      case TFunction(args, ret): funcToFullQualified(args, ret);
      case TOptional(t):         ct(t).map(TOptional);
      case TParent(t):           ct(t).map(TParent);
      case TPath(p):             convTypePath(p).map(TPath);
    }
  }
  
	
	
	
	public static function exprToType (e:Expr):Option<ComplexType> return switch (e.expr) 
  {
    case EConst(c): switch (c) 
    {
      case CType(t): stringToComplexType(t, e.pos).option();
      default:       None;
    }
    case EType(_, _): stringToComplexType(Print.expr(e), e.pos).option();
    default:          None;
  }
	
}


#end