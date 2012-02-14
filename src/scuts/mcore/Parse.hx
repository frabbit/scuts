package scuts.mcore;
#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)


import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;


using StringTools;

//using scuts.Core;

class Parse 
{
  
  public static function createContextAndString (ctx:Dynamic, s:String):{ctx : Dynamic, s:String} 
  {
    if (Std.is(ctx, Array)) {
			var a:Array<Dynamic> = cast ctx;
			ctx = { };
      
			for (i in 0...a.length) {
				Reflect.setField(ctx, "_" + i, a[i]);
			}
			var ereg = ~/[$][{]([0-9]+)[}]/g;
			s = ereg.replace(s, "T___" + "_$1"); 
			
			var ereg = ~/[$]([0-9]+)([^a-zA-Z0-9_])/g;
			s = ereg.replace(s, "T___" + "_$1$2"); 
			var ereg = ~/[$]([0-9]+)$/g;
			s = ereg.replace(s, "T___" + "_$1"); 
			
		} else {
			var ereg = ~/[$][{]([a-zA-Z_][a-zA-Z0-9]*)[}]/g;
			s = ereg.replace(s, "T___$1");
			var ereg = ~/[$]([a-zA-Z_][a-zA-Z0-9]*)([^a-zA-Z0-9_])/g;
			s = ereg.replace(s, "T___$1$2"); 
			var ereg = ~/[$]([a-zA-Z_][a-zA-Z0-9]*)$/g;
			s = ereg.replace(s, "T___$1"); 
		}
    
		if (ctx == null) {
			ctx = { };
		}
		else if (!Reflect.isObject(ctx))  throw "ctx should be Object or Array";
    
    return {ctx:ctx, s:s};
  }
  
	public static function parse (s:String, ?ctx:Dynamic, ?pos:Position):Expr 
	{
		
    var base = createContextAndString(ctx,s);
		var ctx = base.ctx;
    var s = base.s;
		
		pos = pos == null ? Context.currentPos() : pos;

    
    
    var e = try {
      Context.parse(s, pos);
    } catch (error:Dynamic) {
      
      throw error;
    }
    
    return convertExpr(e, ctx, pos);
	}
	
	
	
	static function convertExpr (ex:Expr, ctx:Dynamic, pos:Position) 
  {
		function conv (e:Expr) {
      
			return convertExpr(e, ctx, pos);
		}
		var convType = null;
		function ctxVarToType (a:Dynamic):ComplexType {
			
			return 
				if (Std.is(a, haxe.macro.Type)) {
					
					Convert.typeToComplexType(cast a, pos);
				}
				else if (Check.isExpr(a)) {
          
					switch (a.expr) {
						case EConst(c):
							switch (c) {
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
							throw "Its null";
							null;
					}
				}
				else if (Std.is(a, ComplexType)) {
					convType(a);
				} else if (Std.is(a, String)) {
          try {
            Convert.stringToComplexType(a, pos);
          } catch (e:Dynamic) {
            throw "Variable a is not a Type or a Expr.EConst.CType";
            null;
          }
        }
				else {
					throw "Variable a is not a Type or a Expr.EConst.CType";
					null;
				}
		}
		
		convType = function  (t:Null<ComplexType>) {
			if (t == null) return null;
      
      
      
			
			return switch (t) {
				case TPath(p): 
					if (p.name.startsWith("T___")) {
						var id = p.name.substr("T___".length);
            
      
						var v:ComplexType = ctxVarToType(Reflect.field(ctx, id));
      
						if (v == null) throw id + " not defined";
            
						switch (v) {
              case TPath(vp):
                if (p.params.length > 0) {
                  p.name = vp.name;
                  p.sub = vp.sub;
                  p.pack = vp.pack;
                  convType(t);
                } else {
                  v;
                }
              default:
                throw "assert";
            }
					} else {
            var newParams = [];
            for (tp in p.params) {
              var ct = switch (tp) {
                case TPType(ct): 
                  TPType(ctxVarToType(ct));
                  
                case TPExpr(e): tp;
              }
              newParams.push(ct);
            }
            p.params = newParams;
            t;
          }
          
          
        case TFunction(args, ret): {
          var newArgs = [];
          for (a in args) {
            newArgs.push(convType(a));
          }
          TFunction(newArgs, convType(ret));
        }
				default: t;
			}
		}
		
		
		function ctxVarToTypePath (a:Dynamic):TypePath {
      
			return if (Std.is(a, String)) {
				{ pack: [], sub:null, name:cast(a, String), params:[] };
			} else if (Std.is(a, haxe.macro.Type)) {
				var t:Type = cast a;
				return switch (t) {
					case TInst(ref, p):
						{pack : ref.get().pack, sub: ref.get().module == ref.get().name ? null : ref.get().module, params:[], name:ref.get().name };
					default:
						throw "Not Implemented";
				}
				//TypePrinter.typeStr(cast a, true);
			} else {
				throw "Unexpected";
			}
		}
		
		function complexTypeToExpr (c:ComplexType):Expr {
			switch(c) {
				case TPath(tp): 
					var cur = null;
					if (tp.pack.length > 0) {
						for (p in tp.pack) {
							if (cur == null) {
								cur = Make.mkConstExpr(CIdent(p));
							} else {
								cur = Make.mkFieldExpr(cur, p);
							}
						}
					}
					if (tp.sub != null) {
						if (cur == null) {
							cur = Make.mkConstExpr(CType(tp.sub));
						} else {
							cur = Make.mkFieldExpr(cur, tp.sub);
						}
					}
					
					if (cur == null) {
						cur = Make.mkConstExpr(CType(tp.name));
					} else {
						cur = Make.mkFieldExpr(cur, tp.name);
					}
					return cur;
					
					
				default: throw "Not Implemented";
			}
		}
		
		function ctxVarToExpr (a:Dynamic, ?pos:Position):Expr {
			if (pos == null) pos = Context.currentPos();
			return if (Check.isExpr(a)) {
				cast a;
			} else if (Std.is(a, haxe.macro.Type)) {
				{ expr: EConst(CType(Print.typeStr(cast a, true))), pos: pos };
			}
			else if (Std.is(a, ComplexType)) {
				var ct:ComplexType = cast a;
				return complexTypeToExpr(ct);
			}
			else if (Std.is(a, Int)) {
        { expr: EConst(CInt(Std.string(a))), pos: pos };
      } else {
				Context.makeExpr(a, pos);
			}
		}
		
		if (ex == null) return null;
		return switch (ex.expr) {
      case ECheckType(e, t):
        // TODO is this correct
        conv(e);
			case EConst( c ): 
				switch (c) {
					case CIdent(s), CType(s):
						if (s.startsWith("T___")) {
							var id:String = s.substr("T___".length);
							var v:Expr = ctxVarToExpr(Reflect.field(ctx, id));
							if (v == null) throw id + " not defined";
							v;
						}
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
				for (f in fields) {
					f.expr = conv(f.expr);
				}
				ex;
			case EArrayDecl( values ):
				for (i in 0...values.length) {
					values[i] = conv(values[i]);
				}
				ex;
			case ECall( e, params ):
        
				for (i in 0...params.length) {
					params[i] = conv(params[i]);
				}
        ex.expr = ECall(conv(e), params);
				ex;
			case ENew( t, params ):
        
				for (i in 0...params.length) {
					params[i] = conv(params[i]);
				}
				if (t.name.startsWith("T___")) {
					var id:String = t.name.substr("T___".length);
					var v:TypePath = ctxVarToTypePath(Reflect.field(ctx, id));
					if (v == null) throw id + " not defined";
					t.name = v.name;	
					t.pack = v.pack;
					t.sub = v.sub;
				} else {
            var newParams = [];
            for (tp in t.params) {
              var ct = switch (tp) {
                case TPType(ct): 
                  TPType(ctxVarToType(ct));
                  
                case TPExpr(e): tp;
              }
              newParams.push(ct);
            }
            t.params = newParams;
          }
				ex;
			case EUnop( op, postFix, e ):
				ex.expr = EUnop( op, postFix, conv(e) );
				ex;
			case EVars( vars):
				
				for (i in 0...vars.length) {
					vars[i].type = convType(vars[i].type);
					
          vars[i].expr = conv(vars[i].expr);
          
				}
				ex;
			case EFunction( name, f):
				f.ret = convType(f.ret);
				for (a in f.args) {
					a.type = convType(a.type);
				}
				f.expr = conv(f.expr);
				ex;
			case EBlock( exprs ):
				for (i in 0...exprs.length) {
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
				ex.expr = EIf(conv(econd), conv(eif), conv(eelse));
				ex;
			case EWhile( econd, e, normalWhile ):
				ex.expr = EWhile(conv(econd), conv(e), normalWhile);
				ex;
			case ESwitch( e, cases, edef ):
				for (i in 0...cases.length) {
					
					cases[i].expr = conv(cases[i].expr);
					for (j in 0...cases[i].values.length) {
						cases[i].values[j] = conv(cases[i].values[j]);
					}
				}
				ex.expr = ESwitch(conv(e), cases, conv(edef));
				ex;
			case ETry( e, catches ):
				for (i in 0...catches.length) {
					catches[i].type = convType(catches[i].type);
					catches[i].expr = conv(catches[i].expr);
				}
				ex.expr = ETry(conv(e), catches);
				ex;
			case EReturn( e ):
				ex.expr = EReturn(conv(e));
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
				ex.expr = ECast(conv(e), convType(t));
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
	
}

#end
