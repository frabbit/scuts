package hots.macros;




#if (macro || display)


private typedef SType = scuts.mcore.Type;

using scuts.core.extensions.ArrayExt;
import haxe.macro.Format;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;
import neko.FileSystem;
import neko.io.File;
import scuts.core.types.Option;
import scuts.macros.Lazy;
import scuts.mcore.cache.DiskCache;
import scuts.mcore.cache.ExprCache;
import scuts.mcore.Convert;
import scuts.mcore.ExtendedContext;
import scuts.mcore.Print;
import scuts.mcore.Parse;
import scuts.Scuts;

using scuts.core.extensions.Function1Ext;


using scuts.core.extensions.OptionExt;
using scuts.core.extensions.DynamicExt;
#end
class TypeClasses 
{

  #if (macro || display)
  
  static function templateProvider (className:String, constraintTypeGetters:String, getProviderClassOf:String, getProviderClass:String, getter:String):String
  {
    return Std.format(
'class $className 
{
  $constraintTypeGetters
  $getProviderClassOf
  $getProviderClass
  $getter
}'
    );
  }

  static function getProvider (className, getMeParams, tcClass, usingType, isOf):String {
    var prefix = Std.format("get${isOf ?  'Of' : ''}_");
    return Std.format(
'public static function $prefix$tcClass$getMeParams(t:$usingType) {
return $className;
}');
  }
  
    
  static function getterWithoutTypeParameters (fullInstanceStr:String):String {
    return Std.format(
'private static var instance: $fullInstanceStr;
public static function get() {
  if (instance == null) instance = new $fullInstanceStr();
  return instance;
}'
    );
  }
  
  static function getterWithTypeParameters (fullInstanceStr, dynamicParams, paramStrings):String {
    return Std.format(
'private static var instance:$fullInstanceStr<${dynamicParams.join(",")}>;
public static function get<${paramStrings.join(",")}>():$fullInstanceStr<${paramStrings.join(",")}> {
  if (instance == null) instance = new $fullInstanceStr();
    return cast instance;
}'
    );
  }
  
  static function getterWithConstraints (fullInstanceStr, constraints:Array<String>, paramStrings:Array<String>, constraintParams:Array<String>, constraintArgs:Array<String>):String {
    var hashParams = constraints.map(function (c) return "Dynamic").join(",");
    var getParams = paramStrings.join(",");
    var getArgs = constraintParams.join(",");
    var instanceId = constraintArgs.map(function (x) return "Type.getClassName(Type.getClass(" + x + "))").join("+\"__\"+");
    
    return Std.format(
'static var hash:Hash<$fullInstanceStr<$hashParams>> = new Hash();

public static function get <$getParams>($getArgs) {
  var id = $instanceId;
  var val = hash.get(id);
  return if (val == null) {
  var v = new $fullInstanceStr(${constraintArgs.join(",")});
    hash.set(id, v);
    v;
  } else {
    cast val;
  }
}'
    );
  }
  
  static function createConstraintTypeGetters (allParams:Array<String>, paramStrings:Array<String>, usingType:String, usingTypeOf:String) {
    var s = "";
    for (i in 0...paramStrings.length) {
      s+= '\tpublic static function get_constraint_'
          + i + '_type<' + allParams.join(",") + '>(t:' + usingType + '):'
          + paramStrings[i] + ' return cast null\n';
      s+= '\tpublic static function getOf_constraint_'
          + i + '_type<' + allParams.join(",") + '>(t:' + usingTypeOf + '):'
          + paramStrings[i] + ' return cast null\n';
    }
    return s;
  }
  
  
  static var tcConstraints:Hash<Array<{ t : Ref<ClassType>, params : Array<Type> }>> = new Hash();
  
  static var tcInstanceConstraints:Hash<Option<Array<Type>>> = new Hash();
  
  
  public static var tcConstraintUsings:Hash<Array<String>> = new Hash();
  
  public static function forType <S>(equals:Array<Expr>, hashType:String, instanceType:String, staticType:String):Expr {
    
    
    try {
    
    
      var callId = Context.signature([equals, hashType, instanceType, staticType]);
      
      return switch (DiskCache.get(callId)) {
        case Some(s):
          
          var res = Context.parse(s, Context.currentPos());
          
          res;
        case None:
          //var exprTypesId = equals.map(function (e) return Print.type(Context.typeof(e))).join("_");
          var equalArgs = equals.mapWithIndex(function (_, index) return "$" + index).join(",");
          var equalRuntimeIds = equals.mapWithIndex(function (_, index) return "Type.getClassName(Type.getClass($0))").join(" + '_' + ");

          
          var idExpr = equalRuntimeIds;
          // TODO thread safe hash access
          var expr = '{
            var privateEqArr:{ private var hash:' + hashType + ';} = ' + staticType + ';
            var id = ' + idExpr + ';
            
            if (!privateEqArr.hash.exists(id)) {
              var e = new ' + instanceType + '(' + equalArgs + ');
              privateEqArr.hash.set(id, e);
              e;
            } else {
              trace(id + " from cache");
              // we need a safe cast here to match the type of the if expr
              cast privateEqArr.hash.get(id);
            }
          }';
          //trace(expr);
          var res = Parse.parse(expr, equals);
          //trace(Print.expr(res));
          DiskCache.store(callId, Print.expr(res));
          res;
      }
    } catch (e:Error) {
      trace("ERROR " + e.message);
      Context.error(e.message, e.pos);
      return null;
    }
  }
  
  static function buildTypeClassAbstract (lc:ClassType, fields:Array<Field>):Array<Field> {
 
    return if (!lc.meta.has(":tcAbstractInfo")) {
      
      // must not have a superclass and implements a type class directly and must be marked with tcAbstract
      
      var isAbstractClassMarker = Lazy.expr(lc.meta.has(":tcAbstract"));
      
      if (!isAbstractClassMarker) {
        //trace("pre error");
        Scuts.macroError("Abstract Type Class must be marked with :tcAbstract");
      } else {
        //trace("valid");
        lc.meta.add(":tcAbstractInfo", [], Context.currentPos());
        fields;
      }
    } else {
      fields;
    }
    

    
  }
  
  static function buildTypeClassInstance (lc:ClassType, fields:Array<Field>) {
    
    return if (!lc.meta.has(":tcInstanceInfo")) {
      //trace("build tc - instance " + lc.name);
      var superClass = lc.superClass.toOption();
      
      var isNoAbstractClass = !lc.meta.has(":tcAbstract");
      
      var hasAbstractSuperClass = switch (superClass) {
        case Some(v): if (v.t.get().meta.has(":tcAbstract")) true else Scuts.macroError("Type Classes must extend classes marked with @:tcAbstract");
        case None: false;
      }
      
      var isValidTypeClassInstance = superClass.isSome() && isNoAbstractClass && hasAbstractSuperClass;
      
      if (!isValidTypeClassInstance) { 
        Scuts.macroError("Type Class Instances must extend an abstract type class marked with @:tcAbstract");
      } else {
        var constructor = fields.some(function (f) return f.name == "new");
        
        // get constraints from constructor
        var constraints = constructor.flatMap(function (c) {
          return switch (c.kind) {
            case FieldType.FFun(f):
              
              var func = function (a:FunctionArg) return Context.typeof(Parse.parse("{var a:$0 = null; a;}", [a.type]));
              //trace(f.args.map(func));
              Some(f.args.map(func));
            default: Scuts.macroError("field new is no function, shouldn't be possible");
          }
        });
        //trace(SType.getFullQualifiedTypeName(lc));
        tcInstanceConstraints.set(SType.getFullQualifiedTypeName(lc), constraints);
        //trace(constraints);
        lc.meta.add(":tcInstanceInfo", [], Context.currentPos());
        fields;
      }
    } else {
      fields;
    }
    
  }
  
  static function buildTypeClassInterface (lc:ClassType, fields:Array<Field>) {
    
    return if (!lc.meta.has(":tcClassInfo")) { 
      trace("build type class " + lc.name);
      // how many constraints
      var constraints = lc.interfaces.filter(function (i) return i.t.get().name == "TC" && i.t.get().pack.join(".") == "hots");
      
      
      tcConstraints.set(SType.getFullQualifiedTypeName(lc), constraints);
      
      lc.meta.add(":tcClassInfo", [], Context.currentPos());
      
      fields;
      
    } else {
      fields;
    }
  }
  #end
  @:macro public static function build <T>():Array<Field> {
    
    return try {
      var fields = Context.getBuildFields();
      var lc = Context.getLocalClass().get();
      
      return if (lc.isInterface) {
        // it's a type class interface
        buildTypeClassInterface(lc, fields);
      } else if (lc.superClass.toOption().isNone()){
        // it's an abstract instance
        buildTypeClassAbstract(lc, fields);
      } else {
        // it's an instance
        buildTypeClassInstance(lc, fields);
      }
    } catch (e:Error) {
      Scuts.macroError(e.message, e.pos);
    }
    
    return Context.getBuildFields();
  }
  
  @:macro public static function createProvider <T>(instance:ExprRequire<Class<T>>):Type {
    // look for TypeClass
    var type = Context.typeof(instance);
    
    var instanceTypeStr = Print.type(type).split("#").join("");
    
    // get tinst
    var inst = Context.getType(instanceTypeStr);
    
    // current type ref
    var typeRef = switch (inst) {
      case Type.TInst(t, _):
        t.get();
      default:
        Scuts.macroError("Type must be TInst");
    }
    
    if (typeRef.isPrivate) {
      Scuts.macroError("Instances of Type classes cannot be private");
    }
    var fullInstanceStr = SType.getFullQualifiedTypeName(typeRef);
    var meta = if (!typeRef.meta.has(":tcInstanceInfo")) {
      Scuts.macroError("You have to define your provider after your type class, or import it first if it's in another class");
    } 
    var constraintArr = {
      var constraints = tcInstanceConstraints.get(fullInstanceStr);
      constraints.map(function (a) return a.map(function (t) 
        return replaceSelfClassTypeParams(Print.type(t), instanceTypeStr)));
    }

    var superClass = typeRef.superClass;
    
    var wrappedTypeStr = {
      // we need to find the wrapped type 
      //trace(superClass.params);
      var wrappers = superClass.params.filter(function (p) return Print.type(p).indexOf("hots.In") >= 0);
      var wrappedType = if (wrappers.length == 1) {
        var p = wrappers[0];
        Context.follow(p, false);
      } else {
        if (superClass.params.length == 0) {
          Scuts.macroError("Every type class must have one free type parameter");
        } else {
          Context.follow(superClass.params[0], false);
        }
      };
      
      Print.type(wrappedType);
    };
    
    var usingResult = replaceInnerInTypes(wrappedTypeStr);
    
    var usingTypeOf = {
      var base = replaceSelfClassTypeParams(wrappedTypeStr, instanceTypeStr);
      var res = base;
      for (i in usingResult.replacements) {
        res = "hots.Of<" + res + ", " + i + ">";
      }
      res;
    }
    
    var usingType = replaceSelfClassTypeParams(usingResult.result, instanceTypeStr);
    
    var paramStrings = {
      var params = typeRef.params;
      params.map(function (p) return replaceSelfClassTypeParams(Print.type(p.t), instanceTypeStr));
    }
    
    var allParams = usingResult.replacements.concat(paramStrings);
    
    var className = "Provider__" + fullInstanceStr.split(".").join("__");
    
    var c = {
      var constraints = tcInstanceConstraints.get(fullInstanceStr);
      var constraintsArr = constraints.map(function (a) return a.map(function (t) {
        
        return switch (t) {
          case TInst(t, params):
            SType.getFullQualifiedTypeName(t.get());
          default: Scuts.macroError("assert");
        }
        
      }));
      switch (constraintsArr) {
        case Some(a):a;
        case None: [];
      }
    }
    
    tcConstraintUsings.set(className, c);
    
    var getProviderClass = {
      var tcClass = SType.getFullQualifiedTypeName(superClass.t.get().interfaces[0].t.get()).split(".").join("_");
      var prePost = if (allParams.length > 0) true else false;
      var getMeParams = (if(prePost) '<' else '') + allParams.join(",") + (if(prePost) '>' else '');
      getProvider(className, getMeParams, tcClass, usingType, false);
    };
    
    var getProviderClassOf = {
      var tcClass = SType.getFullQualifiedTypeName(superClass.t.get().interfaces[0].t.get()).split(".").join("_");
      var prePost = if (allParams.length > 0) true else false;
      var getMeParams = (if(prePost) '<' else '') + allParams.join(",") + (if(prePost) '>' else '');
     
      getProvider(className, getMeParams, tcClass, usingTypeOf, true);
    };

    var constraintTypeGetters = createConstraintTypeGetters(allParams, paramStrings, usingType, usingTypeOf);
    
    var getter = if (constraintArr.isSome() && constraintArr.extract().length > 0) { // we need a hash
      var constraints = switch (constraintArr) {
        case Some(v): v;
        case None: Scuts.macroError("assert");
      }
      
      var constraintParams = constraints.mapWithIndex(function (c,i) return "arg" + i + ": " + c );
      var constraintArgs = constraints.mapWithIndex(function (c,i) return "arg" + i);
      
      getterWithConstraints(fullInstanceStr, constraints, paramStrings, constraintParams, constraintArgs); 
     
    } else if (paramStrings.length > 0){
      
      var dynamicParams = paramStrings.map(function (s) return "Dynamic");
      getterWithTypeParameters(fullInstanceStr, dynamicParams, paramStrings);
      
    } else {
      getterWithoutTypeParameters(fullInstanceStr);
    }
   
    var classStr = templateProvider(className, constraintTypeGetters, getProviderClassOf, getProviderClass, getter);
    var file = File.write(className + ".hx");
    file.writeString(classStr);
    file.close();
    var ret = Context.getType(className);
    
    return ret;
  }

  #if (macro || display)
  static function replaceInnerInTypes (typeStr:String):{ result:String, replacements:Array<String>}
  {
    var replacements = [];
    var id = 0;
    var index = -1;
    while ((index = typeStr.indexOf("hots.In")) >= 0) {
      var rep = "TT" + id++;
      replacements.push(rep);
      typeStr = typeStr.substr(0, index) + rep + typeStr.substr(index+7);
    }
    return {result:typeStr, replacements:replacements};
  }
  
  
  
  static function replaceSelfClassTypeParams (type:String, clName:String ):String
  {
    return type.split(clName + ".").join("");
  }
  #end
  
}

