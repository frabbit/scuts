package ;

using scuts.core.extensions.Options;
using scuts.core.extensions.Arrays;


#if (macro || display)
import hots.macros.Box;
import scuts.core.types.Tup2;
import scuts.Scuts;



import scuts.mcore.extensions.Exprs;
import scuts.mcore.Extract;
import scuts.mcore.Select;
import scuts.mcore.Cast;
import scuts.mcore.MContext;
import hots.macros.Resolver;
import scuts.Assert;
import scuts.mcore.MType;
import hots.macros.utils.Utils;
import scuts.mcore.extensions.Types;

import scuts.mcore.Print;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using scuts.core.extensions.Iterators;


class UnderscoreInternal {
  //@:overload(function <A,B,C>(f:A->B->C, ?a:Dynamic, ?b:Dynamic):C {})
  
  
  

  
  public static function apply (f:ExprOf<Dynamic>, ?args:Array<Expr>):Expr
  {
    
    if (args == null) args = [];
    function error<T>():T return Scuts.macroError("unsupported expression", f.pos);
    function errorInline<T>():T return Scuts.macroError("Unsupported call, maybe the function where _ is called on is an inline function. This is not supported because of macro limitations.", f.pos);
    
    var contextClasses = if (args.length > 0) {
      
      switch (Extract.extractBinOpRightExpr(args[args.length - 1], function (b) return b == Binop.OpLte)) {
        case Some(e): 
          args.pop();
            Select.selectEArrayDeclValues(e)
              .map(function (x) {
                return x.map(function (e) return {
                  var type = MContext.typeof(e).getOrError("Context must be a constant Array of Expressions");
                  
                  return Tup2.create(type, e);
                });
              }).getOrElseConst([]);
        default: [];
      }
    } else {
      [];
    }
    //trace("here");
    
    //trace(f);
    
    
    var f = switch (f.expr) {
      case ECall(e, p):
        Assert.equals(p.length, 1, null);
        args.unshift(p[0]);
        //trace("its call, using applied, remove the call");
        switch (e.expr) {
          case EFunction(_, f1):
            switch (f1.expr.expr) {
              case EReturn(e3):
                switch (e3.expr) {
                  case EFunction(_, f2): 
                    switch (f2.expr.expr) {
                      case EReturn(e): 
                        switch (e.expr) {
                          case ECall(e1, _): 
                            try {
                              Context.typeof(e1);
                              e1;
                            } catch (e:Dynamic) {
                              errorInline();
                            }
                          default: error();
                            
                        }
                      default: error();
                    }
                  default: error();
                  
                }
              default: error();
            }
          default: error();
          
        }
      case EField(_):
        f;
      case EConst(c):
        switch (c) {
          case CIdent(i): 
            var type = Context.typeof(f);
            switch (type) {
              case TFun(args, ret):
                // TODO allow this in conjunction with type 
                Scuts.macroError("local functions are not supported yet, because of macro restrictions", f.pos);
                
              default:
                error();
            }
            error();
          default:
            error();
        }
      default:
        error();
    }
    
    var callField = switch (f.expr) {
      case EField(e, fieldName):
        var t = Context.typeof(e);
        
        switch (t) {
          case TInst(t1, p):
            { field: t1.get().fields.get().filter(function (f) return f.name == fieldName)[0], params : p}
            
            
          case TType(t1,p):
        
            switch (t1.get().type) {
              case TAnonymous(a):
                { field: a.get().fields.filter(function (f) return f.name == fieldName)[0], params : [] };
                
              default: Scuts.unexpected();
            }
          default: Scuts.unexpected();
        }
      
         
      default: Scuts.unexpected();
    }

    var funData = switch (callField.field.type) {
      case TFun(args, ret):
        { args: args, ret:ret };
      default:Scuts.unexpected();
    }
    
    //trace(funData.args);
    
    
    var solved = [];
    
    //trace(callField.field.params);
    var wildcards = callField.params.concat(callField.field.params.map(function (p) return p.t));
    
    var mapping = [];
    
    var newArgs = [];
    
    for (i in 0...funData.args.length) {
      var targetType = MContext.followAliases(Utils.remap(funData.args[i].t, mapping));
      if (args.length > i) {
        // we have a supplied argument
        var oldArgType = MContext.followAliases(Context.typeof(args[i]));
        
          
        
        var targetOfLevel = Utils.getOfLevel(targetType);
        var currentOfLevel = Utils.getOfLevel(oldArgType);

        
        var argType = (currentOfLevel...targetOfLevel).foldLeft(
          function (acc, _) {
            return switch (Box.boxTypeToOfType(acc)) {
              case Right(r):r;
              case Left(e): 
                trace(e); 
                error();
            }
          },
          oldArgType);
        

        
        /*
        var elemType = Utils.getOfElemType(targetType);
        var argType = elemType.map(function (x) {
          var elemType2 = Utils.getContainerElemType(oldArgType);
          var isOf = Utils.isOfType(oldArgType);
          return if (!isOf && elemType2.isSome()) {
            var newElem2 = Utils.getContainerElemType(oldArgType);
            
            return newElem2.map(function (y) {
              var container = Utils.replaceContainerElemType(oldArgType,Utils.hotsInType()).getOrError("Unexpected");
              return Utils.makeOfType(container, y);
            }).getOrError("Unexpected");
          } else {
            oldArgType;
          }
        }).getOrElseConst(oldArgType);
        */
        
        
        if (oldArgType != argType) {
          var t1 = MContext.getLocalTypeParameters(oldArgType);
          var t2 = MContext.getLocalMethodTypeParameters(oldArgType);
          
          newArgs.push(Cast.unsafeCastFromTo(args[i], oldArgType, argType, t1.concat(t2)));
        } else {
          newArgs.push(args[i]);
        }
        
        //trace(Print.type(argType));
        //trace(Print.type(targetType));
        //trace(wildcards);
        var curMapping = Utils.typeIsCompatibleTo(argType, targetType, wildcards);
        //trace(curMapping);
        if (curMapping.isSome()) {
          var rev = Utils.reverseMapping(curMapping.extract());
          
          mapping = mapping.concat(rev);
          //trace("isCOmpatible: " + mapping);
        
        } else {
          //newArgs.push(args[i]);
          //Scuts.error("Invalid argument: " + Print.type(argType) + " for " + Print.type(targetType));
        }
      } else {
        var elemType = Utils.getContainerElemType(targetType);
        
        
        
        
        var tc = elemType.map(function (x) {
          var x1 = Utils.remap(x, Utils.reverseMapping(mapping));
          
          x1 = switch (x1) {
            case TFun(args, ret):
              TFun(args.map(function (a) return { opt : a.opt, name : null, t: a.t } ), ret);
            default: x1;
          }
          
          
          var tc = Resolver.resolve(x1, targetType, contextClasses,0);
          
          /*
          trace("Search TC for TC-Type: " + Print.type(targetType) + " and inner type " + Print.type(x1));
          
          trace("Found: >>" + 
            (switch (tc) {
              case Right(e): Print.expr(e);
              case Left(e): "Noting - " + e;
            })
          + "<<");
          */
          return tc;
        });
        
        
        switch (tc) {
          case Some(v):
            switch (v) {
              case Left(c): Resolver.handleResolveError(c);
              case Right(tc): newArgs.push(tc);
            }
          case None: Scuts.unexpected();
        }
        
        
        
        //trace("here");
        //if (Utils.
      }
    }
    
    
    
    var m = Context.getLocalMethod();
    
    var s = Std.string(m);
    
    //trace(Context.typeof({ expr : EConst(CIdent(s)), pos :Context.currentPos()}));
    
    
    
    
    
    
    var r = { expr : ECall(f, newArgs), pos:Context.currentPos() };
    
    /*
    var oldReturnType = Context.typeof(r);
    var newReturnType = Utils.normalizeOfTypes(oldReturnType);
    
    
    
    var newR = if (newReturnType != oldReturnType) {
      var t1 = MContext.getLocalTypeParameters(oldReturnType);
      var t2 = MContext.getLocalMethodTypeParameters(newReturnType);
        
      Cast.unsafeCastFromTo(r, oldReturnType, newReturnType, t1.concat(t2));
      
    } else {
      r;
    }
    */
    #if scutsDebug
    trace(Print.expr(r));
    #end
    return r;

  }
}
#end