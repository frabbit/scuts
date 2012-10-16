package scuts.mcore;
#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)

using scuts.core.Arrays;

using scuts.core.Iterables;





import haxe.macro.Expr;
import haxe.macro.Type.BaseType;
import haxe.macro.Type.ClassField;
import haxe.macro.Type.ClassType;
import haxe.macro.Type.DefType;
import scuts.mcore.types.InstType;

import haxe.macro.Type.Ref;
import haxe.macro.Context;
import scuts.core.Arrays;
import scuts.core.Strings;
import scuts.core.Tup2;
import scuts.Scuts;
import scuts.core.Option;
using scuts.core.Options;

private typedef MType = haxe.macro.Type;





class Type 
{
  
  
  
  
  public static function isContextFunctionTypeParameter(type:MType):Bool
  {
    var meth = MContext.getLocalMethod();
    
    return meth.map(function (x) {
      return switch (type) {
        case TInst(t, _):
          var p = t.get().pack;
          p.length == 1 && p[0] == x;
        default: false;
      }
    }).getOrElseConst(false);
  }
  
  public static function isContextClassTypeParameter(type:MType):Bool
  {
    
    var ct = MContext.getLocalClassAsClassType();
    
    return ct.map(function (x) {
      return switch (type) {
        case TInst(t, _):
          var pack = t.get().pack;
          var cpack = x.pack.appendElem(x.name);
          pack.length == cpack.length && Arrays.eq(pack, cpack, Strings.eq);
        default: false;
      }
    }).getOrElseConst(false);
  }
  
  public static function isInstanceOf (subType:ComplexType, superType:ComplexType):Bool 
  {
    var test = '{
      var subType:$0 = null;
      var superType:$1 = subType;
      superType;
    }';
    
    var e = Parse.parse(test, [subType, superType]);

    // get type of expression, should work when subType is a SubType of superType
    // and throws an exception if not
    return try {
      Context.typeof(e);
      true;
    } catch (e:Dynamic) {
      false;
    }
  }
  
  public static function isSubtypeOf (subType:ComplexType, superType:ComplexType):Bool 
  {
    return isInstanceOf(subType, superType) && !isInstanceOf(superType, subType);
  }
  
  public static function isSupertypeOf (superType:ComplexType, subType:ComplexType):Bool
  {
    return isSubtypeOf(subType, superType);
  }
  
	public static inline function hasTypeParameters (type:BaseType) 
  {
    return type.params.length != 0;
  }
  
  public static function getClassId (type:BaseType):String 
  {
    return type.pack.join("_") + (if (type.pack.length > 0) "_" else "") + type.name;
  }
  
  
  
  public static function getType (s:String):Option<MType>
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
	
	public static function getTypeFromModule (module:String, typeName:String):Option<MType> {
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
      types.someMapped(function (t) {
        return switch (t) {
          case TInst(r, _): if (r.get().name == typeName) Some(t) else None;
          case TEnum(r, _): if (r.get().name == typeName) Some(t) else None;
          case TType(r, _): if (r.get().name == typeName) Some(t) else None;
          default: None;
        }
      }, function (t) return t.isSome()).flatten();
		}
		
		
	}
  
  public static function hasNoArgMethod (t:MType, methodName:String, ?isStatic:Bool = false) 
  {
    var filter = function (cf:ClassField) 
    {
      return cf.params.length == 0 
         && cf.name == methodName 
         && switch (cf.kind) 
            { 
              case FieldKind.FMethod(_): true;
              case FieldKind.FVar(_, _): switch (cf.type) 
              {
                case TFun(args, _): args.length == 0;
                default: false;
              }
            } 
    };
    
    return switch (t) 
    {
      case TLazy(_): false;
      case TMono(_), TFun(_,_), TDynamic(_), TEnum(_,_): false;
      case TInst(t, _): 
        if (isStatic)
          t.get().statics.get().any(filter);
        else 
        {
          t.get().fields.get().any(filter) 
            || (t.get().superClass != null 
              && hasNoArgMethod(TInst(t.get().superClass.t, t.get().superClass.params), methodName));
        }
      case TType(t, _):
        hasNoArgMethod(t.get().type, methodName, true);
      case TAnonymous(a):
        a.get().fields.any(filter);
    }
  }
}

#end