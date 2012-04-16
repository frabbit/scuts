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



#end
class TcRegistry 
{

  #if (macro || display)
  
  
  // stores type class instance infos where the key is the 
  // full qualified type name of the implemented type class
  public static var registry:Hash<Array<TypeClassInstanceInfo>> = new Hash();
  
  public static function init () {
    trace(registry);
  }
  
  // stores type class instance infos where the key is the 
  // full qualified type name of the instance itself
  public static var instanceRegistry:Hash<TypeClassInstanceInfo> = new Hash();
  
  static function isTypeClass (ct:ComplexType) {
    return switch (ct) {
      case ComplexType.TPath (tp):
        var p = tp.pack;
        var s = (p.length > 0 ? p.join(".") + "." : "") + tp.name;
        trace(s);
        var type = MContext.getType(s);
        type.map( isTypeTypeClass).getOrElseConst(false);
      default:
        false;
    }
  }
  
  static function isTypeTypeClass (type:Type):Bool {
    
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
    return if (!lc.meta.has(Constants.ABSTRACT_TYPE_CLASS_READY)) {
      
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
  
  static function buildTypeClassInstance (lc:ClassType, fields:Array<Field>) {
    
    return if (!lc.meta.has(Constants.INSTANCE_TYPE_CLASS_READY)) {
      

      //trace("build tc - instance " + lc.name);
      var superClass = lc.superClass.nullToOption();
      
      var isNoAbstractClass = !lc.meta.has(Constants.ABSTRACT_TYPE_CLASS_MARKER);
      
      
      
      var hasAbstractSuperClass = switch (superClass) 
      {
        case Some(v): 
          if (v.t.get().meta.has(Constants.ABSTRACT_TYPE_CLASS_MARKER)) true 
          else Scuts.macroError("Type Classes must extend classes marked with @" + Constants.ABSTRACT_TYPE_CLASS_MARKER);
        case None: false;
      }
      
      var isValidTypeClassInstance = superClass.isSome() && isNoAbstractClass && hasAbstractSuperClass;
      
      if (!isValidTypeClassInstance) { 
        Scuts.macroError("Type Class Instances must extend an abstract type class marked with @" + Constants.ABSTRACT_TYPE_CLASS_MARKER);
      } else {
        // the type class implemented by this instance
        var tc = lc.superClass.t.get().interfaces[0].t.get();
        var tcParams = lc.superClass.t.get().interfaces[0].params.map(function (p) {
          var mapping = Utils.getTypeParamMappings(lc, lc.superClass.t.get()).getOrError("Cannot get Mapping");
          return Utils.remap(p, Utils.reverseMapping(mapping));
        });
        
        // these must be all be type classes
        var constructorArguments = Utils.getConstructorArgumentTypes(fields)
          .map(function (x) return x.map(Convert.complexTypeToType))
          .filter(function (x) return x.all(isTypeTypeClass))
          .getOrError("All constructor argument types must reference Type classes");
        
        
        
        // the type parameter mappings from instance to type class
        
        var typeParams = Utils.getParamsAsTypes(lc);
        
        var typeParamMapping = Utils.getTypeParamMappings(lc, tc).getOrError("Cannot resolve Parameter Mappings");
        
        var constructorArgsWithUsedTypeParams = constructorArguments
          .map( function (x) return Tup2.create(x, Utils.getContainingTypes(x, typeParams)));
          
        var allParamsUsedInConstructorArgs = constructorArgsWithUsedTypeParams.flatMap(function (x) return x._2).nub(TypeExt.eq);
        
        var freeParams = typeParams.difference(allParamsUsedInConstructorArgs, TypeExt.eq);
        
        var reverseMapping = typeParamMapping.map(function (x) return Tup2.create(x._2, x._1));
        
        var tcParamTypes = tcParams.map(function (x) return Utils.remap(x, reverseMapping));
        
       
        
        
        var tcId = SType.getFullQualifiedTypeName(tc);
        var instanceId = SType.getFullQualifiedTypeName(lc);
        var typeParamBaseId = (lc.pack.length > 0 ? lc.pack.join(".") + "." : "") + lc.name;
        var tcInstances = registry.get(tcId);
        
        var usingCall = "using_" + lc.pack.join("_") + "_" + lc.name;
        
        var info = {
          instance:lc,
          tc : tc,
          tcParamMappings : typeParamMapping,
          dependencies : constructorArgsWithUsedTypeParams,
          freeParameters: freeParams,
          allParameters:typeParams,
          usingCall : usingCall,
          tcParamTypes : tcParamTypes
        }
        registry.get(tcId).push(info);
        
        
        var printableArgs = 
          constructorArgsWithUsedTypeParams.map(
            function (x) {
              var mapping = x._2.map(
                function (x) return Tup2.create(x, switch (x) { 
                  case TInst(t, _): 
                    Parse.parseToType(t.get().name).extract(); 
                  default:Scuts.macroError("Invalid");
                })
              );
              return Utils.remap(x._1, mapping);
            }
          );
        
            
        // mark as ready, processed
        lc.meta.add(Constants.INSTANCE_TYPE_CLASS_READY, [], Context.currentPos());
        
        // now we need to add a get function on this instance that allows to receive this type class
        var typeParamStrings = typeParams.map(function (x) return switch (x) { case TInst(t, params): t.get().name; default: Scuts.macroError("Invalid");});
        var getTypeParams = (typeParamStrings.length > 0) ? ("<" + typeParamStrings.join(",") + ">") : "";
        var args = printableArgs.mapWithIndex(function (x,i) return "a" + i + ":" + Print.type(x).split(typeParamBaseId + ".").join(""));
        var callArgs = printableArgs.mapWithIndex(function (x,i) return "a" + i);
        
        var retType = instanceId + getTypeParams;
        
        var s = "function " + getTypeParams + "(" + args.join(",") + "):" + retType + " return new " + instanceId + "(" + callArgs.join(",") + ")";
        
        
        //trace(s);
        
        
        var fExpr = Parse.parse(s);
        
        var f1 = {
          name: "get",
          kind:FieldType.FFun(Select.selectEFunctionFunction(fExpr).extract()),
          pos:Context.currentPos(),
          access: [Access.AStatic, Access.APublic],
          doc:null,
          meta:[]
        };
        
        var s2 = "function (p:Class<hots.macros.internal.UsingScope>):Void {}";
        
        var f2Expr = Parse.parse(s2);
        var f2 = {
          name: usingCall,
          kind:FieldType.FFun(Select.selectEFunctionFunction(f2Expr).extract()),
          pos:Context.currentPos(),
          access: [Access.AStatic, Access.APublic],
          doc:null,
          meta:[]
        };
        
        
        
        fields.concat([f1,f2]);
      }
    } else {
      fields;
    }
    
  }
  
  static function isTypeClassInterface (t:ClassType):Bool 
  {
    
    return t.name == "TC" && t.pack.join(".") == "hots";
  }
  
  static function buildTypeClassInterface (lc:ClassType, fields:Array<Field>) {
    
    return if (!lc.meta.has(Constants.TYPE_CLASS_READY)) { 
      
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
    
    return try {
      var fields = Context.getBuildFields();
      var lc = Context.getLocalClass().get();
      //trace(lc.name);
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
    } catch (e:Error) {
      trace(Stack.exceptionStack());
      trace(Context.getLocalClass());
      Scuts.macroError(e.message, e.pos);
    }
    
    //Context.registerModuleReuseCall("hots.macros.TcRegistry", "reuse");
    
    Context.registerModuleReuseCall("hots.macros.TcRegistry", "reuse");
    
    return Context.getBuildFields();
  }
  
  public static function reuse () {
    Log.traced("hey");
  }
  

  
}

