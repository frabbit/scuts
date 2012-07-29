package hots.macros;

#if (macro || display)


private typedef SType = scuts.mcore.Type;

using scuts.core.extensions.Arrays;
import haxe.macro.Format;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.Stack;
import hots.macros.utils.Constants;
import hots.macros.utils.Utils;
import neko.FileSystem;
import neko.io.File;
import scuts.core.extensions.Arrays;
import scuts.core.extensions.Tup2s;
import scuts.core.Log;
import scuts.core.types.Option;
import scuts.macros.Lazy;
import scuts.mcore.cache.DiskCache;
import scuts.mcore.cache.ExprCache;
import scuts.mcore.Convert;
import scuts.mcore.MContext;
import scuts.mcore.extensions.ComplexTypeExt;
import scuts.mcore.extensions.TypeExt;
import scuts.mcore.Print;
import scuts.mcore.Parse;
import scuts.mcore.Select;
import scuts.Scuts;
import scuts.core.types.Tup2;

import hots.macros.Data;

using scuts.core.extensions.Functions;

using scuts.mcore.extensions.TypeExt;
using scuts.core.extensions.Options;
using scuts.core.extensions.Dynamics;

enum TcType {
  TTInstance(tc:ClassType, mapping:Mapping);
  TTAbstract(tc:ClassType);
  TTClass(tc:ClassType);
}

private typedef U = Utils;
private typedef A = Arrays;

#end
class Registry 
{

  #if (macro || display)
  
  
  // stores type class instance infos where the key is the 
  // full qualified type name of the implemented type class
  public static var registry:Hash<Array<TypeClassInstanceInfo>> = new Hash();
  
  
  static function isTypeClass (ct:ComplexType):Bool 
  {
    return switch (ct) {
      case ComplexType.TPath (tp):
        var p = tp.pack;
        var s = (p.length > 0 ? p.join(".") + "." : "") + tp.name;
        var type = MContext.getType(s);
        type.map( isTypeClassByType).getOrElseConst(false);
      default:
        false;
    }
  }
  
  static function isTypeClassByType (type:Type):Bool 
  {
    return switch (type) {
      case TInst(t, _):
        var interf = t.get().interfaces;
        interf.any( function (x) return isTypeClassInterface(x.t.get()));
        
      default:
        false;
    }
  }
  
  static function buildTypeClassAbstract (lc:ClassType, fields:Array<Field>):Array<Field> 
  {
    return if (!lc.meta.has(Constants.ABSTRACT_TYPE_CLASS_READY)) 
    {
      // must not have a superclass and implements a type class directly and must be marked with tcAbstract
      
      var hasSuperClass = lc.superClass != null;
      
      if (hasSuperClass)
        Scuts.macroError("Abstract type classes are not allowed to extend other classes");
      else 
      {
        var hasAbstractClassMarker = lc.meta.has(Constants.ABSTRACT_TYPE_CLASS_MARKER);

        if (!hasAbstractClassMarker)
          Scuts.macroError("Abstract Type Class must be marked with " + Constants.ABSTRACT_TYPE_CLASS_MARKER);
        else 
        {
          // mark as ready, processed to do this check only once
          lc.meta.add(Constants.ABSTRACT_TYPE_CLASS_READY, [], Context.currentPos());
          fields;
        }
      }
    } else {
      fields;
    }
  }
  static function hasAbstractMarker (ct:ClassType) 
  {  
    return ct.meta.has(Constants.ABSTRACT_TYPE_CLASS_MARKER);
  }
  
  static function isValidTypeClass (lc:ClassType) 
  {
    var superClass = lc.superClass.nullToOption();
      
    var isNoAbstractClass = !hasAbstractMarker(lc);

    var hasAbstractSuperClass = switch (superClass) 
    {
      case Some(v): 
        if (hasAbstractMarker(v.t.get())) true 
        else false;
      case None: false;
    }
    return superClass.isSome() && isNoAbstractClass && hasAbstractSuperClass;
  }
  
  static function getContructorArgsFromFields (fields:Array<Field>):Array<Type> 
  {
    var complexToType = A.map.partial2(Convert.complexTypeToType);
    var allTypeClasses = A.all.partial2(isTypeClassByType);
    
    return U.getConstructorArgumentTypes(fields)
    .map(complexToType)
    .filter(allTypeClasses)
    .getOrError("All constructor argument types must reference Type classes");
  }
  
  static function buildTypeClassInstance (lc:ClassType, fields:Array<Field>) 
  {
    return if (!lc.meta.has(Constants.INSTANCE_TYPE_CLASS_READY)) 
    {

      //trace("build tc - instance " + lc.name);
      
      if (!isValidTypeClass(lc)) 
      { 
        Scuts.macroError("Type Class Instances must extend an abstract type class marked with @" + Constants.ABSTRACT_TYPE_CLASS_MARKER);
      } 
      else 
      {
        // the type class implemented by this instance
        var tc = lc.superClass.t.get().interfaces[0].t.get();
        var tcParams = 
        {
          function paramMapping(p:Type) {
            var mapping = U.getTypeParamMappings(lc, lc.superClass.t.get()).getOrError("Cannot get Mapping");
            return U.remap(p, U.reverseMapping(mapping));
          }
          lc.superClass.t.get().interfaces[0].params.map(paramMapping);
        }
        
        // these must be all be type classes
        var constructorArguments = getContructorArgsFromFields(fields);
        
        // the type parameter mappings from instance to type class
        
        var instanceTypeParams = U.getParamsAsTypes(lc);
        
        var typeParamMapping = U.getTypeParamMappings(lc, tc).getOrError("Cannot resolve Parameter Mappings");
        
        var constructorArgsWithUsedTypeParams = {
          function withContainingTypes (x) return Tup2.create(x, U.getContainingTypes(x, instanceTypeParams));
          constructorArguments.map(withContainingTypes);
        }

        var freeParams = {
          var allParamsUsedInConstructorArgs = constructorArgsWithUsedTypeParams.flatMap(Tup2s.second).nub(TypeExt.eq);
          instanceTypeParams.difference(allParamsUsedInConstructorArgs, TypeExt.eq);
        }

        var tcParamTypes = {
          var reverseMapping = typeParamMapping.map(Tup2s.swap);
          tcParams.map(function (x) return U.remap(x, reverseMapping));
        }

        var tcId = SType.getFullQualifiedTypeName(tc);

        var usingCall = "using_" + lc.pack.join("_") + "_" + lc.name;

        // mark as ready, processed
        lc.meta.add(Constants.INSTANCE_TYPE_CLASS_READY, [], Context.currentPos());

        var info = {
          instance:lc,
          tc : tc,
          tcParamMappings : typeParamMapping,
          dependencies : constructorArgsWithUsedTypeParams,
          freeParameters: freeParams,
          allParameters:instanceTypeParams,
          usingCall : usingCall,
          tcParamTypes : tcParamTypes
        }

        registerTypeClassInstance(tcId, info);

        var getField = createGetField(instanceTypeParams, lc, constructorArgsWithUsedTypeParams);
        var usingField = createUsingField(usingCall);
        
        var res = fields.concat([getField,usingField]);
        //trace(res.map(function (x) return Print.field(x)).join("\n"));
        res;
      }
    } else {
      fields;
    }
  }
  
  static private function createGetField(typeParams:Array<Type>, lc:ClassType, constructorArgsWithUsedTypeParams:Array<Tup2<Type, Array<Type>>>) 
  {
    var instanceId = SType.getFullQualifiedTypeName(lc);
    var typeParamBaseId = (lc.pack.length > 0 ? lc.pack.join(".") + "." : "") + lc.name;
    
    var printableArgs = {
      function makePrintable (x:Tup2<Type, Array<Type>>) 
      {
        function parseToType (x:Type) 
        {
          var parsed = switch (x) { 
            case TInst(t, _): 
            Parse.parseToType(t.get().name).extract(); 
            default:Scuts.macroError("Invalid");
          };
          return Tup2.create(x, parsed);
        }
        
        var mapping = x._2.map(parseToType);
        return U.remap(x._1, mapping);
      }
      constructorArgsWithUsedTypeParams.map(makePrintable);
    }
    // now we need to add a get function on this instance that allows to receive this type class
    
    function typeParamToString(x:Type) {
      return switch (x) { 
        case TInst(t, params): t.get().name; 
        default: Scuts.macroError("Invalid"); 
      } 
    }
    
    var typeParamStrings = typeParams.map(typeParamToString);
    
    var getTypeParams = 
      if (typeParamStrings.length > 0) "<" + typeParamStrings.join(",") + ">"
      else "";
    
    var args = {
      function argumentStr (x:Type,i:Int) 
      {
        return "a" + i + ":" + Print.type(x).split(typeParamBaseId + ".").join("");
      }
      printableArgs.mapWithIndex(argumentStr);
    }
    
    var callArgs = printableArgs.mapWithIndex(function (x,i) return "a" + i);
    var returnType = instanceId + getTypeParams;
    var joinedArgs = args.join(',');
    var joinedCallArgs = callArgs.join(',');
    var s = Std.format("function $getTypeParams($joinedArgs):$returnType return new $instanceId($joinedCallArgs)");
    var fExpr = Parse.parse(s);

    return {
      name: "get",
      kind:FieldType.FFun(Select.selectEFunctionFunction(fExpr).extract()),
      pos:Context.currentPos(),
      access: [Access.AStatic, Access.APublic],
      doc:null,
      meta:[]
    };
  }
  
  static private function createUsingField(usingFunctionName:String) 
  {
    var functionStr = "function (p:Class<hots.macros.internal.UsingScope>):Void {}";
        
    var functionExpr = Parse.parse(functionStr);
    return  {
      name: usingFunctionName,
      kind:FieldType.FFun(Select.selectEFunctionFunction(functionExpr).extract()),
      pos:Context.currentPos(),
      access: [Access.AStatic, Access.APublic],
      doc:null,
      meta:[]
    };
  }
  
  static function registerTypeClassInstance (tcId:String, info:TypeClassInstanceInfo) 
  {
    registry.get(tcId).push(info);
  }
  
  static function isTypeClassInterface (t:ClassType):Bool 
  {
    return t.name == "TC" && t.pack.join(".") == "hots";
  }
  
  static function buildTypeClassInterface (lc:ClassType, fields:Array<Field>) 
  {
    return if (!lc.meta.has(Constants.TYPE_CLASS_READY)) 
    { 
      
      // get the constraints for this type class
      var constraints = lc.interfaces.filter(function (i) return isTypeClassInterface(i.t.get()));
      
      // unique id for this type class based on it's fully qualified name
      var tcId = SType.getFullQualifiedTypeName(lc);
      
      // create a registry entry for this type class
      // instances are inserted in the array
      registry.set(tcId, []);
      
      // make sure this function is not again called 
      lc.meta.add(Constants.TYPE_CLASS_READY, [], Context.currentPos());
      fields;
    } 
    else 
    {
      fields;
    }
  }
  #end
  @:macro public static function build <T>():Array<Field> {
    
    return try 
    {
      var fields = Context.getBuildFields();
      var lc = Context.getLocalClass().get();
      //trace("register:"  +lc.name);
      return if (lc.isInterface) {
        // it's a type class interface
        buildTypeClassInterface(lc, fields);
      } else if (lc.superClass.nullToOption().isNone()){
        // it's an abstract instance
        buildTypeClassAbstract(lc, fields);
      } else {
        // it's an instance
        var r = buildTypeClassInstance(lc, fields);
        r;
      }
    } 
    catch (e:Error) 
    {
      trace(Stack.exceptionStack());
      trace(Context.getLocalClass());
      Scuts.macroError(e.message, e.pos);
    }
    
    return Context.getBuildFields();
  }

  

  
}

