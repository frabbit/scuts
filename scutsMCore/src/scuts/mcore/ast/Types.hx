package scuts.mcore.ast;

#if macro

import haxe.macro.Context;
import haxe.macro.Type;
import scuts.core.Validations;
import scuts.mcore.Make;
import scuts.mcore.Parse;
import scuts.mcore.Print;

import scuts.Scuts;

import haxe.macro.Expr;



import scuts.core.Tuples;


using scuts.core.Nulls;

using scuts.core.Arrays;

using scuts.core.Strings;
using scuts.core.Bools;
using scuts.core.Functions;
using scuts.core.Options;


using scuts.mcore.ast.Types;

using scuts.mcore.ast.ClassTypes;
using scuts.mcore.ast.EnumTypes;
using scuts.mcore.ast.DefTypes;
using scuts.mcore.ast.AnonTypes;

enum InstType 
{
	ITRegular;
  ITFunctionParam;
  ITClassParam;
}

private typedef TFunArg = {t:Type, name:String, opt:Bool};

class Types 
{
  
 

  public static function isFunction (t:Type):Bool 
  {
    return switch (t) {
      case TFun(_,_): true;
      case _: false;
    }
  }
  
  public static function isMono (t:Type):Bool 
  {
    return switch (t) {
      case TMono(_): true;
      case _: false;
    }
  }
  
  public static function getInstType (c:ClassType):InstType
  {
    var pack = c.pack;
    var module = c.module;
    var packJoined = pack.join(".");
    
    return 
      if (packJoined == module)                  ITClassParam
      else if (module.indexOf(packJoined) == -1) ITFunctionParam
      else                                       ITRegular;
  }
  
  public static function eq(type1:Type, type2:Type):Bool 
  {
    var eqParams = Arrays.eq.bind(_,_,Types.eq);
    
    function funEq (args1, args2, ret1:Type, ret2:Type) 
    {
      function funArgEq(a1:TFunArg, a2:TFunArg) 
      {
        return a1.name.eq(a2.name) 
            && a1.opt.eq(a2.opt) 
            && a1.t.eq(a2.t);
      }
      return Arrays.eq(args1, args2, funArgEq) && ret1.eq(ret2);
    }
    
    
    return switch [type1, type2] 
    {
      case [TAnonymous(a1), TAnonymous(a2)]: a1.get().eq(a2.get()); 
      case [TInst(t1, params1), TInst(t2, params2)]: t1.get().eq(t2.get()) && eqParams(params1, params2); 
      case [TEnum(t1, params1), TEnum(t2, params2)]: t1.get().eq(t2.get()) && eqParams(params1, params2); 
      case [TType(t1, params1),TType(t2, params2)]: t1.get().eq(t2.get()) && eqParams(params1, params2); 
      case [TDynamic(t1),TDynamic(t2)]: t1.nullEq(t2, eq);
      case [TFun(args1, ret1), TFun(args2, ret2)]: funEq(args1, args2, ret1, ret2);
      case [TMono(t1), TMono(t2)]: t1.get().nullEq(t2.get(), eq);
      case [TLazy(f1),TLazy(f2)]: f1().eq(f2());
      case _: Scuts.notImplemented();
    }
  }
  
  public static function toComplexType (t:Type, ?pos:Position):Validation<Error, ComplexType>
	{
    var p = if (pos == null) Context.currentPos() else pos;
    var s = Print.type( t, true);
		return Success(ComplexTypes.fromString(s));
	}
  
  public static function isContextFunctionTypeParameter(type:Type):Bool
  {
    var meth = MCore.getLocalMethod();
    
    return meth.map(function (x) {
      return switch (type) {
        case TInst(t, _):
          var p = t.get().pack;
          p.length == 1 && p[0] == x;
        case _ : false;
      }
    }).getOrElseConst(false);
  }
  
  public static function isContextClassTypeParameter(type:Type):Bool
  {
    
    var ct = MCore.getLocalClassAsClassType();
    
    return ct.map(function (x) {
      return switch (type) {
        case TInst(t, _):
          var pack = t.get().pack;
          var cpack = x.pack.appendElem(x.name);
          pack.length == cpack.length && Arrays.eq(pack, cpack, Strings.eq);
        case _: false;
      }
    }).getOrElseConst(false);
  }
  
  
  public static function hasNoArgMethod (t:Type, methodName:String, ?isStatic:Bool = false) 
  {
    var filter = function (cf:ClassField) 
    {
      return cf.params.length == 0 
         && cf.name == methodName 
         && switch [cf.kind, cf.type] 
            { 
              case [FieldKind.FMethod(_),_]: true;
              case [FieldKind.FVar(_, _), TFun(args, _)]: args.length == 0;
              case _ : false;
            } 
    };
    
    return switch (t) 
    {
      case TAbstract(_,_): Scuts.notImplemented();
      case TLazy(_): false;
      case TMono(_), TFun(_,_), TDynamic(_), TEnum(_,_): false;
      case TInst(t, _) if (isStatic): t.get().statics.get().any(filter);
      case TInst(t, _): 
        t.get().fields.get().any(filter) 
            || (t.get().superClass != null 
              && hasNoArgMethod(TInst(t.get().superClass.t, t.get().superClass.params), methodName));

      case TType(t, _):
        hasNoArgMethod(t.get().type, methodName, true);
      case TAnonymous(a):
        a.get().fields.any(filter);
      //case _ : Scuts.unexpected();
    }
  }
  
  @:noUsing public static function getType (s:String):Option<Type>
  {
    var parts = s.split(".");
    if (parts.length > 1) {
      var f1 = parts[parts.length-1].charAt(0);
      var f2 = parts[parts.length - 2].charAt(0);
      if (f1.toUpperCase() == f1 && f2.toUpperCase() == f2) {
        // Module
        
        if (f1 == f2) {
          parts.splice(parts.length - 2, 1);
          return try Some(Context.getType(parts.join("."))) catch (e:Dynamic) None;
          
        } else {
          var typeName = parts.pop();
          return getTypeFromModule(parts.join("."), typeName);
        }
      } 
    }
    return try Some(Context.getType(s)) catch (e:Dynamic) None;
  }
	
	@:noUsing public static function getTypeFromModule (module:String, typeName:String):Option<Type> {
    //trace("check if type from module" + typeName);
    
		var types = try Context.getModule(module) catch (e:Dynamic) null;
		if (types == null && module == typeName) {
      //trace("try from StdTypes for " + typeName);
      types = try Context.getModule("StdTypes") catch (e:Dynamic) null;
    }
    return if (types == null) {
      // maybe from StdTypes
      None;
    } else {
      types.mapThenSome(function (t) {
        return switch (t) {
          case TInst(r, _) if (r.get().name == typeName): Some(t);
          case TEnum(r, _) if (r.get().name == typeName): Some(t);
          case TType(r, _) if (r.get().name == typeName): Some(t);
          case _: None;
        }
      }, function (t) return t.isSome()).flatten();
		}
		
		
	}
  
  @:noUsing public static function fromString(s:String, ?context:Dynamic, ?pos:Position) 
  {
    return Parse.parseToType(s, context, pos);
  }
  
}

#end