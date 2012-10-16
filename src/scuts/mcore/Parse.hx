package scuts.mcore;
#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)


import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import scuts.core.debug.Assert;
import scuts.core.Validations;
import scuts.core.Log;
import scuts.core.std.StdType;
import scuts.Scuts;
import scuts.core.Option;
using scuts.core.Functions;
using scuts.core.Arrays;
using scuts.core.Strings;
using scuts.core.Options;
using scuts.core.Dynamics;
//using scuts.Core;

import scuts.core.Validation;
using scuts.core.Validations;

using scuts.core.Functions;
using scuts.core.Log;
private typedef ParseContext = Dynamic<Dynamic>;
private typedef InputContext = Dynamic;


private typedef ParseResult<T> = Validation<ParseError, T>;

enum ParseError {
  
  // Scuts.macroError("Cannot find variable " + id + " in Context");
  ContextVarNotFound(id:String);
  //  Scuts.error("Cannot extract type id from type not starting with " + TYPE_PREFIX);
  TypeIdExtractError(prefix:String);
  // Scuts.macroError("Cannot convert context variable " + id + " to ComplexType");
  ContextVarConversionToComplexTypeFailed(id:Dynamic);
  CompilerError(e:Error);
  // Scuts.error("Unexpected type, cannot convert " + a + " to TypePath");
  ConvertToTypePathFailed(a:Dynamic);
  ConvertComplexTypeToExprPathFailed(a:ComplexType);
  UnsupportedContextVariableForType(a:Dynamic);
  
}

class Parse 
{
  
  static inline var TYPE_PREFIX = "T___";
  
  static function createContextFromArray (arr:Array<Dynamic>):ParseContext 
  {
    var c = { };
    for (i in 0...arr.length) 
      Reflect.setField(c, "_" + i, arr[i]);
    return c;
  }
  
  static function createContext (inputCtx:InputContext, contextIsArray:Bool):ParseContext 
  {
    return 
      if (contextIsArray)        createContextFromArray(cast inputCtx);
      else if (inputCtx == null) { {};}
      else                       inputCtx;
  }
  
  public static function prepareString (s:String, useArrayIndexReplacements:Bool):String
  {
    return if (useArrayIndexReplacements) 
    {
      var ereg = ~/[$][{]([0-9]+)[}]/g;
      var s1 = ereg.replace(s, TYPE_PREFIX + "_$1"); 
      
      var ereg = ~/[$]([0-9]+)([^a-zA-Z0-9_])/g;
      var s2 = ereg.replace(s1, TYPE_PREFIX + "_$1$2"); 
      
      var ereg = ~/[$]([0-9]+)$/g;
      ereg.replace(s2, TYPE_PREFIX + "_$1"); 
    }
    else 
    {
      var ereg = ~/[$][{]([a-zA-Z_][a-zA-Z0-9]*)[}]/g;
      var s1 = ereg.replace(s, TYPE_PREFIX + "$1");
      
      var ereg = ~/[$]([a-zA-Z_][a-zA-Z0-9]*)([^a-zA-Z0-9_])/g;
      var s2 = ereg.replace(s1, TYPE_PREFIX + "$1$2"); 
      
      var ereg = ~/[$]([a-zA-Z_][a-zA-Z0-9]*)$/g;
      ereg.replace(s2, TYPE_PREFIX + "$1"); 
    }
    
  }
  
  public static function parseToType (s:String, ?context:Dynamic, ?pos:Position):Option<Type>
  {
    return (function () return Context.typeof(parse("{ var x : " + s + " = null; x;}", context, pos))).evalToOption();
  }
  
  public static function parseToComplexType (s:String, ?context:Dynamic, ?pos:Position):Option<ComplexType>
  {
    var parsed = parse("{ var x : " + s + " = null; x;}", context, pos);
    
    return Select.selectEVarsVarAt(parsed, 0).flatMap(function (x) return x.type.nullToOption());
    
  }
  
	public static function parse (s:String, ?context:Dynamic, ?pos:Position):Expr 
	{
		var contextIsArray = Std.is(context, Array);
    var s = prepareString(s, contextIsArray);
    var parseContext = createContext(context, contextIsArray);
    
		pos = pos == null ? Context.currentPos() : pos;

    var e = try 
    {
      Context.parse(s, pos);
    } 
    catch (error:Dynamic) 
    {
      Scuts.error(error);
    }
    return convertExpr(e, parseContext, pos).mapFailure(function (f) trace(f)).extract();
	}
	
	
  static function resolveVar (ctx:ParseContext, id:String):ParseResult<Dynamic>
  {
    var v = Reflect.field(ctx, id);
    return 
      if (v == null) ParseError.ContextVarNotFound(id).toFailure()
      else           Success(v);
  }
  
  static function ctxVarToComplexType (a:Dynamic, ctx:ParseContext, pos:Position):ParseResult<ComplexType>
  {
    function exprToComplexType (a:Expr) return switch (a.expr) 
    {
      case EConst(c): switch (c) 
      {
        case CType(x),CString(x): Convert.stringToComplexType(x, pos).mapFailure(CompilerError);
        default:                  ContextVarConversionToComplexTypeFailed(a).toFailure();
      }
      case EType(_, _): 
        var s = Print.expr(a);
        Convert.stringToComplexType(s, pos).mapFailure(CompilerError);
      default: 
        ContextVarConversionToComplexTypeFailed(a).toFailure();
    }
    
    return 
      if (Std.is(a, haxe.macro.Type))  Convert.typeToComplexType(cast a, pos).mapFailure(CompilerError)
      else if (Check.isExpr(a))        exprToComplexType(a)
      else if (Std.is(a, ComplexType)) convertType(a, ctx, pos)
      else if (Std.is(a, String))      Convert.stringToComplexType(a, pos).mapFailure(UnsupportedContextVariableForType.partial1(a).promote())
      else                             UnsupportedContextVariableForType(a).toFailure();
  }
	
  static function mapAndCatIfAllSuccess <A,B>(v:Array<A>, f:A->ParseResult<B>):ParseResult<Array<B>>
  {
    var r = [];
    for (e in v) {
      switch (f(e)) {
        case Success(s): r.push(s);
        case Failure(f): return f.toFailure();
      }
    }
    return r.toSuccess();
  }
  
  static function convertType (t:ComplexType, ctx:ParseContext, pos:Position):ParseResult<ComplexType> 
  {
    function convTypePath (p:TypePath) 
    {
      function substituteTypeParam (tp) return switch tp
      {
        case TPType(ct): ctxVarToComplexType(ct, ctx, pos).map(TPType);
        case TPExpr(e):  tp.toSuccess();
      }

      function substituteTypeParams (params:Array<TypeParam>) return mapAndCatIfAllSuccess(params, substituteTypeParam );
      
      function makeTypePath (pack, name, sub, params) return { pack : pack, name : name, params : params ,sub : sub };
      
      function substituteTypeParamsInComplexType (ct:ComplexType) return switch ct
      {
        case TPath(vp): substituteTypeParams(vp.params).map(makeTypePath.partial1_2_3(vp.pack, vp.name, vp.sub));
        default: Scuts.unexpected();
      }
      
      return if (isTypePrefix(p.name)) 
      {
        getTypeId(p.name)
        .flatMap(resolveVar.partial1(ctx))
        .flatMap(ctxVarToComplexType.partial2_3(ctx, pos))
        .flatMap(substituteTypeParamsInComplexType);
      } 
      else substituteTypeParams(p.params).map(makeTypePath.partial1_2_3(p.pack, p.name, p.sub));
    }

    return switch (Assert.notNull(t,t)) 
    {
      case TPath(p):             convTypePath(p).map(TPath);
      case TFunction(args, ret): var a = mapAndCatIfAllSuccess(args, convertType.partial2_3(ctx,pos));
                                 zip2w(a, convertType(ret, ctx, pos), TFunction);
      case TAnonymous(fields):   convertFields(fields, ctx, pos).map(TAnonymous);
      case TParent(tp):          convertType(tp, ctx, pos).map(TParent);
      case TExtend(tp, fields):  zip2w(convTypePath(tp), convertFields(fields, ctx, pos), TExtend);
      case TOptional(to):        convertType(to, ctx, pos).map(TOptional);
      default:                   Scuts.notImplemented();
    }
  }

  static function convertFields (fields:Array<Field>, ctx:ParseContext, pos:Position):ParseResult<Array<Field>> 
  {
    function convKind (k) return switch (k) 
    {
      case FieldType.FFun(fn):
        convertFunction(fn, ctx, pos).map(FieldType.FFun);
        
      case FieldType.FProp(get, set, t, e):
        convertTypeIfNotNull(t, ctx, pos)
        .zipSuccessLazy(convertExprIfNotNull.partial1_2_3(e, ctx, pos))
        .map(FieldType.FProp.partial1_2(get, set).tupled());
        
      case FieldType.FVar(t, e):
        convertTypeIfNotNull(t, ctx, pos)
        .zipSuccessLazy(convertExprIfNotNull.partial1_2_3(e, ctx, pos))
        .map(FieldType.FVar.tupled());
    }

    function convField (f:Field) 
    {
      function mkField (k) return { name : f.name, doc : f.doc, access : f.access, kind : k, pos : f.pos, meta : f.meta };
      
      return convKind(f.kind).map(mkField);
    }
    
    return mapAndCatIfAllSuccess(fields, convField);
  }
  
  static function ctxVarToTypePath (a:Dynamic):ParseResult<TypePath>
  {
    function stringToTp (s:String) return { pack: [], sub:null, name:s, params:[] } .toSuccess();
    
    function typeToTp (t:Type) return switch (t) 
    {
      case TInst(ref, p):
        var ct = ref.get();
        var sub = if (ct.module == ct.name) null else ct.module;
        { pack :  ct.pack, sub: sub, params: [], name:   ct.name } .toSuccess();
      default:
        Scuts.notImplemented();
    }
    
    return 
      if (Std.is(a, String))               stringToTp(cast a);
      else if (Std.is(a, haxe.macro.Type)) typeToTp(cast a);
      else                                 ConvertToTypePathFailed(a).toFailure();
  }
  
  static function typePathToExpr (tp:TypePath):Expr 
  {

    function concatPack ():Option<Expr> 
    {
      var mkConstIdent = Make.const.compose(CIdent);
      
      return 
        if (tp.pack.length > 0) Some(tp.pack.reduceLeft(Make.field.partial0_(), mkConstIdent))
        else                    None;
    }
    
    function concatSub (e:Expr):Expr 
    {
      return 
        if (tp.sub != null) Make.field(e, tp.sub)
        else                e;
    }
      
    function mkType () return Make.const(CType(tp.name));

    return concatPack().map(concatSub).map(Make.field.partial2_(tp.name)).getOrElse(mkType);
  }
  
  static function complexTypeToExpr (c:ComplexType):ParseResult<Expr> return switch c 
  {
    case TPath(tp): typePathToExpr(tp).toSuccess();
    default:        ConvertComplexTypeToExprPathFailed(c).toFailure();
  }
  
  static function ctxVarToString (a:Dynamic):String 
  {
    return Std.string(a);
  }
  
  static function ctxVarToExpr (a:Dynamic, ?pos:Position):ParseResult<Expr>
  {
    var p = if (pos == null) Context.currentPos() else pos;
    
    return 
      if (Check.isExpr(a))                 (cast a).toSuccess()
      else if (Std.is(a, haxe.macro.Type)) Make.const(CType(Print.type(cast a, true)), p).toSuccess()
      else if (Std.is(a, ComplexType))     complexTypeToExpr(cast a)
      else if (Std.is(a, Int))             Make.const(CInt(Std.string(a)), pos).toSuccess()
      else                                 Context.makeExpr(a, p).toSuccess();
  }
  
  static function isTypePrefix (s:String) 
  {
    return s.startsWith(TYPE_PREFIX);
  }
  
  static function getTypeId (s:String):ParseResult<String> 
  {
    return 
      if (!isTypePrefix(s)) TypeIdExtractError(TYPE_PREFIX).toFailure();
      else                  s.substr(TYPE_PREFIX.length).toSuccess();
  }
  
  static function convertFunction (f:Function,ctx:Dynamic<Dynamic>, pos:Position):ParseResult<Function>
  {
    var convType = convertTypeIfNotNull.partial2_3(ctx, pos);
    
    var convExpr = convertExprIfNotNull.partial2_3(ctx, pos);
    
    function convArg (a:FunctionArg) 
    {
      function mkArg (t,v) return { name : a.name, type : t, value : v, opt : a.opt };

      return convType(a.type).zipSuccess(convExpr(a.value)).map(mkArg.tupled());
    }

    function convArgs() return mapAndCatIfAllSuccess(f.args, convArg);
    
    function mkFun (ret, ex, args) return { ret : ret, args : args, expr : ex, params : f.params };
    
    
    var convFunExpr = convExpr.partial1(f.expr);
    
    return convType(f.ret).zipSuccessLazy2(convFunExpr, convArgs).map(mkFun.tupled());
  }
  
  static function convertExprIfNotNull (ex:Expr, ctx:ParseContext, pos:Position):ParseResult<Expr> 
  {
    return ex == null ? Success(null) : convertExpr(ex, ctx, pos);
  }
  
  static function convertTypeIfNotNull (t:ComplexType, ctx:ParseContext, pos:Position):ParseResult<ComplexType>
  {
    return t == null ? Success(null) : convertType(t, ctx, pos);
  }
  
  static function zip2w <A,B,C>(a:ParseResult<A>, b:ParseResult<B>, f:A->B->C) 
  {
    return a.zipSuccess(b).map(f.tupled());
  }
  
  static function zip3w <A,B,C,D>(a:ParseResult<A>, b:ParseResult<B>, c:ParseResult<C>, f:A->B->C->D) 
  {
    return a.zipSuccess2(b,c).map(f.tupled());
  }
  
	static function convertExpr (ex:Expr, ctx:ParseContext, pos:Position):ParseResult<Expr>
  {
		var conv = convertExpr.partial2_3(ctx, pos);
    var convExprIfNotNull = convertExprIfNotNull.partial2_3(ctx, pos);
    
    var convType = convertType.partial2_3(ctx, pos);
    var convTypeIfNotNull = convertTypeIfNotNull.partial2_3(ctx, pos);
    
    function convObj (fields:Array<{ field : String, expr : Expr }>):ParseResult<ExprDef> 
    {
      function mkObjField (e, field) return { expr : e, field : field};
      function convObjField (f) return conv(f.expr).map(mkObjField.partial2(f.field));
      
      return mapAndCatIfAllSuccess(fields, convObjField).map(EObjectDecl);
    }
    
    function convConst (c) return switch (c) 
    {
      case CIdent(s), CType(s):
        if (isTypePrefix(s)) getTypeId(s).flatMap(resolveVar.partial1(ctx)).flatMap(ctxVarToExpr.partial0_()).map(function (e) return e.expr);
        else                 EConst(c).toSuccess();
      default: EConst(c).toSuccess();
    }
    
    function convVars (vars:Array<{ type : Null<ComplexType>, name : String, expr : Null<Expr> }>) 
    {
      
      function convVar (v:{ name : String, type : Null<ComplexType>, expr : Null<Expr> })  
      {
        function mkVar (t, e) return { type : t, expr : e, name : v.name };
        return convType(v.type).zipSuccess(conv(v.expr)).map(mkVar.tupled());
      }
      return mapAndCatIfAllSuccess(vars,convVar).map(EVars);
    }
    
    
    function convSwitch (e, cases:Array<{ values : Array<Expr>, expr : Expr }>, edef) 
    {
      function mkCase (e,values) return { expr : e, values : values };
      function convCase (c: { values : Array<Expr>, expr : Expr } ) 
      {
        return zip2w(conv(c.expr), mapAndCatIfAllSuccess(c.values, conv), mkCase);
      }

      var cases = mapAndCatIfAllSuccess(cases, convCase);
      var edef1 = convExprIfNotNull(edef);

      return zip3w(conv(e), cases, edef1, ESwitch);
    }
    
    function convTry (e, catches:Array<{ type : ComplexType, name : String, expr : Expr }>) 
    {
      function mkCatch (name, e,t) return { type : t, expr : e, name : name };
      function convCatch (c) return zip2w(conv(c.expr), convType(c.type), mkCatch.partial1(c.name));
      
      return zip2w(conv(e), mapAndCatIfAllSuccess(catches,convCatch), ETry);
    }
    
		function convExprDef (ed) return switch (ed) 
    {
      case ECheckType(e, t):                zip2w(conv(e), convType(t), ECheckType);
			case EConst( c ):                     convConst(c);
			case EArray( e1, e2 ):                zip2w(conv(e1), conv(e2), EArray);
			case EBinop( op, e1, e2 ):            zip2w(conv(e1), conv(e2), EBinop.partial1(op));
			case EField( e, field ):              conv(e).map(EField.partial2(field));
			case EType( e, field ):               conv(e).map(EType.partial2(field));
      case EParenthesis( e ):               conv(e).map(EParenthesis);
			case EObjectDecl( fields):            convObj(fields);
			case EArrayDecl( values ):            mapAndCatIfAllSuccess(values, conv).map(EArrayDecl);
			case ECall( e, params ):              zip2w(conv(e), mapAndCatIfAllSuccess(params, conv), ECall);
			case ENew( t, params ):               zip2w(convertTypePath(t, ctx, pos), mapAndCatIfAllSuccess(params, conv), ENew);
			case EUnop( op, postFix, e ):         conv(e).map(EUnop.partial1_2(op, postFix));
			case EVars( vars):                    convVars(vars);
			case EFunction( name, f):             convertFunction(f, ctx, pos).map(EFunction.partial1(name));
			case EBlock( exprs ):                 mapAndCatIfAllSuccess(exprs,conv).map(EBlock);
			case EIn( v, it ):                    zip2w(conv(v), conv(it), EIn);
			case EFor( eIn, expr ):               zip2w(conv(eIn), conv(expr), EFor);
			case EIf( econd, eif, eelse ):        zip3w(conv(econd), conv(eif), convExprIfNotNull(eelse), EIf);
			case EWhile( econd, e, normalWhile ): zip2w(conv(econd), conv(e), EWhile.partial3(normalWhile));
			case ESwitch( e, cases, edef ):       convSwitch(e,cases,edef);
			case ETry( e, catches ):              convTry(e,catches);
			case EReturn( e ):                    convExprIfNotNull(e).map(EReturn);
			case EBreak:                          EBreak.toSuccess();
			case EContinue:                       EContinue.toSuccess();
			case EUntyped( e ):                   conv(e).map(EUntyped);
			case EThrow( e ):                     conv(e).map(EThrow);
			case ECast( e, t):                    zip2w(conv(e), convTypeIfNotNull(t), ECast);
			case EDisplay( e, isCall):            conv(e).map(EDisplay.partial2(isCall));
			case EDisplayNew( t):                 convertTypePath(t, ctx, pos).map(EDisplayNew);
			case ETernary( econd, eif, eelse ):   zip3w(conv(econd), conv(eif), convExprIfNotNull(eelse), ETernary);
		}
    
    function mkExpr(def) return { expr : def, pos : ex.pos }
    
    return convExprDef(ex.expr).map(mkExpr);
	}
  
  public static function convertTypePath (t:TypePath, ctx:ParseContext, pos:Position):Validation<ParseError, TypePath>
  {
    function convertTypeParam (tp:TypeParam) return switch (tp) 
    {
      case TPType(ct): ctxVarToComplexType(ct, ctx, pos).map(TPType);
      case TPExpr(e):  tp.toSuccess();
    }
    
    function createTypePathWithNewParams (params) return { pack :  t.pack, sub: t.sub, params: params, name: t.name };
    
    return switch (isTypePrefix(t.name))
    {
      case true:  getTypeId(t.name).flatMap(resolveVar.partial1(ctx)).flatMap(ctxVarToTypePath);
      case false: mapAndCatIfAllSuccess(t.params, convertTypeParam).map(createTypePathWithNewParams);
    }
  }
}

#end
