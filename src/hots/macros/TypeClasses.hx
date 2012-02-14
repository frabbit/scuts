package hots.macros;


using scuts.core.extensions.ArrayExt;

#if (macro || display)

private typedef SType = scuts.mcore.Type;
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
  static var tcConstraints:Hash<Array<{ t : Ref<ClassType>, params : Array<Type> }>> = new Hash();
  
  static var tcInstanceConstraints:Hash<Option<Array<Type>>> = new Hash();
  
  
  public static function forType <S>(equals:Array<Expr>, hashType:String, instanceType:String, staticType:String):Expr {
    
    
    try {
    
    
    var callId = Context.signature([equals, hashType, instanceType, staticType]);
    
    return switch (DiskCache.get(callId)) {
      case Some(s):
        
        var res = Context.parse(s, Context.currentPos());
        
        res;
      case None:
        //var exprTypesId = equals.map(function (e) return Print.typeStr(Context.typeof(e))).join("_");
        var equalArgs = equals.mapWithIndex(function (_, index) return "$" + index).join(",");
        var equalRuntimeIds = equals.mapWithIndex(function (_, index) return "Type.getClassName(Type.getClass($0))").join(" + '_' + ");

        
        var idExpr = equalRuntimeIds;
        // TODO thread safe hash access
        var exprStr = '{
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
        //trace(exprStr);
        var res = Parse.parse(exprStr, equals);
        //trace(Print.exprStr(res));
        DiskCache.store(callId, Print.exprStr(res));
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
    
    try {
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
      trace("ERROR");
      Context.error(e.message, e.pos);
      return null;
    }
    
    return Context.getBuildFields();
  }
  
  
  
  @:macro public static function createProvider <T>(instance:ExprRequire<Class<T>>):Type {
    // look for TypeClass
    var type = Context.typeof(instance);
    
    var instanceTypeStr = Print.typeStr(type).split("#").join("");
    
    // get tinst
    var inst = Context.getType(instanceTypeStr);
    
    
    
    // check constraints
    switch (inst) {
      case Type.TInst(t, params):
        if (t.get().isPrivate) {
          Scuts.macroError("Instances of Type classes cannot be private");
        } else {
          var fullInstanceStr = SType.getFullQualifiedTypeName(t.get());

          var meta = if (!t.get().meta.has(":tcInstanceInfo")) {
            Scuts.macroError("You have to define your provider after your type class, or import it first if it's in another class");
          } 

          var constraintArr = {
            var constraints = tcInstanceConstraints.get(fullInstanceStr);
            constraints.map(function (a) return a.map(function (t) 
              return replaceSelfClassTypeParams(Print.typeStr(t), instanceTypeStr)));
          }
          
          var superClass = t.get().superClass;
          
          var usingResult = {
            // we need to find the wrapped type 
            trace(superClass.params);
            var wrappers = superClass.params.filter(function (p) return Print.typeStr(p).indexOf("hots.In") >= 0);
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
            
            replaceInnerInTypes(Print.typeStr(wrappedType));
          };

          var usingType = replaceSelfClassTypeParams(usingResult.result, instanceTypeStr);
          
          var paramStrings = {
            var params = t.get().params;
            params.map(function (p) return replaceSelfClassTypeParams(Print.typeStr(p.t), instanceTypeStr));
          }
          
          var allParams = usingResult.replacements.concat(paramStrings);
          
          var className = "Provider__" + fullInstanceStr.split(".").join("__");

          var getProviderClass = {
            var tcClass = SType.getFullQualifiedTypeName(superClass.t.get().interfaces[0].t.get()).split(".").join("_");
            var prePost = if (allParams.length > 0) true else false;
            var getMeParams = (if(prePost) '<' else '') + allParams.join(",") + (if(prePost) '>' else '');
            'public static function get_' + tcClass + getMeParams + '(t:' + usingType + ') {
      return '+ className +';
    }';
          };
          
          var getter = if (constraintArr.isSome() && constraintArr.extract().length > 0) { // we need a hash
            var constraints = switch (constraintArr) {
              case Some(v): v;
              case None: Scuts.macroError("assert");
            }
            //var constraintParams = constraints.mapWithIndex(function (c,i) return "arg" + i + ": ExprRequire<" + c + ">");
            var constraintParams = constraints.mapWithIndex(function (c,i) return "arg" + i + ": " + c );
            var constraintArgs = constraints.mapWithIndex(function (c,i) return "arg" + i);
            '
    static var hash:Hash<' + fullInstanceStr + '<' + constraints.map(function (c) return "Dynamic").join(",") + '>> = new Hash();
    
    public static function get <' + paramStrings.join(",") + '>(' + constraintParams.join(",") + ') {
      var id = ' + constraintArgs.map(function (x) return "Type.getClassName(Type.getClass(" + x + "))").join("+\"__\"+") + ';
      var val = hash.get(id);
      return if (val == null) {
        var v = new ' + fullInstanceStr + '(' + constraintArgs.join(",") + ');
        hash.set(id, v);
        v;
      } else {
        cast val;
      }
    }';
          } else if (paramStrings.length > 0){
            
            var dynamicParams = paramStrings.map(function (s) return "Dynamic");
            '
    private static var instance:' + fullInstanceStr + '<'+ dynamicParams.join(",") +'>;
    public static function get<'+ paramStrings.join(",") +'>():' + fullInstanceStr + '<' + paramStrings.join(",") + '> {
      if (instance == null) instance = new ' + fullInstanceStr + '();
      return cast instance;
    }';
          } else {
            '
    private static var instance:' + fullInstanceStr + ';
    public static function get() {
      if (instance == null) instance = new ' + fullInstanceStr + '();
      return instance;
    }';
          }
          
          var classStr = 'class ' + className + ' \n{\n
            \t' + getProviderClass + '\n
            \t' + getter + '\n}';
          
          var file = File.write(className + ".hx");
          file.writeString(classStr);
          file.close();
          var ret = Context.getType(className);
          // let's type it
          Context.typeof(Context.parse("{ var a:" + className + "; a; }", Context.currentPos()));
          return ret;
        }
        
      default:
        Scuts.macroError("Type must be TInst");
    }

    return Scuts.macroError("Cannot revolve Type");
    
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

