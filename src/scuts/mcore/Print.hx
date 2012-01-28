package scuts.mcore;


#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)

using scuts.core.extensions.ArrayExt;
using scuts.core.extensions.IterableExt;

import scuts.CoreTypes.F;

//using scuts.core.Fold;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Binop;
import haxe.macro.Type;

private typedef SType = scuts.mcore.Type;


//using Lambda;


class Print 
{

	//{ region public
  public static function unopStr (op:Unop, indent:Int = 0, indentStr = "\t"):String
    {
      
      return unopStr1(op, new StringBuf(), indent, indentStr).toString();
    }
  
    /*
   public static function typeStr (type:Type):String
    {
      return typeStr1(type, new StringBuf()).toString();
    }
*/
  
  public static function exprStr (expr:Expr, indent:Int = 0, indentStr = "\t"):String 
    {
      
      var buf = new StringBuf();
      addIndent(buf, indent, indentStr);
      return exprStr1(expr, buf, indent, indentStr).toString();
    }
  
  public static function binopStr (op:Binop):String 
    {
      return binopStr1(op, new StringBuf()).toString();
    }
  
  public static function constStr (c:Constant):String 
    {
      return constStr1(c, new StringBuf()).toString();
    }
    
  public static function typeParamValueStr (typeParam:TypeParam, ?cl:Array<TypeParam>, indent:Int = 0, indentStr = "\t"):String 
    {
      return typeParamValueStr1(typeParam, new StringBuf(), indent, indentStr, cl).toString();
    }
  
  public static function typeParamValuesStr (typeParams:Array<TypeParam>, ?cl:Array<TypeParam>, indent:Int = 0, indentStr = "\t"):String 
    {
      return typeParamValuesStr1(typeParams, new StringBuf(), indent, indentStr, cl).toString();
    }
  
  public static function complexTypeStr (c:ComplexType, indent:Int = 0, indentStr:String = "\t"):String
    {
      return complexTypeStr1(c, new StringBuf(), indent, indentStr).toString();
      
    }
    
  public static function functionStr(f:Function, functionName:String = "", indent:Int = 0, indentStr:String = "\t"):String
    {
      return functionStr1(f, new StringBuf(), indent, indentStr, functionName).toString();
    }
	
  public static function fieldStr(f:Field, indent:Int = 0, indentStr:String = "\t"):String
    {
      return fieldStr1(f, new StringBuf(), indent, indentStr).toString();
    }
	
  public static function functionSignatureStr(f:Function, ?functionName:String = "", indent:Int = 0, indentStr:String = "\t"):StringBuf 
    {
      return functionStr1(f, new StringBuf(), indent, indentStr, functionName, true);
    }

  //} region public
  
  
  
  
  //{ region private
  static function newLine (buf:StringBuf, indent:Int,indentStr:String) 
  {
    buf.add("\n");
    
    addIndent(buf, indent, indentStr);
    return buf;
  }
  
  public static function addIndent (buf:StringBuf, indent:Int, indentStr:String) {
    while (indent-- > 0) {
      buf.add(indentStr);
    }
  }
  
  static function exprStr1 (expr:Expr, buf:StringBuf, indent:Int, indentStr:String):StringBuf
	{
		#if scutsDebug
		if (expr == null || buf == null) throw "assert";
		#end
		
		var exprStr = function (expr) return exprStr1(expr, buf, indent, indentStr);
	  
		
		var constStr = function (c) return constStr1(c, buf);
		var binopStr = function (op) return binopStr1(op, buf);
		var unopStr = function (op) return unopStr1(op, buf, indent, indentStr);
		var newLine = function () return newLine(buf, indent, indentStr);

		var newLineInc = function () {
		  ++indent;
		  return newLine();
		}
		var newLineDec = function () {
		  --indent;
		  return newLine();
		}
		
		var add = function (str) { buf.add(str); return buf;} 
		
		return switch(expr.expr) {
		  case EConst( c ):
        buf = constStr(c);
		  case EArray( e1, e2): 
        buf = exprStr(e1);
        buf = add("[");
        buf = exprStr(e2);
        buf = add("]");
        //throw "not implemented (e1:" + e1 + ", e2:" + e2 + ")";
		  case EBinop( op, e1, e2 ):
        buf = exprStr(e1);
        buf = binopStr(op);
        buf = exprStr(e2);
		  case EField( e, field): 
        buf = exprStr(e);
        buf = add(".");
        buf = add(field);
		  case EType( e, field): 
        buf = exprStr(e);
        buf = add(".");
        buf = add(field);
        // todo check this
		  case EParenthesis( e ): 
        buf = add("(");
        buf = exprStr(e);
        buf = add(")");
		  case EObjectDecl( fields ):
        buf = add("{");
        buf = newLineInc();
        
        for (i in 0...fields.length) 
        {
          var f = fields[i];
          if (i != 0) {
            buf = add(",");
          }
          buf = add(f.field);
          buf = add(":");
          buf = exprStr(f.expr);
          
        }
        buf = newLineDec();
        buf = buf = add("}");
		  case EArrayDecl( values ):
        buf = add("[");
        for (i in 0...values.length) 
          {
            buf = if (i == 0) buf else add(",");
            buf = exprStr(values[i]);
          }
        buf = add("]");
		  case ECall( e, params ):
        buf = exprStr(e);
        buf = add("(");
        
        for (i in 0...params.length) 
          {
            buf = if (i == 0) buf else add(", ");
            buf = exprStr(params[i]);
          }
        buf = add(")");
        buf;
		  case ENew( t, params ):
			
        buf = add("new ");
        buf = typePathStr1(t, buf, indent, indentStr);
        buf = add("(");
        for (i in 0...params.length) {
          buf = if (i == 0) buf else add(", ");
          buf = exprStr(params[i]);
        }
        buf = add(")");
			
			
		  case EUnop( op , postFix, e ):
        buf = if (!postFix) unopStr(op) else buf;
        buf = exprStr(e);
        buf = if (postFix) unopStr(op) else buf;
		  case EVars( vars ):
        buf = add("var ");
        for (i in 0...vars.length) 
          {
            var v = vars[i];
            buf = if (i == 0) buf else add(", ");
            buf = add(v.name);
            if (v.type != null) 
            {
              buf = add(":");
              
              buf = complexTypeStr1(v.type, buf, indent, indentStr);
            }
            
            if (v.expr != null) 
            {
              
              buf = add(" = ");
              buf = exprStr(v.expr);
            }
          }
        buf;
		  case EFunction( name, f):
			  buf = functionStr1(f, buf, indent, indentStr, name);
        
		  case EBlock( exprs ):
        if (exprs.length == 0) {
          add("{}");
        } else {
          buf = add("{");
          newLineInc();
          var first = true;
          for (e in exprs) 
          {
            if (first) first = false else newLine();
            if (e == null) throw "assert";
            buf = exprStr(e);
            buf = add(";");
            
          }
          newLineDec();
          buf = add("}");
        }
		  case EFor( eIn, expr ):
        buf = add("for (");
		buf = exprStr(eIn);
        
		
        buf = add(") ");
        buf = exprStr(expr);
	      case EIn(v, it):
			buf = exprStr(v);
			buf = add(" in ");
			buf = exprStr(it);  
		  
		  case EIf( econd, eif, eelse ):
        buf = add("if (");
        buf = exprStr(econd);
        buf = add(") ");
        buf = exprStr(eif);
        if (eelse != null) 
        {
          buf = add(" else ");
          buf = exprStr(eelse);
        }
        buf;
		  case EWhile( econd, e, normalWhile ):
        if (normalWhile) 
          {
            buf = add("while (");
            buf = exprStr(econd);
            buf = add(")");
          } 
        else
          buf = add("do");
        
        buf = add(" ");
        buf = exprStr(e);
        
        if (!normalWhile) 
          {
            buf = add(" while (");
            buf = exprStr(econd);
            buf = add(")");
          }
        buf;
			
		  case ESwitch( e, cases, edef ):
        // switch expr is by default EParenthesis, so we don't need to print them
        buf = add("switch ");
        buf = exprStr(e);
        buf = add(" {");
        newLineInc();
        for (i in 0...cases.length) 
        {
          var c = cases[i];
          if (i > 0) newLine();
          buf = add("case ");
          for (i in 0...c.values.length) 
            {
              buf = if (i == 0) buf else add(",");
              buf = exprStr(c.values[i]);
            }
          buf = add(":");
          
          // case expression is always a block, but we don't need to print the outer parenthesis in this case
          var allExprs = switch (c.expr.expr) {
            case EBlock(exprs): exprs;
            default: throw "assert";
          }
          if (allExprs.length > 0) newLineInc();
          for (e in allExprs) {
            buf = exprStr(e);
            buf = add(";");
          }
          if (allExprs.length > 0) indent--;
          //newLineDec();
        }
        if (edef != null) {
          if (cases.length > 0) newLine();
          buf = add("default:");
          var allExprs = switch (edef.expr) {
            case EBlock(exprs): exprs;
            default: throw "assert";
          }
          if (allExprs.length > 0) newLineInc();
          for (e in allExprs) {
            buf = exprStr(e);
            buf = add(";");
          }
        }
        indent--;
        newLineDec();
        buf = add("}");
		  case ETry( e, catches ):
        buf = add("try ");
        buf = exprStr(e);
        buf = add(" ");
        var first = true;
        for (c in catches) {
          buf = if (first) { first = false; buf; } else add(" ");
          buf = add("catch (");
          buf = add(c.name);
          buf = add(":");
          buf = complexTypeStr1(c.type, buf, indent, indentStr);
          buf = add(") ");
          buf = exprStr(c.expr);
        }
        buf;
        
        
		  case EReturn( e ):
        buf = add("return");
        if (e != null) {
          buf = add(" ");
          buf = exprStr(e);
        }
        buf;
		  case EBreak:
        buf = add("break");
		  case EContinue:
        buf = add("continue");
		  case EUntyped( e ):
        buf = add("untyped ");
        buf = exprStr(e);
		  case EThrow( e ):
        buf = add("throw ");
        buf = exprStr(e);
		  case ECast( e, t  ):
        if (t == null) {
          buf = add("cast ");
          buf = exprStr(e);
        } else {
          buf = add("cast(");
          buf = exprStr(e);
          buf = add(", ");
          buf = complexTypeStr1(t, buf, indent, indentStr);
          buf = add(")");
        }
		  case EDisplay( e, isCall ):
			  buf;
			//throw "not implemented yet";
		  case EDisplayNew( t ):
			  buf;
        //throw "not implemented yet";
		  case ETernary( econd, eif, eelse ):
			
        buf = exprStr(econd);
        buf = add(" ? ");
        buf = exprStr(eif);
        buf = add(" : ");
        buf = exprStr(eelse);
      case ECheckType(e, t):
        // TODO what is this exactly
        exprStr(e);
    }
  }
  
  
  
  static function unopStr1 (op:Unop, buf:StringBuf, indent:Int, indentStr:String):StringBuf 
  {
    #if scutsDebug
    if (buf == null || op == null) throw "assert";
    #end
    
    var add = function (str) { buf.add(str); return buf;}
    
    return switch (op) {
      case OpIncrement:   add("++");
      case OpDecrement:   add("--");
      case OpNot:      add("!");
      case OpNeg:      add("-");
      case OpNegBits:    add("~");
    }
  }
  
  /*
   *  enum ComplexType {
        TPath( p : TypePath );
        TFunction( args : Array<ComplexType>, ret : ComplexType );
        TAnonymous( fields : Array<Field> );
        TParent( t : ComplexType );
        TExtend( p : TypePath, fields : Array<Field> );
      }
  */
  static function complexTypeStr1 (c:ComplexType, buf:StringBuf, indent:Int, indentStr:String, ?cl:Array<TypeParam>):StringBuf
  {
    var add = function (str) { buf.add(str); return buf; }
    
    return switch (c) {
      case TPath( p ): 
        //trace("---------");
        var typeParams = if (cl != null) cl else [];
        
        var params = new Hash();
        for (tp in typeParams) {
          switch (tp) {
            case TypeParam.TPExpr(e):
            case TypeParam.TPType(ct):
              switch(ct) {
                case TPath(p):
                  
                  params.set(p.name + "." + p.sub, true);
                default:
                   trace(ct);
              }
          }
        }
        
        var str = {
          var module = p.pack.join(".") + (p.pack.length > 0 ? "." : "") + p.name;
          var name = if (p.sub == null) {
            p.name;
          }else {
            //trace("we have a sub: " + p.sub);
            if (p.sub != p.name) p.sub else p.name;
          }
          //var typeExists = SType.getTypeFromModule(module, name) != null;
          
          p.pack.join(".") + (p.pack.length > 0 ? "." : "") + p.name + ((p.sub == null || p.sub == p.name) ? "" : "." + p.sub);
        }
        
       
        buf = add(str);
            

        typeParamValuesStr1(p.params, buf, indent, indentStr, p.params);
        
      case TFunction( args , ret ):
        buf = 
          if (args.length == 0) 
            {
              buf = add("Void");
            } 
          else 
            {
              for (a in args) 
                {
                  buf = complexTypeStr1(a, buf, indent, indentStr);
                  buf = add("->");
                }
              buf;
            }
        complexTypeStr1(ret, buf, indent, indentStr);
      case TAnonymous( fields ):
        buf = add("{");
        for (f in fields) 
          {
            
            buf = fieldStr1(f, buf, indent, indentStr);
            
          }
        add("}");
        
      case TParent( t ):
        // todo TParent, What is this?
        throw "ERROR TParent not implemented";
      case TExtend( p, fields ):
        buf = add("{");
        buf = add(">");
        typePathStr1(p, buf, indent, indentStr);
        for (f in fields) {
          buf = fieldStr1(f, buf, indent, indentStr);
          
        }
        add("}");
       case TOptional(t):
         buf.add("?");
         complexTypeStr1(c, buf, indent, indentStr, cl);
    }
  }
  
  static private function typePathStr1(tp:TypePath, buf:StringBuf, indent:Int, indentStr:String):StringBuf 
    {
      var add = function (str) { buf.add(str); return buf; }
      buf = add(tp.pack.join("."));
      buf = add((tp.pack.length > 0 ? "." : ""));
      buf = add(tp.name);
      buf = add(tp.sub == null ? "" : "." + tp.sub);
      return typeParamValuesStr1(tp.params, buf, indent, indentStr, tp.params);
    }
  
  static private function accessStr1 (a:Access, buf:StringBuf):StringBuf
  {
    var add = function (str) { buf.add(str); return buf; }
    return switch (a) 
      {
        case APublic: add("public ");
        case APrivate: add("private ");
        case AStatic: add("static ");
        case AOverride: add("override ");
        case ADynamic: add("dynamic ");
        case AInline: add("inline ");
      }
  }
  
  static private function fieldStr1(f:Field, buf:StringBuf, indent:Int, indentStr:String):StringBuf 
    {
      var add = function (str) { buf.add(str); return buf; }
      
      
      
      for (a in f.access) 
        {
          buf = accessStr1(a, buf);
        }
      
      
      return switch (f.kind) 
        {
          case FVar( t , e  ):
            buf = add("var ");
            buf = add(f.name);
            if (t != null) 
            {
              buf = add(":");
              buf = complexTypeStr1(t, buf, indent, indentStr);
            }
            if (e != null) 
            {
              buf = add(":");
              exprStr1(e, buf, 0, indentStr);
            }
            buf = add(";");
            buf;
          case FFun( fn ):
            
            functionStr1(fn, buf, indent, indentStr, f.name);
            buf = add(";");
          case FProp( get , set , t, pExpr ):
            buf = add("var ");
            buf = add(f.name);
            buf = add("(");
            buf = add(get);
            buf = add(",");
            buf = add(set);
            buf = add(")");
            buf = add(":");
            complexTypeStr1(t, buf, indent, indentStr);
            if (pExpr != null) {
              buf = add("=");
              buf = exprStr1(pExpr, buf, 0, indentStr);
            }
            buf = add(";");
        }
    }
    
  static private function functionStr1(f:Function, buf:StringBuf, indent:Int, indentStr:String, ?functionName:String = "", ?onlySignature:Bool = false):StringBuf 
    {
      var add = function (str) { buf.add(str); return buf; }
      
      buf = add("function ");
      buf = add(functionName);
      buf = add(functionName != "" ? " " : "");
      typeParamsStr1(f.params, buf, indent, indentStr);
      buf = add("(");
      
      var first = true;
      for (a in f.args) 
        {
          buf = if (first) { first = false; buf; } else add(", ");
          buf = if (a.opt) add("?") else buf;
          buf = add(a.name);
          buf = 
            if (a.type != null) 
              {
                
                buf = add(":");
                complexTypeStr1(a.type, buf, indent, indentStr);
              }
            else 
              buf;
          buf = 
            if (a.value != null) 
              {
                buf = add(" = ");
                buf = exprStr1(a.value, buf, 0, indentStr);
              }
            else 
              buf;
        }
      buf = add(")");
      
      buf = if (f.ret != null) { buf = add(":"); complexTypeStr1(f.ret, buf, indent, indentStr);} else buf;
      
      return if (!onlySignature && f.expr != null) { add(" "); exprStr1(f.expr, buf, 0, indentStr); } else buf;
      
    }
    
  static private function typeParamsStr1(params:Array<{ name : String, constraints : Array<ComplexType> }>, buf:StringBuf, indent:Int, indentStr:String):StringBuf 
    {
      var add = function (str) { buf.add(str); return buf; }
      
      return 
        if (params.length > 0) 
          {
            buf = add("<");
            var first = true;
            for (p in params) 
              {
                buf = if (first) { first = false; buf; } else add(",");
                buf = add(p.name);
                typeParamConstraintsStr1(p.constraints, buf, indent, indentStr);
              }
            buf = add("> ");
          }
        else 
          buf;
    }
    
  static private function typeParamConstraintsStr1(contraints:Array<ComplexType>,  buf:StringBuf, indent:Int, indentStr:String):StringBuf
    {
      var add = function (str) { buf.add(str); return buf; }
      
      return 
        if (contraints.length > 0) 
          {
            buf = add(":");
            buf = if (contraints.length > 1) add("(") else buf;
            var first = true;
            for (c in contraints) 
              {
                buf = if (first) { first = false; buf; } else add(",");
                buf = complexTypeStr1(c, buf, indent, indentStr);
              }
            buf = if (contraints.length > 1) add(")") else buf;
          }
        else
          buf;
    }
  
    
  static private function varAccessStr1 (access:VarAccess, buf:StringBuf):StringBuf 
    {
      var add = function (str) { buf.add(str); return buf; }
      
      return switch (access) {
        case AccNormal: add("default");
        case AccNo: add("null");
        case AccNever: add("never");
        case AccResolve: add("dynamic");
        case AccCall( m  ): add(m);
        case AccInline: buf; // should be resolved through access modifiers
        case AccRequire( r): buf; // TODO what is this
      }
    }
    
  /**
   * APublic;
	APrivate;
	AStatic;
	AOverride;
	ADynamic;
	AInline;
   
   */
  
    
    
  /*
  enum TypeParam {
    TPType( t : ComplexType );
    TPConst( c : Constant );
  }
  */
  
  static function typeParamValueStr1(typeParam:TypeParam, buf:StringBuf, indent:Int, indentStr:String, cl:Array<TypeParam>):StringBuf 
  {
    
    switch (typeParam) 
      {
        case TPType(ct): 
          buf = complexTypeStr1(ct, buf, indent, indentStr, cl);
        //case TPConst(c):
        //  buf = constantStr1(c, buf);
		case TPExpr(e):
			buf = exprStr1(e, buf, indent, indentStr);
      }
    return buf;
  }
  
  static function constantStr1 (c:Constant, buf:StringBuf):StringBuf
  {
    var add = function (str) { buf.add(str); return buf; }
    
    return switch (c) 
      {
        case CInt( v ): 
          add(v);
        case CFloat( f ):
          add(f);
        case CString( s ):
          add('"' + s + '"');
        case CIdent( s ):
          add(s);
        case CType( s ):
          add(s);
        case CRegexp( r , opt ):
          add("~/" + r + "/" + opt);
      }
  }
  
  static function typeParamValuesStr1(typeParams:Array<TypeParam>, buf:StringBuf, indent:Int, indentStr:String, cl:Array<TypeParam>):StringBuf 
  {
    var add = function (str) { buf.add(str); return buf; }
    
    return 
      if (typeParams.length > 0) 
        {
          buf = add("<");
          var first = true;
          for (tp in typeParams) 
            {
              buf = if (first) { first = false; buf; } else add(", ");
              buf = typeParamValueStr1(tp, buf, indent, indentStr, cl);
            }
          buf = add(">");
        }
      else 
        buf;
  }
  
  /**
   * enum Type {
        TMono;
        TEnum( t : Ref<EnumType>, params : Array<Type> );
        TInst( t : Ref<ClassType>, params : Array<Type> );
        TType( t : Ref<DefType>, params : Array<Type> );
        TFun( args : Array<{ name : String, opt : Bool, t : Type }>, ret : Type );
        TAnonymous( a : Ref<AnonType> );
        TDynamic( t : Null<Type> );
     }
   * 
   */
    /*
  static function typeStr1 (type:Type, buf:StringBuf):StringBuf {
    
    var add = function (str) { buf.add(str); return buf; }
    
    switch (t) {
      case TMono:
        add(
      case TEnum( t, params):
      case TInst( t, params ):
      case TType( t , params ):
      case TFun( args , ret ):
      case TAnonymous( a  ):
      case TDynamic( t  ):
    }
  }
  */
  
  static function binopStr1 (op:Binop, buf:StringBuf, surroundSpaces:Bool = true ):StringBuf 
  {
    #if scutsDebug
    if (buf == null || op == null) throw "assert";
    #end
    
    var add = function (str) { buf.add(if (surroundSpaces) " " + str + " " else str); return buf;}
    
    return switch (op) {
      case OpAdd:   add("+");
      case OpMult:   add("*");
      case OpDiv:   add("/");
      case OpSub:   add("-");
      case OpAssign:   add("=");
      case OpEq:     add("==");
      case OpNotEq:   add("!=");
      case OpGt:     add(">");
      case OpGte:   add(">=");
      case OpLt:     add("<");
      case OpLte:   add("<=");
      case OpAnd:   add("&");
      case OpOr:    add("|");
      case OpXor:   add("^");
      case OpBoolAnd: add("&&");
      case OpBoolOr:   add("||");
      case OpShl:   add("<<");
      case OpShr:   add(">>");
      case OpUShr:   add(">>>");
      case OpMod:   add("%");
      case OpAssignOp(op): 
              if (surroundSpaces) buf.add(" ");
              buf = binopStr1(op, buf, false);
              buf.add("="); 
              if (surroundSpaces) buf.add(" ");
              buf;
      case OpInterval: add("...");
    }
  }
  
  
  static function constStr1 (c:Constant, buf:StringBuf):StringBuf 
  {
    #if scutsDebug
    if (buf == null || c == null) throw "assert";
    #end
    
    var add = function (str) { buf.add(str); return buf; }
    
    return switch(c) {
      case CInt( v ): add(v);
      case CFloat( f ): add(f);
      case CString( s ): add('"' + s + '"');
      case CIdent( s ): add(s);
      case CType( s ): add(s);
      case CRegexp( r , opt ): add("~/" + r + "/" + opt);
    }
  }
  
  /* ######################## from TypePrinter ####################### */
  public static function typeStr (t:Type, ?simpleFunctionSignatures:Bool = false, ?typeParam:BaseType = null) {
		var isTypeParam = typeParam != null;
		var paramsHash = new Hash();
		if (typeParam != null) {
		for (tp in typeParam.params) {
			paramsHash.set(tp.name, tp.t);
		}
		//trace(paramsHash);
		}
		var str = switch (t) {
      case TLazy(f):
        "TLazy";
			case TMono(t): 
				"Unknown";
					
			case TEnum( t, params ): 
				var s = t.get().module + "." + t.get().name + 
				    if (params.length > 0) { 
              
              var paramsReduced = ( "<" + 
                params.reduceRight(
                  function (v, a) {
                    var res = typeStr(v, t.get()) + "," + a;
                    
                    return res;
                  }, function (v) return typeStr(v, t.get())
                )
                + ">"
              );
              paramsReduced;
            } else "";
        s;
			case TInst( t, params ): 

				//var isTypeP = paramsHash.exists(tName);
				var realType = SType.getTypeFromModule(t.get().module, t.get().name) != null;
        //trace("REALTYPE : " + realType + " for " + 
				var tName = if (realType) {
          var moduleName = if (t.get().pack.length > 0) t.get().module.substr(t.get().pack.join(".").length + 1) else t.get().module;
          if (moduleName == t.get().name) {
            t.get().module;
          } else {
            //trace("real type: " + t.get().module + "." + t.get().name);
            t.get().module + "." + t.get().name;
          }
        } else {
          t.get().name;
        }
				var pack = t.get().pack.copy();
				if (realType) pack = [];
        
        var foldPack = function (v, a) return v + "." + a;
        var reduceParams = function (v, a) return "," + typeStr(v, t.get()) + a;
        var reduceFirst = function (v) return typeStr(v, t.get());
				var res = 
          pack.foldRight(foldPack, tName) + 
      		if (params.length > 0) 
            "<" + params.reduceRight(reduceParams, reduceFirst) + ">";
          else "";
        
        if (tName == "T") {
          
          trace("----------------------");
          trace("HAVE TINST " + res + " - tName " + tName);
          trace("MODULE: " + t.get().module);
          trace("----------------------");
          
        }
        res;
			case TType( t , params ): 
        
        var foldPack = function (v, a) return v + "." + a;
        var foldParams = function (v, a,i) return typeStr(v, t.get()) + (if (i > 0) "," else "") + a;
				
        
        var typeStr = t.get().pack.foldRight(foldPack, t.get().name);
        var paramsStr = if (params.length > 0) "<" + params.foldRightWithIndex(foldParams, ">") else "";
       
        var res = typeStr + paramsStr;
        res;
			case TFun( args , ret ):
        
        var reduceArgs = function (acc, val) {
          return acc + " -> " + funArgStr(val, simpleFunctionSignatures);
        }
        var reduceFirst = function (val) {
          return funArgStr(val, simpleFunctionSignatures);
        }
        
        var argumentsStr = 
          if (args.length == 0) "Void" 
          else args.reduceLeft(reduceArgs, reduceFirst);
        
				var returnTypeStr = typeStr(ret);
        argumentsStr + " -> " + returnTypeStr;
			
      case TAnonymous( a ): 
        var reduceFields = function (acc, val) 
          return acc + ", " + anonFieldStr(val);
        
        var reduceFirst = function (val) 
          return anonFieldStr(val);
        
				"{ " + a.get().fields.reduceLeft(reduceFields, reduceFirst) + " }";
			case TDynamic( t ): 
        if (t != null) "Dynamic<" + typeStr(t) + ">" else "Dynamic";
		}
		return str;
	}
	
	public static function anonFieldStr (c:ClassField):String {
		return c.name + " : " + typeStr(c.type);
	}
	
	public static function funArgStr (arg:{ name : String, opt : Bool, t : Type }, simpleFunctionSignatures:Bool):String {
		return (if (arg.opt && !simpleFunctionSignatures) "?" else "") + 
		  (if (arg.name != null && !simpleFunctionSignatures) arg.name + (if (arg.t != null) " : " else "") else "") + 
		  (if (arg.t != null) typeStr(arg.t) else "");
	}
	
}

#end