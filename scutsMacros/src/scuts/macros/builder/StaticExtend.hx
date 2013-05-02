package scuts.macros.builder;

#if false

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import scuts.mcore.ast.BaseTypes;
import scuts.mcore.ast.ComplexTypes;
import scuts.mcore.ast.Types;
import scuts.mcore.Make;
import scuts.mcore.Print;
import scuts.Scuts;


using scuts.core.Arrays;

class StaticExtend 
{


  
  macro public static function extend(cl:String):Array<Field>
  {
    
    /*
    FVar( t : Null<ComplexType>, ?e : Null<Expr> );
	FFun( f : Function );
	FProp( get : String, set : String, ?t : Null<ComplexType>, ?e : Null<Expr> );
    */
    
    
    try {
      
    function getNewFields (ctype) {
      return switch (ctype) {
        case TLazy(x): 
          
          getNewFields(x());
        case TInst(c,_): 
        
          
          
          function toField (s:ClassField):Field {
            
            
            var newArgs = null;
            var newRet = null;
            var clExpr = null;
            var newParams = null;
            
            function withType (stype) {
            
            switch (stype) {
              case TLazy(f): withType(f());
              case TFun(args, ret):
                
                var pret = Print.type(ret);
                newRet = ComplexTypes.fromString(pret);
                newArgs = args.map(function (a):FunctionArg {
                  return {
                    name : a.name,
                    opt : a.opt,
                    type : ComplexTypes.fromString(Print.type(a.t))
                  }
                });
                
                clExpr = Make.returnExpr(Make.call(Make.field(Context.parse(cl, Context.currentPos()), s.name), 
                  newArgs.map(function (x) return Make.constIdent(x.name))));
                newParams = s.params.map(function (p):TypeParamDecl {
                  return {
                    name : p.name
                  }
                });
            
              default:
            }
            }
            withType(s.type);
            
            
            

            var fieldType =  switch (s.kind) {
            
              case FVar( _, _  ):
                Scuts.notImplemented();
              case FMethod( k ):
                switch (k) {
                  case MethodKind.MethNormal:
                    
                    FFun( {
                      args :   newArgs,
                      ret :    newRet,
                      expr :   clExpr,
                      params : newParams,
                    });
                  default:Scuts.notImplemented();
                }
            }
            
            
            return {
              name : s.name,
              doc : s.doc,
              access : [AStatic, AInline, APublic],
              kind : fieldType,
              pos : s.pos,
              meta : []
            }
            
            
          }
          
          var filtered = c.get().statics.get().filter(function (x) return x.isPublic && switch (x.kind) { case FMethod(_):true; default:false; } );
          filtered.map(toField);
        default:
          Scuts.unexpected();
      }
    }
      
    var newFields = getNewFields(Context.getType(cl));
    var fields = Context.getBuildFields();
    return fields.concat(newFields);
    
    } catch (e:Dynamic) {
      trace(e);
      return Scuts.error("bla");
    }
    
    
    
    
    
  }
  
}

#end