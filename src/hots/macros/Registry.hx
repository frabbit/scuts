package hots.macros;


#if (macro || display)


private typedef SType = scuts.mcore.Type;

using scuts.core.extensions.Arrays;
import haxe.macro.Format;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.Stack;
import haxe.Timer;
import hots.macros.utils.Constants;
import hots.macros.utils.Utils;
import neko.FileSystem;
import neko.io.File;
import scuts.core.extensions.Arrays;
import scuts.core.extensions.Options;
import scuts.core.extensions.Tup2s;
import scuts.core.Log;
import scuts.core.types.Option;
import scuts.macros.Lazy;
import scuts.mcore.cache.DiskCache;
import scuts.mcore.cache.ExprCache;
import scuts.mcore.Convert;
import scuts.mcore.Make;
import scuts.mcore.MContext;
import scuts.mcore.extensions.ComplexTypes;
import scuts.mcore.extensions.Types;
import scuts.mcore.Print;
import scuts.mcore.Parse;
import scuts.mcore.Select;
import scuts.Scuts;
import scuts.core.types.Tup2;

import hots.macros.Data;

using scuts.core.extensions.Functions;

using scuts.mcore.extensions.Types;
using scuts.core.extensions.Options;


enum TcType 
{
  TTInstance(tc:ClassType, mapping:Mapping);
  TTAbstract(tc:ClassType);
  TTClass(tc:ClassType);
}

private typedef U = Utils;
private typedef A = Arrays;



class Registry
{

  
  
  
  // stores type class instance infos where the key is the 
  // full qualified type name of the implemented type class
  public static var registry:Hash<Array<TypeClassInstanceInfo>> = new Hash();
  
  
  static function isTypeClass (ct:ComplexType):Bool return switch (ct) 
  {
    case ComplexType.TPath (tp):
      var p = tp.pack;
      var packStr = if (p.length > 0) p.join(".") + "." else "";
      var typeStr = packStr + tp.name;
      var type = MContext.getType(typeStr);
      type.map(isTypeClassByType).getOrElseConst(false);
    default:
      false;
  }
  
  static function isTypeClassByType (type:Type):Bool return switch (type) 
  {
    case TInst(t, _):
      var interf = t.get().interfaces;
      interf.any( function (x) return isTypeClassInterface(x.t.get()));
      
    default:
      false;
  }
  
  
  public static function buildTypeClassAbstract (lc:ClassType, fields:Array<Field>):Array<Field> 
  {
    return if (!isAbstractAlreadyBuilded(lc)) 
    {
      // must not have a superclass and implements a type class directly and must be marked with tcAbstract
      
      var hasSuperClass = lc.superClass != null;
      
      if (hasSuperClass)
        Scuts.macroError("Abstract type classes are not allowed to extend other classes");
      else 
      {
        if (!hasAbstractMarker(lc))
          Scuts.macroError("Abstract Type Class must be marked with " + Constants.ABSTRACT_TYPE_CLASS_MARKER);
        else 
        {
          // mark as builded, processed to do this check only once
          markAbstractAsBuilded(lc);
          fields;
        }
      }
    } 
    else fields;
  }
  
  static function markAbstractAsBuilded (ct:ClassType) 
  {  
    ct.meta.add(Constants.ABSTRACT_TYPE_CLASS_READY, [], Context.currentPos());
  }
  
  static function isAbstractAlreadyBuilded (ct:ClassType) 
  {  
    return ct.meta.has(Constants.ABSTRACT_TYPE_CLASS_READY);
  }
  
  static function hasAbstractMarker (ct:ClassType) 
  {  
    return ct.meta.has(Constants.ABSTRACT_TYPE_CLASS_MARKER);
  }
  
  static function implementsAbstractTypeClass (ct:ClassType) 
  {
    var superClass = ct.superClass.nullToOption();
    
    function hasMarker (v) return hasAbstractMarker(v.t.get());
    
    return superClass.filter(hasMarker).isSome();
  }
  
  static function isValidTypeClassInstance (lc:ClassType) 
  {
    var isNoAbstractClass = !hasAbstractMarker(lc);

    return isNoAbstractClass && implementsAbstractTypeClass(lc);
  }
  
  static function getContructorArgsFromFields (fields:Array<Field>):Array<Type> 
  {
    var complexToType = A.map.partial2(Options.getOrError.partial2_("Error for fields: " + fields).compose(Convert.complexTypeToType));
    var allTypeClasses = A.all.partial2(isTypeClassByType);
    
    return 
      U.getConstructorArgumentTypes(fields)
      .map(complexToType)
      .filter(allTypeClasses)
      .getOrError("All constructor argument types must reference Type classes");
  }
  
  
  
  public static function buildTypeClassInstance (lc:ClassType, fields:Array<Field>) 
  {
    return if (!lc.meta.has(Constants.INSTANCE_TYPE_CLASS_READY)) 
    {

      if (!isValidTypeClassInstance(lc)) 
      { 
        Scuts.macroError("Type Class Instances must extend an abstract type class marked with @" + Constants.ABSTRACT_TYPE_CLASS_MARKER);
      } 
      else 
      {
        #if scutsDebug
        var buildTime = Timer.stamp();
        #end
        // the type class implemented by this instance
        var superClass = lc.superClass.t.get();
        var superTypeClass = superClass.interfaces[0];
        var tc = superTypeClass.t.get();
        var tcParams = 
        {
          function paramMapping(p:Type) 
          {
            var mapping = U.getTypeParamMappings(lc, superClass).getOrError("Cannot get Mapping");
            return U.remap(p, U.reverseMapping(mapping));
          }
          superTypeClass.params.map(paramMapping);
        }
       
        // these must be all be type classes
        var constructorArguments = getContructorArgsFromFields(fields);
        
        // the type parameter mappings from instance to type class
        
        var instanceTypeParams = U.getParamsAsTypes(lc);
        
        var typeParamMapping = U.getTypeParamMappings(lc, tc).getOrError("Cannot resolve Parameter Mappings");
        
        var constructorArgsWithUsedTypeParams = 
        {
          function withContainingTypes (x) return Tup2.create(x, U.getContainingTypes(x, instanceTypeParams));
          constructorArguments.map(withContainingTypes);
        }

        var freeParams = 
        {
          var allParamsUsedInConstructorArgs = constructorArgsWithUsedTypeParams.flatMap(Tup2s.second).nub(Types.eq);
          instanceTypeParams.difference(allParamsUsedInConstructorArgs, Types.eq);
        }

        var tcParamTypes = 
        {
          var reverseMapping = typeParamMapping.map(Tup2s.swap);
          tcParams.map(U.remap.partial2(reverseMapping));
        }
        
        var tcId = SType.getFullQualifiedTypeName(tc);

        var usingCall = "using_" + lc.pack.join("_") + "_" + lc.name;

        // mark as ready, processed
        lc.meta.add(Constants.INSTANCE_TYPE_CLASS_READY, [], Context.currentPos());

        var info = 
        {
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
        #if scutsDebug
        //trace("build time for instance " + lc.name + ":" + (Timer.stamp()-buildTime));
        #end
        //trace(res.map(function (x) return x.name));
        res;
      }
    } 
    else fields;
  }
  
  static private function createGetField(typeParams:Array<Type>, lc:ClassType, constructorArgsWithUsedTypeParams:Array<Tup2<Type, Array<Type>>>) 
  {
    var instanceId = SType.getFullQualifiedTypeName(lc);
    var typeParamBaseId = (lc.pack.length > 0 ? lc.pack.join(".") + "." : "") + lc.name;
    
    var printableArgs = 
    {
      function makePrintable (x:Tup2<Type, Array<Type>>) 
      {
        function parseToType (x:Type) 
        {
          var parsed = switch (x) 
          { 
            case TInst(t, _): Parse.parseToType(t.get().name).extract(); 
            default: Scuts.macroError("Invalid");
          };
          return Tup2.create(x, parsed);
        }
        
        var mapping = x._2.map(parseToType);
        return U.remap(x._1, mapping);
      }
      constructorArgsWithUsedTypeParams.map(makePrintable);
    }
    // now we need to add a get function on this instance that allows to receive this type class
    
    function typeParamToString(x:Type) return switch (x) 
    { 
      case TInst(t, params): t.get().name; 
      default:               Scuts.macroError("Invalid"); 
    }
    
    var typeParamStrings = typeParams.map(typeParamToString);
    
    var getTypeParams = 
      if (typeParamStrings.length > 0) "<" + typeParamStrings.join(",") + ">"
      else "";
    
    var args = 
    {
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

    
    return 
    {
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

    var functionExpr = macro function (p:Class<hots.macros.internal.UsingScope>):Void {};
    
    return  
    {
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
  
  static function markInterfaceAsBuilded (ct:ClassType) 
  {  
    ct.meta.add(Constants.TYPE_CLASS_READY, [], Context.currentPos());
  }
  
  static function isInterfaceAlreadyBuilded (ct:ClassType) 
  {  
    return ct.meta.has(Constants.TYPE_CLASS_READY);
  }
  
  
  
  public static function buildTypeClassInterface (lc:ClassType, fields:Array<Field>) 
  {
    return if (!isInterfaceAlreadyBuilded(lc)) 
    { 
      // get the constraints for this type class
      var constraints = lc.interfaces.filter(function (i) return isTypeClassInterface(i.t.get()));
      
      // unique id for this type class based on it's fully qualified name
      var tcId = SType.getFullQualifiedTypeName(lc);
      
      // create a registry entry for this type class
      // instances are inserted in the array
      registry.set(tcId, []);
      
      // make sure this function is not again called 
      markInterfaceAsBuilded(lc);
      fields;
    } 
    else fields;
  }
  
  public static function buildClass <T>():Array<Field> 
  {
    return try 
    {
      var fields = Context.getBuildFields();
      var lc = Context.getLocalClass().get();

      return 
        if (lc.isInterface)             buildTypeClassInterface(lc, fields) // it's a type class interface
        else if (lc.superClass == null) buildTypeClassAbstract(lc, fields) // it's an abstract instance
        else                            buildTypeClassInstance(lc, fields); // it's an instance
      
    } 
    catch (e:Error) 
    {
      #if scutsDebug
      trace(Stack.exceptionStack());
      trace(Context.getLocalClass());
      #end
      Scuts.macroError(e.message, e.pos);
    }
    
    return Context.getBuildFields();
  }

}
#end


