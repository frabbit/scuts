package scuts.mcore.extensions;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)
import haxe.macro.Type;
import haxe.macro.Expr;
import scuts.core.extensions.Arrays;
using scuts.core.extensions.Arrays;

class ComplexTypeExt 
{
  public static function eq (c1:ComplexType, c2:ComplexType):Bool {
    return switch (c1) {
      case TAnonymous(fields1):
        switch (c2) {
          case TAnonymous(fields2): Arrays.eq(fields1, fields2, FieldExt.eq);
          default: false;
        }
      case TExtend(p1, fields1):
        switch (c2) {
          case TExtend(p2, fields2): TypePathExt.eq(p1, p2) && Arrays.eq(fields1, fields2, FieldExt.eq);
          default: false;
        }
      case TFunction(args1, ret1):
        switch (c2) {
          case TFunction(args2, ret2):  Arrays.eq(args1, args2, ComplexTypeExt.eq) && ComplexTypeExt.eq(ret1, ret2);
          default: false;
        }
      case TOptional(t1): 
        switch (c2) {
          case TOptional(t2): eq(t1,t2);
          default: false;
        }
      case TParent(t1):
        switch (c2) {
          case TParent(t2): eq(t1,t2);
          default: false;
        }
      case TPath(p1):
        switch (c2) {
          case TPath(p2): TypePathExt.eq(p1,p2);
          default: false;
        }
    }
  }
  
  /*
  public static function substituteTypeParam(ct:ComplexType, what:ComplexType, with:ComplexType) 
  {
    var sub = substituteTypeParam;
    
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
        var newArgs = args.map(function (a) return ct(a, what, with));
        var newRet = ct(ret, what, with);
        TFunction(newArgs, newRet);
      case TOptional(t): TOptional(ct(t, what, with));
      case TParent(t):
        TParent(ct(t, what, with));
      case TPath(p):
        TPath(convTypePath(p));
    }
    
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
  */
}

#end