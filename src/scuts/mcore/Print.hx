package scuts.mcore;


#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)

using scuts.core.extensions.ArrayExt;
using scuts.core.extensions.IterableExt;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Binop;
import haxe.macro.Type;
import scuts.Scuts;


private typedef SType = scuts.mcore.Type;

private typedef P = Print;
class Print 
{

  //{ region public
  public static function unop (op:Unop, indent:Int = 0, indentStr = "\t"):String
  {
    return unop1(op, new StringBuf(), indent, indentStr).toString();
  }
  
  public static function expr (ex:Expr, indent:Int = 0, indentStr = "\t"):String 
  {
    var buf = new StringBuf();
    addIndent(buf, indent, indentStr);
    return expr1(ex, buf, indent, indentStr).toString();
  }
  
  public static function binop(op:Binop):String 
  {
    return binop1(op, new StringBuf()).toString();
  }
  
  public static function const (c:Constant):String 
  {
    return const1(c, new StringBuf()).toString();
  }
    
  public static function typeParamValue (typeParam:TypeParam, ?cl:Array<TypeParam>, indent:Int = 0, indentStr = "\t"):String 
  {
    return typeParamValue1(typeParam, new StringBuf(), indent, indentStr, cl).toString();
  }
  
  public static function typeParamValues (typeParams:Array<TypeParam>, ?cl:Array<TypeParam>, indent:Int = 0, indentStr = "\t"):String 
  {
    return typeParamValues1(typeParams, new StringBuf(), indent, indentStr, cl).toString();
  }
  
  public static function complexType (c:ComplexType, indent:Int = 0, indentStr:String = "\t"):String
  {
    return complexType1(c, new StringBuf(), indent, indentStr).toString();
  }
    
  public static function func(f:Function, functionName:String = "", indent:Int = 0, indentStr:String = "\t"):String
  {
    return func1(f, new StringBuf(), indent, indentStr, functionName).toString();
  }
  
  public static function field(f:Field, indent:Int = 0, indentStr:String = "\t"):String
  {
    return field1(f, new StringBuf(), indent, indentStr).toString();
  }
  
  public static function functionSignature(f:Function, ?functionName:String = "", indent:Int = 0, indentStr:String = "\t"):StringBuf 
  {
    return func1(f, new StringBuf(), indent, indentStr, functionName, true);
  }

  //} region public
  
  
  
  
  //{ region private
  static function newLine (buf:StringBuf, indent:Int,indentStr:String) 
  {
    buf.add("\n");
    addIndent(buf, indent, indentStr);
    return buf;
  }
  
  static function addIndent (buf:StringBuf, indent:Int, indentStr:String) {
    while (indent-- > 0) {
      buf.add(indentStr);
    }
    return buf;
  }
  
  static function expr1 (ex:Expr, buf:StringBuf, indent:Int, indentStr:String):StringBuf
  {
    #if scutsDebug
    if (ex == null || buf == null) throw "assert";
    #end
    
    var expr = function (ex) return expr1(ex, buf, indent, indentStr);
    
    
    var const = function (c) return const1(c, buf);
    var binop = function (op) return binop1(op, buf);
    var unop = function (op) return unop1(op, buf, indent, indentStr);
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
    
    return switch(ex.expr) {
      case EConst( c ):
        const(c);
      case EArray( e1, e2): 
        expr(e1);
        add("[");
        expr(e2);
        add("]");
      case EBinop( op, e1, e2 ):
        expr(e1);
        binop(op);
        expr(e2);
      case EField( e, field): 
        expr(e);
        add(".");
        add(field);
      case EType( e, field): 
        expr(e);
        add(".");
        add(field);
      case EParenthesis( e ): 
        add("(");
        expr(e);
        add(")");
      case EObjectDecl( fields ):
        add("{");
        newLineInc();
        for (i in 0...fields.length) 
        {
          var f = fields[i];
          if (i != 0) add(",");
          add(f.field);
          add(":");
          expr(f.expr);
        }
        newLineDec();
        add("}");
      case EArrayDecl( values ):
        add("[");
        for (i in 0...values.length) 
        {
          if (i != 0) add(",");
          expr(values[i]);
        }
        add("]");
      case ECall( e, params ):
        expr(e);
        add("(");
        for (i in 0...params.length) 
        {
          if (i != 0) add(", ");
          expr(params[i]);
        }
        add(")");
      case ENew( t, params ):
        add("new ");
        typePathStr1(t, buf, indent, indentStr);
        add("(");
        for (i in 0...params.length) 
        {
          if (i != 0) add(", ");
          expr(params[i]);
        }
        add(")");
      case EUnop( op , postFix, e ):
        if (!postFix) unop(op);
        expr(e);
        if (postFix) unop(op);
        buf;
      case EVars( vars ):
        add("var ");
        for (i in 0...vars.length) 
        {
          var v = vars[i];
          if (i != 0) add(", ");
          add(v.name);
          if (v.type != null) 
          {
            add(":");
            complexType1(v.type, buf, indent, indentStr);
          }
          if (v.expr != null) 
          {
            add(" = ");
            expr(v.expr);
          }
        }
        buf;
      case EFunction( name, f):
        func1(f, buf, indent, indentStr, name);
        
      case EBlock( exprs ):
        if (exprs.length == 0) 
        {
          add("{}");
        } 
        else 
        {
          add("{");
          newLineInc();
          var first = true;
          for (e in exprs) 
          {
            if (first) first = false else newLine();
            if (e == null) throw "assert";
            expr(e);
            add(";");
            
          }
          newLineDec();
          add("}");
        }
      case EFor( eIn, ex ):
        add("for (");
        expr(eIn);
        add(") ");
        expr(ex);
      case EIn(v, it):
        expr(v);
        add(" in ");
        expr(it);  
      case EIf( econd, eif, eelse ):
        add("if (");
        expr(econd);
        add(") ");
        expr(eif);
        if (eelse != null) 
        {
          add(" else ");
          expr(eelse);
        }
        buf;
      case EWhile( econd, e, normalWhile ):
        if (normalWhile) 
        {
          add("while (");
          expr(econd);
          add(")");
        } 
        else add("do");
        
        add(" ");
        expr(e);
        
        if (!normalWhile) 
        {
          add(" while (");
          expr(econd);
          add(")");
        }
        buf;
      case ESwitch( e, cases, edef ):
        // switch expr is by default EParenthesis, so we don't need to print them
        add("switch ");
        expr(e);
        add(" {");
        newLineInc();
        for (i in 0...cases.length) 
        {
          var c = cases[i];
          if (i > 0) newLine();
          add("case ");
          for (i in 0...c.values.length) 
            {
              if (i != 0) add(",");
              expr(c.values[i]);
            }
          add(":");
          
          // case expression is always a block, but we don't need to print the outer parenthesis in this case
          var allExprs = switch (c.expr.expr) {
            case EBlock(exprs): exprs;
            default: throw "assert";
          }
          if (allExprs.length > 0) newLineInc();
          for (e in allExprs) {
            expr(e);
            add(";");
          }
          if (allExprs.length > 0) indent--;
        }
        if (edef != null) {
          if (cases.length > 0) newLine();
          add("default:");
          var allExprs = switch (edef.expr) {
            case EBlock(exprs): exprs;
            default: throw "assert";
          }
          if (allExprs.length > 0) newLineInc();
          for (e in allExprs) {
            expr(e);
            add(";");
          }
        }
        indent--;
        newLineDec();
        add("}");
      case ETry( e, catches ):
        add("try ");
        expr(e);
        add(" ");
        var first = true;
        for (c in catches) {
          if (first) { first = false; } else add(" ");
          add("catch (");
          add(c.name);
          add(":");
          complexType1(c.type, buf, indent, indentStr);
          add(") ");
          expr(c.expr);
        }
        buf;

      case EReturn( e ):
        add("return");
        if (e != null) {
          add(" ");
          expr(e);
        }
        buf;
      case EBreak:
        add("break");
      case EContinue:
        add("continue");
      case EUntyped( e ):
        add("untyped ");
        expr(e);
      case EThrow( e ):
        add("throw ");
        expr(e);
      case ECast( e, t  ):
        if (t == null) {
          add("cast ");
          expr(e);
        } else {
          add("cast(");
          expr(e);
          add(", ");
          complexType1(t, buf, indent, indentStr);
          add(")");
        }
      case EDisplay( e, isCall ):
        buf;
        //throw "not implemented yet";
      case EDisplayNew( t ):
        
        //throw "not implemented yet";
        buf;
      case ETernary( econd, eif, eelse ):
      
        expr(econd);
        add(" ? ");
        expr(eif);
        add(" : ");
        expr(eelse);
      case ECheckType(e, t):
        // TODO what is this exactly
        expr(e);
    }
  }
  
  static function unop1 (op:Unop, buf:StringBuf, indent:Int, indentStr:String):StringBuf 
  {
    #if scutsDebug
    if (buf == null || op == null) throw "assert";
    #end
    
    var add = function (str) { buf.add(str); return buf;}
    
    return switch (op) {
      case OpIncrement: add("++");
      case OpDecrement: add("--");
      case OpNot:       add("!");
      case OpNeg:       add("-");
      case OpNegBits:   add("~");
    }
  }
  
  
  static function complexType1 (c:ComplexType, buf:StringBuf, indent:Int, indentStr:String, ?cl:Array<TypeParam>):StringBuf
  {
    var add = function (str) { buf.add(str); return buf; }
    
    return switch (c) 
    {
      case TPath( p ): 
        var typeParams = if (cl != null) cl else [];
        
        var params = new Hash();
        for (tp in typeParams) 
        {
          switch (tp) 
          {
            case TypeParam.TPExpr(e):
              Scuts.notImplemented();
            case TypeParam.TPType(ct):
              switch(ct) 
              {
                case TPath(p):
                  params.set(p.name + "." + p.sub, true);
                default:
                  Scuts.notImplemented();
              }
          }
        }
        
        var str = {
          var module = p.pack.join(".") + (p.pack.length > 0 ? "." : "") + p.name;
          var name = 
            if (p.sub == null) p.name
            else if (p.sub != p.name) p.sub else p.name;
            
          p.pack.join(".") + (p.pack.length > 0 ? "." : "") + p.name + ((p.sub == null || p.sub == p.name) ? "" : "." + p.sub);
        }
        add(str);
        typeParamValues1(p.params, buf, indent, indentStr, p.params);
      case TFunction( args , ret ):
        if (args.length == 0) add("Void")
        else 
          for (a in args) 
          {
            complexType1(a, buf, indent, indentStr);
            add("->");
          }
        complexType1(ret, buf, indent, indentStr);
      case TAnonymous( fields ):
        add("{");
        for (f in fields) field1(f, buf, indent, indentStr);
        add("}");
      case TParent( t ):
        add("(");
        complexType1(t, buf, indent, indentStr, cl);
        add(")");
      case TExtend( p, fields ):
        add("{");
        add(">");
        typePathStr1(p, buf, indent, indentStr);
        for (f in fields) {
          field1(f, buf, indent, indentStr);
        }
        add("}");
      case TOptional(t):
        buf.add("?");
        complexType1(c, buf, indent, indentStr, cl);
    }
  }
  
  static function typePathStr1(tp:TypePath, buf:StringBuf, indent:Int, indentStr:String):StringBuf 
  {
    var add = function (str) { buf.add(str); return buf; }
    add(tp.pack.join("."));
    add(tp.pack.length > 0 ? "." : "");
    add(tp.name);
    add(tp.sub == null ? "" : "." + tp.sub);
    return typeParamValues1(tp.params, buf, indent, indentStr, tp.params);
  }
  
  static function accessStr1 (a:Access, buf:StringBuf):StringBuf
  {
    var add = function (str) { buf.add(str); return buf; }
    return switch (a) 
    {
      case APublic:   add("public ");
      case APrivate:  add("private ");
      case AStatic:   add("static ");
      case AOverride: add("override ");
      case ADynamic:  add("dynamic ");
      case AInline:   add("inline ");
    }
  }
  
  static function field1(f:Field, buf:StringBuf, indent:Int, indentStr:String):StringBuf 
  {
    var add = function (str) { buf.add(str); return buf; }
    for (m in f.meta) 
    {
      buf.add("@");
      buf.add(m.name);
      
      var len = m.params.length;
      if (len > 0) 
      {
        buf.add("(");
        expr1(m.params[0], buf, indent, indentStr);
        for (i in 1...len) 
        {
          expr1(m.params[i], buf, indent, indentStr);
        }
        buf.add(")");
      }
      buf.add(" ");
    }
    
    for (a in f.access) 
    {
      accessStr1(a, buf);
    }
    
    switch (f.kind) 
    {
      case FVar( t , e  ):
        add("var ");
        add(f.name);
        if (t != null) 
        {
          add(":");
          complexType1(t, buf, indent, indentStr);
        }
        if (e != null) 
        {
          add(":");
          expr1(e, buf, 0, indentStr);
        }
        add(";");
      case FFun( fn ):
        func1(fn, buf, indent, indentStr, f.name);
        add(";");
      case FProp( get , set , t, pExpr ):
        add("var ");
        add(f.name);
        add("(");
        add(get);
        add(",");
        add(set);
        add(")");
        add(":");
        complexType1(t, buf, indent, indentStr);
        if (pExpr != null) {
          add("=");
          expr1(pExpr, buf, 0, indentStr);
        }
        add(";");
    }
    return buf;
  }
    
  static function func1(f:Function, buf:StringBuf, indent:Int, indentStr:String, ?functionName:String = "", ?onlySignature:Bool = false):StringBuf 
  {
    var add = function (str) { buf.add(str); return buf; }
    
    add("function ");
    add(functionName);
    add(functionName != "" ? " " : "");
    typeParamsStr1(f.params, buf, indent, indentStr);
    add("(");
    
    var first = true;
    for (a in f.args) 
    {
      if (first) first = false else add(", ");
      if (a.opt) add("?");
      add(a.name);
      
      if (a.type != null) 
      {
        add(":");
        complexType1(a.type, buf, indent, indentStr);
      }

      if (a.value != null) 
      {
        add(" = ");
        expr1(a.value, buf, 0, indentStr);
      }
    }
    add(")");
    
    if (f.ret != null) 
    { 
      add(":"); 
      complexType1(f.ret, buf, indent, indentStr);
    }
    
    if (!onlySignature && f.expr != null) 
    { 
      add(" "); 
      expr1(f.expr, buf, 0, indentStr); 
    }
    return buf;
    
  }
    
  static function typeParamsStr1(params:Array<{ name : String, constraints : Array<ComplexType> }>, buf:StringBuf, indent:Int, indentStr:String):StringBuf 
  {
    var add = function (str) { buf.add(str); return buf; }
    if (params.length > 0) 
    {
      add("<");
      var first = true;
      for (p in params) 
      {
        if (first) { first = false; } else add(",");
        add(p.name);
        typeParamConstraintsStr1(p.constraints, buf, indent, indentStr);
      }
      add("> ");
    }
    return buf;
  }
    
  static function typeParamConstraintsStr1(contraints:Array<ComplexType>,  buf:StringBuf, indent:Int, indentStr:String):StringBuf
  {
    var add = function (str) { buf.add(str); return buf; }

    if (contraints.length > 0) 
    {
      add(":");
      if (contraints.length > 1) add("(");
      var first = true;
      for (c in contraints) 
      {
        if (first) first = false else add(",");
        complexType1(c, buf, indent, indentStr);
      }
      if (contraints.length > 1) add(")");
    }
    
    return buf;
  }
  
    
  static function varAccessStr1 (access:VarAccess, buf:StringBuf):StringBuf 
  {
    var add = function (str) { buf.add(str); return buf; }
    
    switch (access) 
    {
      case AccNormal:       add("default");
      case AccNo:           add("null");
      case AccNever:        add("never");
      case AccResolve:      add("dynamic");
      case AccCall( m ):    add(m);
      case AccInline:       // should be resolved through access modifiers
      case AccRequire( r ): // TODO what is this
    }
    return buf;
  }
    
  static function typeParamValue1(typeParam:TypeParam, buf:StringBuf, indent:Int, indentStr:String, cl:Array<TypeParam>):StringBuf 
  {
    switch (typeParam) 
    {
      case TPType(ct): 
        complexType1(ct, buf, indent, indentStr, cl);
      case TPExpr(e):
        expr1(e, buf, indent, indentStr);
    }
    return buf;
  }
  
  static function constantStr1 (c:Constant, buf:StringBuf):StringBuf
  {
    var add = function (str) { buf.add(str); return buf; }
    return switch (c) 
    {
      case CInt( v ):          add(v);
      case CFloat( f ):        add(f);
      case CString( s ):       add('"' + s + '"');
      case CIdent( s ):        add(s);
      case CType( s ):         add(s);
      case CRegexp( r , opt ): add("~/" + r + "/" + opt);
    }
  }
  
  static function typeParamValues1(typeParams:Array<TypeParam>, buf:StringBuf, indent:Int, indentStr:String, cl:Array<TypeParam>):StringBuf 
  {
    var add = function (str) { buf.add(str); return buf; }
    
    if (typeParams.length > 0) 
    {
      add("<");
      var first = true;
      for (tp in typeParams) 
      {
        if (first) { first = false;} else add(", ");
        typeParamValue1(tp, buf, indent, indentStr, cl);
      }
      add(">");
    }
    return buf;
  }
  
  static function binop1 (op:Binop, buf:StringBuf, surroundSpaces:Bool = true ):StringBuf 
  {
    #if scutsDebug
    if (buf == null || op == null) throw "assert";
    #end
    
    var add = function (str) 
    { 
      buf.add(if (surroundSpaces) " " + str + " " else str); return buf;
    }
    
    return switch (op) {
      case OpAdd:      add("+");
      case OpMult:     add("*");
      case OpDiv:      add("/");
      case OpSub:      add("-");
      case OpAssign:   add("=");
      case OpEq:       add("==");
      case OpNotEq:    add("!=");
      case OpGt:       add(">");
      case OpGte:      add(">=");
      case OpLt:       add("<");
      case OpLte:      add("<=");
      case OpAnd:      add("&");
      case OpOr:       add("|");
      case OpXor:      add("^");
      case OpBoolAnd:  add("&&");
      case OpBoolOr:   add("||");
      case OpShl:      add("<<");
      case OpShr:      add(">>");
      case OpUShr:     add(">>>");
      case OpMod:      add("%");
      case OpInterval: add("...");
      case OpAssignOp(op): 
        if (surroundSpaces) buf.add(" ");
        binop1(op, buf, false);
        buf.add("="); 
        if (surroundSpaces) buf.add(" ");
        buf;
    }
  }
  
  
  static function const1 (c:Constant, buf:StringBuf):StringBuf 
  {
    #if scutsDebug
    if (buf == null || c == null) throw "assert";
    #end
    
    var add = function (str) { buf.add(str); return buf; }
    
    return switch(c) {
      case CInt( v ):          add(v);
      case CFloat( f ):        add(f);
      case CString( s ):       add('"' + s + '"');
      case CIdent( s ):        add(s);
      case CType( s ):         add(s);
      case CRegexp( r , opt ): add("~/" + r + "/" + opt);
    }
  }
  
  public static function type (t:Type, ?simpleFunctionSignatures:Bool = false, ?typeParam:BaseType = null) {
    return type1(t, simpleFunctionSignatures, typeParam);
  }
  
  public static function type1 (t:Type, ?simpleFunctionSignatures:Bool = false, ?typeParam:BaseType = null):String
  {
    var isTypeParam = typeParam != null;
    var paramsHash = new Hash();
    if (typeParam != null) 
    {
      for (tp in typeParam.params) 
      {
        paramsHash.set(tp.name, tp.t);
      }
    }
    var str = switch (t) {
      case TLazy(f):
        "TLazy";
      case TMono(t): 
        "Unknown";
          
      case TEnum( t, params ): 
        var paramsReduced = 
          if (params.length > 0) 
          {
            var r = params.reduceRight(
              function (v, a) return P.type(v, t.get()) + "," + a,
              function (v) return P.type(v, t.get())
            );
            "<" + r + ">";
          }
          else "";
        t.get().module + "." + t.get().name + paramsReduced;
      case TInst( t, params ): 
        var ct = t.get();
        var module = ct.module;
        var pack = ct.pack;
        var name = ct.name;
        
        var realType = SType.getTypeFromModule(module, name) != null;
        var tName = 
          if (realType) 
          {
            var moduleName = 
              if (pack.length > 0) 
                module.substr(pack.join(".").length + 1) 
              else module;
            module + if (moduleName == name) "" else "." + name;
          }
          else name;
        var packCopy = if (realType) [] else pack;
        
        var foldPack = function (v, a) return v + "." + a;
        var reduceParams = function (v, a) return P.type(v, ct) + "," + a;
        var reduceFirst = function (v) return P.type(v, ct);
        var res = 
          packCopy.foldRight(foldPack, tName) 
          + if (params.length > 0) 
              "<" + params.reduceRight(reduceParams, reduceFirst) + ">";
            else "";
        res;
      case TType( t , params ): 
        
        var dt = t.get();
        
        var foldPack = function (v, a) return v + "." + a;
        var foldParams = function (v, a,i) return P.type(v, dt) + (if (i < params.length-1) "," else "") + a;
        
        var typeStr = dt.pack.foldRight(foldPack, dt.name);
        var paramsStr = if (params.length > 0) "<" + params.foldRightWithIndex(foldParams, ">") else "";
        
        typeStr + paramsStr;
      case TFun( args , ret ):
        
        var argumentsStr =
          if (args.length == 0) "Void" 
          else 
          {
            var reduceArgs = function (acc, val) return acc + " -> " + funArgStr(val, simpleFunctionSignatures);
            var reduceFirst = function (val) return funArgStr(val, simpleFunctionSignatures);
            args.reduceLeft(reduceArgs, reduceFirst);
          }
        argumentsStr + " -> " + P.type(ret);
      case TAnonymous( a ): 
        
        var fields = a.get().fields;
        var reduced = if (fields.length > 0) 
        {
          var reduceFields = function (acc, val) return acc + " " + anonFieldStr(val);
          var reduceFirst = function (val) return anonFieldStr(val);
          a.get().fields.reduceLeft(reduceFields, reduceFirst);
        } else "";
        
        "{ " + reduced + " }";
      case TDynamic( t ): 
        "Dynamic" + if (t != null) "<" + P.type(t) + ">" else "";
    }
    return str;
  }
  
  public static function anonFieldStr (c:ClassField):String 
  {
    return switch (c.kind) {
      case FMethod(k):
        switch (k) {
          case MethodKind.MethNormal:
            //"function " + c.name + "(" + args + "):" + ret;
            switch (c.type) {
              case TFun(args, ret): 
                var argStrings = args.map(function (a) return (a.opt ? "?" : "") + a.name + ":" + P.type(a.t));
                "function " + c.name + " (" + argStrings.join(",") + ")" + ":" + P.type(ret) + ";";
              default: Scuts.error("Assert");
            }
            
          default: Scuts.notImplemented();
        }
      case FieldKind.FVar(read, write):
        switch (read) {
          case VarAccess.AccNo: c.name + " : " + P.type(c.type) + ",";
          case VarAccess.AccNormal: "var " + c.name + " : " + P.type(c.type) + ";";
          default: Scuts.notImplemented();
        }
        
    }
    //return 
  }
  
  public static function funArgStr (arg:{ name : String, opt : Bool, t : Type }, simpleFunctionSignatures:Bool):String 
  {
    var optPrefix = if (arg.opt && !simpleFunctionSignatures) "?" else "";
    var argName = 
      if ((arg.name != null && arg.name != "") && !simpleFunctionSignatures) 
        arg.name 
        + if (arg.t != null && arg.name != null) " :   " 
          else ""
      else "";
    var argType = if (arg.t != null) P.type(arg.t) else "";
    
    return optPrefix + argName + argType;
  }
  
}

#end