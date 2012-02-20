package scuts.mcore;
#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)

private typedef StdType = Type;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import scuts.Scuts;
import scuts.core.types.Option;

using scuts.core.extensions.ArrayExt;
using scuts.core.extensions.StringExt;
//using scuts.Core;

private typedef ParseContext = Dynamic<Dynamic>;
private typedef InputContext = Dynamic;

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
      if (contextIsArray) 
        createContextFromArray(cast inputCtx);
      else if (inputCtx == null) { {};}
      else inputCtx;
  }
  
  public static function prepareString (s:String, useArrayIndexReplacements:Bool):String
  {
    if (useArrayIndexReplacements) 
    {
      var ereg = ~/[$][{]([0-9]+)[}]/g;
      s = ereg.replace(s, TYPE_PREFIX + "_$1"); 
      var ereg = ~/[$]([0-9]+)([^a-zA-Z0-9_])/g;
      s = ereg.replace(s, TYPE_PREFIX + "_$1$2"); 
      var ereg = ~/[$]([0-9]+)$/g;
      s = ereg.replace(s, TYPE_PREFIX + "_$1"); 
    } 
    else 
    {
      
      var ereg = ~/[$][{]([a-zA-Z_][a-zA-Z0-9]*)[}]/g;
      s = ereg.replace(s, TYPE_PREFIX + "$1");
      var ereg = ~/[$]([a-zA-Z_][a-zA-Z0-9]*)([^a-zA-Z0-9_])/g;
      s = ereg.replace(s, TYPE_PREFIX + "$1$2"); 
      var ereg = ~/[$]([a-zA-Z_][a-zA-Z0-9]*)$/g;
      s = ereg.replace(s, TYPE_PREFIX + "$1"); 
    }
		
    return s;
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
    return convertExpr(e, parseContext, pos);
	}
	
	
  static function resolveVar (ctx:ParseContext, id:String):Dynamic
  {
    var v = Reflect.field(ctx, id);
    return 
      if (v == null) Scuts.macroError("Cannot find variable " + id + " in Context");
      else v;
  }
  
  static function ctxVarToComplexType (a:Dynamic, ctx:ParseContext, pos:Position):ComplexType 
  {
    return 
      if (Std.is(a, haxe.macro.Type)) 
      {
        Convert.typeToComplexType(cast a, pos);
      }
      else if (Check.isExpr(a)) 
      {
        switch (a.expr) {
          case EConst(c):
            switch (c) 
            {
              case CType(t):
                var ct = Convert.stringToComplexType(t, pos);
                ct;
              case CString(s):
                Convert.stringToComplexType(s, pos);
              default: 
                throw "Its null";
                null;
            }
          case EType(_, _): 
            var s = Print.exprStr(a);
            Convert.stringToComplexType(s, pos);
          default: 
            Scuts.macroError("Cannot convert context variable " + a + " to ComplexType");
        }
      }
      else if (Std.is(a, ComplexType)) 
      {
        convertType(a, ctx, pos);
      } 
      else if (Std.is(a, String)) 
      {
        try {
          Convert.stringToComplexType(a, pos);
        } catch (e:Dynamic) {
          Scuts.error("Variable a is not a Type or a Expr.EConst.CType");
        }
      }
      else {
        Scuts.error("Variable a is not a Type or a Expr.EConst.CType");
      }
  }
	
  static function convertType (t:ComplexType, ctx:ParseContext, pos:Position) 
  {
    if (t == null) Scuts.error("t shouldn't be null");
    
    return switch (t) {
      case TPath(p): 
        if (isTypePrefix(p.name)) 
        {
          var id = getTypeId(p.name);
          var v:ComplexType = ctxVarToComplexType(resolveVar(ctx, id), ctx, pos);

          switch (v) 
          {
            case TPath(vp):
              if (p.params.length > 0) {
                p.name = vp.name;
                p.sub = vp.sub;
                p.pack = vp.pack;
                convertType(t, ctx, pos);
              } else {
                v;
              }
            default:
              Scuts.error("Assert");
          }
        } 
        else 
        {
          var newParams = p.params.map( function (tp) return switch (tp)
          {
            case TPType(ct): TPType(ctxVarToComplexType(ct, ctx, pos));
            case TPExpr(e):  tp;
          });
          p.params = newParams;
          t;
        }
      case TFunction(args, ret): {
        var newArgs = args.map( function (a) return convertType(a, ctx, pos));
        TFunction(newArgs, convertType(ret, ctx, pos));
      }
      case TAnonymous(fields):
        convertFields(fields, ctx, pos);
        t;
      
      case TParent(tp):
        TParent(convertType(tp, ctx, pos));
        
      case TExtend(tp, fields):
        convertTypePath(tp, ctx, pos);
        convertFields(fields, ctx, pos);
        t;
      case TOptional(to):
        convertType(to, ctx, pos);
        t;
      default: Scuts.notImplemented();
    }
  }
  
  static function convertFields (fields:Array<Field>, ctx:ParseContext, pos:Position) 
  {
    
    for (f in fields) 
    {
      f.kind = switch (f.kind) {
        case FieldType.FFun(fn):
          convertFunction(fn, ctx, pos);
          f.kind;
        case FieldType.FProp(get, set, t, e):
          FProp(get, set, convertType(t, ctx, pos), if (e == null) null else convertExpr(e,ctx, pos));
        case FieldType.FVar(t, e):
          FVar(if (t == null) null else convertType(t, ctx, pos), if (e == null) null else convertExpr(e,ctx, pos));
      }
    }
    return fields;
  }
  
  static function ctxVarToTypePath (a:Dynamic):TypePath 
  {
    return if (Std.is(a, String)) 
      { 
        pack: [], 
        sub:null, 
        name:cast(a, String), 
        params:[] 
      }
    else if (Std.is(a, haxe.macro.Type)) 
    {
      var t:Type = cast a;
      switch (t) 
      {
        case TInst(ref, p):
          var ct = ref.get();
          { 
            pack :  ct.pack, 
            sub:    ct.module == ct.name ? null : ct.module, 
            params: [], 
            name:   ct.name 
          };
        default:
          Scuts.notImplemented();
      }
    } 
    else 
    {
      Scuts.error("Unexpected type, cannot convert " + a + " to TypePath");
    }
  }
  
  static function complexTypeToExpr (c:ComplexType):Expr 
  {
    return switch(c) 
    {
      case TPath(tp): 
        var cur = None;
        if (tp.pack.length > 0) 
          for (p in tp.pack) 
            cur = switch (cur) 
            {
              case Some(v): Some(Make.field(v, p));
              case None:    Some(Make.const(CIdent(p)));
            }
        if (tp.sub != null) 
          cur = switch (cur) 
          {
            case Some(v): Some(Make.field(v, tp.sub));
            case None:    Some(Make.const(CType(tp.sub)));
          }
        switch (cur) 
        {
          case Some(v): Make.field(v, tp.name);
          case None: Make.const(CType(tp.name));
        }
        
      default: 
        // TODO
        Scuts.notImplemented();
    }
  }
  
  static function ctxVarToString (a:Dynamic, ?pos:Position):String 
  {
    return Std.string(a);
  }
  
  static function ctxVarToExpr (a:Dynamic, ?pos:Position):Expr 
  {
    if (pos == null) pos = Context.currentPos();
    return 
      if (Check.isExpr(a)) 
        cast a;
      else if (Std.is(a, haxe.macro.Type)) 
        Make.const(CType(Print.typeStr(cast a, true)), pos);
      else if (Std.is(a, ComplexType)) 
      {
        var ct:ComplexType = cast a;
        return complexTypeToExpr(ct);
      }
      else if (Std.is(a, Int)) 
        Make.const(CInt(Std.string(a)), pos);
      else 
        Context.makeExpr(a, pos);
  }
  
  static function isTypePrefix (s:String) {
    return s.startsWith(TYPE_PREFIX);
  }
  
  static function getTypeId (s:String) {
    if (!isTypePrefix(s)) Scuts.error("Cannot extract type id from type not starting with " + TYPE_PREFIX);
    return s.substr(TYPE_PREFIX.length);
  }
  
  static function convertFunction (f:Function,ctx:Dynamic<Dynamic>, pos:Position):Function 
  {
    
    f.ret = if (f.ret == null) null else convertType(f.ret,ctx, pos);
    for (a in f.args) 
    {
      a.type = if (a.type == null) null else convertType(a.type, ctx, pos);
      a.value = if (a.value == null) null else convertExpr(a.value,ctx, pos);
    }
    f.expr = if (f.expr == null) null else convertExpr(f.expr, ctx, pos);
    
    return f;
  }
  
	static function convertExpr (ex:Expr, ctx:ParseContext, pos:Position) 
  {
		function conv (e:Expr) return convertExpr(e, ctx, pos);
    var convType = function (ct:ComplexType) return convertType(ct, ctx, pos);
    
		return switch (ex.expr) {
      case ECheckType(e, t):
        // TODO is this correct
        Scuts.error("ECheckType is not supported in parsing context");
			case EConst( c ): 
				switch (c) {
					case CIdent(s), CType(s):
						if (isTypePrefix(s)) 
							ctxVarToExpr(resolveVar(ctx, getTypeId(s)));
						else ex;
					default: ex;
				}
			case EArray( e1, e2 ):
				ex.expr = EArray(conv(e1), conv(e2));
				ex;
			case EBinop( op, e1, e2 ):
				ex.expr = EBinop(op, conv(e1), conv(e2));
				ex;
			case EField( e, field ):
				ex.expr = EField( conv(e), field );
				ex;
			case EType( e, field ):
				ex.expr = EType( conv(e), field );
				ex;
			case EParenthesis( e ):
				ex.expr = EParenthesis( conv(e) );
				ex;
			case EObjectDecl( fields):
				for (f in fields) 
        {
					f.expr = conv(f.expr);
				}
				ex;
			case EArrayDecl( values ):
				for (i in 0...values.length) 
        {
					values[i] = conv(values[i]);
				}
				ex;
			case ECall( e, params ):
				for (i in 0...params.length) 
        {
					params[i] = conv(params[i]);
				}
        ex.expr = ECall(conv(e), params);
				ex;
			case ENew( t, params ):
        
				for (i in 0...params.length) 
        {
					params[i] = conv(params[i]);
				}
        convertTypePath(t, ctx, pos);
				ex;
			case EUnop( op, postFix, e ):
				ex.expr = EUnop( op, postFix, conv(e) );
				ex;
			case EVars( vars):
				for (i in 0...vars.length) 
        {
          var v = vars[i];
          v.type = if (v.type == null) null else convType(v.type);
          v.expr = if (v.expr == null) null else conv(v.expr);
				}
				ex;
			case EFunction( name, f):
				convertFunction(f, ctx, pos);
        ex;
			case EBlock( exprs ):
				for (i in 0...exprs.length) 
        {
					exprs[i] = conv(exprs[i]);
				}
				ex;
			case EIn( v, it ):
				ex.expr = EIn(conv(v), conv(it));
				ex;
			case EFor( eIn, expr ):
				ex.expr = EFor(conv(eIn), conv(expr));
				ex;
			case EIf( econd, eif, eelse ):
				ex.expr = EIf(conv(econd), conv(eif), if (eelse == null) null else conv(eelse));
				ex;
			case EWhile( econd, e, normalWhile ):
				ex.expr = EWhile(conv(econd), conv(e), normalWhile);
				ex;
			case ESwitch( e, cases, edef ):
				for (i in 0...cases.length) 
        {
					cases[i].expr = conv(cases[i].expr);
					for (j in 0...cases[i].values.length) 
          {
						cases[i].values[j] = conv(cases[i].values[j]);
					}
				}
        var edef1 = if (edef == null) null else conv(edef);
				ex.expr = ESwitch(conv(e), cases, edef1);
				ex;
			case ETry( e, catches ):
				for (i in 0...catches.length) 
        {
					catches[i].type = convType(catches[i].type);
					catches[i].expr = conv(catches[i].expr);
				}
				ex.expr = ETry(conv(e), catches);
				ex;
			case EReturn( e ):
				ex.expr = EReturn(if (e == null) null else conv(e));
				ex;
			case EBreak:
				ex;
			case EContinue:
				ex;
			case EUntyped( e ):
				ex.expr = EUntyped(conv(e));
				ex;
			case EThrow( e ):
				ex.expr = EThrow(conv(e));
				ex;
			case ECast( e, t):
				ex.expr = ECast(conv(e), if (t == null) null else convType(t));
				ex;
			case EDisplay( e, isCall):
				ex.expr = EDisplay(conv(e), isCall);
				ex;
			case EDisplayNew( t):
				ex;
			case ETernary( econd, eif, eelse ):
				ex.expr = ETernary(conv(econd), conv(eif), conv(eelse));
				ex;
		}
	}
  
  public static function convertTypePath (t:TypePath, ctx:ParseContext, pos:Position):TypePath
  {
    if (isTypePrefix(t.name)) 
    {
      var id = getTypeId(t.name);
      var tp = ctxVarToTypePath(resolveVar(ctx, id));
      t.name = tp.name;	
      t.pack = tp.pack;
      t.sub = tp.sub;
    } 
    else 
    {
      var newParams = t.params.map(function (tp) return switch (tp) {
        case TPType(ct): TPType(ctxVarToComplexType(ct, ctx, pos));
        case TPExpr(e):  tp;
      });
      t.params = newParams;
    }
    return t;
  }
}

#end
