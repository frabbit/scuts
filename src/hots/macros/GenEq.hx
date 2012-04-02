package hots.macros;

#if (macro || display)
import haxe.macro.Expr;
import haxe.macro.Type;
import neko.FileSystem;
import neko.io.File;
import scuts.core.types.Tup2;
import scuts.mcore.Context;
import scuts.mcore.extensions.ExprExt;
import scuts.mcore.extensions.TypeExt;
import scuts.mcore.Make;
import scuts.mcore.MContext;
import scuts.mcore.MType;
import scuts.mcore.Print;
import scuts.Scuts;

import scuts.core.types.Option;
import scuts.core.types.Either;

using scuts.core.extensions.ArrayExt;
using scuts.core.extensions.IteratorExt;
using scuts.core.extensions.OptionExt;
using scuts.core.extensions.EitherExt;
using scuts.mcore.extensions.ExprExt;
using scuts.core.extensions.HashExt;

enum GenError {
  GEInvalidType;
  ClassGenerationError;
  
}

typedef EqEnumData = {
  type : Type,
  enumType : EnumType,
  dependencies : Array<Type>,
  constructs: Array<EnumConstructor>
}



enum EnumConstructor {
  Simple(name:String, index:Int);
  Complex(name:String, index:Int, params:Array<{t:Type, opt:Bool}>);
}

#end
class GenEq 
{

  @:macro public static function forType (type:Expr):Type 
  {
    return forType1(type);
  }
  
  #if (macro || display)
  public static function forType1 (type:Expr):Type 
  {
    function handleTType (t:DefType, params) 
    {
      return 
        if (t.name.indexOf("#") == 0) 
          Context.getType2(t.pack, t.module, t.name.substr(1))
          .toRightConst(GEInvalidType)
          .flatMapRight(function (x) {
            
            return switch (x) 
            {
              case TEnum(et, params):  forEnum(x, et.get(), params);
              case TAnonymous(fields): forAnon(fields.get());
              default:                 Left(GEInvalidType);
            }
          })
        else
          Left(GEInvalidType);
    }
    
    return 
      Context.typeof(type)
      .toRightConst(GEInvalidType)
      .flatMapRight(function (t) {
        
        return switch (t) 
        {
          case TType(t, params): handleTType(t.get(), params);
          default:               Left(GEInvalidType);
        }
      })
      .getOrElse(handleError);
  }
  
  static function handleError (err:GenError) 
  {
    var msg = switch (err) {
      case GEInvalidType: "No Valid Type";
      case ClassGenerationError: "Cannot retrieve generated class";
    }
    return Scuts.macroError(msg);
  }
  
  // generates a Eq class for an Enum
  public static function forEnum(t:Type, en:EnumType, params:Array<Type>):Either<GenError, Type>
  {
    var data = getEnumEqData(t, en, params);
    
    var classData = buildEqEnumClass(data);
    
    var folder = MContext.getCacheFolder();
    
    var output = File.write(folder + "/" + classData._1 + ".hx", false);
    output.writeString(classData._2);
    output.close();
    
    
    
    return MContext.getType(classData._1)
    .toRightConst(ClassGenerationError);
  }
  
  static private function buildEqEnumClass(data:EqEnumData):Tup2<String, String>
  {
    
    var startVar:Int = "a".charCodeAt(0);
  
    
    var deps = data.dependencies;
    
    
    var instName = MType.getFullQualifiedTypeName(data.enumType);
    
    var className = instName + "Eq";
    
    var classNameValid = className.split(".").join("_");
    
    var depStrings = 
      data.dependencies
      .map(function (x) return Print.type(x, false, data.dependencies));
    
    var members = 
      depStrings
      .map(function (x) return "\tvar eq" + x + ":" + "hots.classes.Eq<" + x + ">;");
      
    var memberArgs = 
      depStrings
      .map(function (x) return "eq" + x);
      
    var memberAssigns = 
      depStrings
      .map(function (x) return "this.eq" + x + " = eq" + x);
    
    var classParamsStr = 
      (deps.length > 0 ? "<" : "")
      + depStrings.join(",")
      + (deps.length > 0 ? ">" : "");
      
    var constructArgsStr = 
      depStrings
      .map(function (x) return "eq" + x + ": hots.classes.Eq<" + x + ">")
      .join(",");
    
    var instType = instName + classParamsStr;
    var extendsType = "hots.classes.EqAbstract<" + instType +  ">";
    
    
    
    var constuctor = 
      "public function new (" + constructArgsStr + ") {\n\t\t" 
      + memberAssigns.join(";\n\t\t") + (memberAssigns.length > 0 ? ";" : "") + "\n\t}";
    
    var funcSignature = "override public function eq (x1:" + instType + ", x2: " + instType + "):Bool\n\t{\n\t\t";
    
    
    
    var equalsSwitch = "return switch (x1) {\n\t\t\t";
    
    var cases = data.constructs.map(function (x) {
      return switch (x) {
        case Simple(name, _): "case " + name + ": switch (x2) { case " + name + ": true; default: false; }";
        case Complex(name, _, params): 
          var varStart = "a".charCodeAt(0);
          var args1 = params.mapWithIndex(function (x, i) return String.fromCharCode(varStart + i) + "1");
          var args2 = params.mapWithIndex(function (x, i) return String.fromCharCode(varStart + i) + "2");
          var comps = params.mapWithIndex(function (x, i) {
            var type = x.t;
            var arg1 = String.fromCharCode(varStart + i) + "1";
            var arg2 = String.fromCharCode(varStart + i) + "2";
            return "hots.macros.TcContext.tc(" + arg1 + ", hots.classes.Eq, [" + memberArgs.join(",") + "]).eq(" + arg1 + "," + arg2 + ")";
          });
          var res = "case " + name + "(" + args1.join(",") + "): switch (x2) { case " + name + "(" + args2.join(",") + "): " + comps.join(" && ") + "; default: false;}";
          
          return res;
        
        //return "";
      }
    });
    var cl = "class " + classNameValid + classParamsStr + " extends " + extendsType + " {\n\n" + members.join("\n") + "\n\n\t" + constuctor + "\n\n\t" + funcSignature + equalsSwitch + cases.join("\n\t\t\t") + "\n\t\t}\n\t}\n}";
    
    
    return Tup2.create(classNameValid, cl);
    
  }
  
  
  
  static function getEnumEqData (t:Type, en:EnumType, params:Array<Type>):EqEnumData
  {

    var constructs = en.constructs
      .mapToArray(function (key, elem) {
        return switch (elem.type) {
          case TFun(args,_): Complex(elem.name, elem.index, args.map(function (a) return { t:a.t, opt:a.opt}));
          case TEnum(_, _): Simple(elem.name, elem.index);
          default: Scuts.unexpected();
            
        }
       
      });
    
    return {
      type : t,
      enumType : en,
      dependencies : params,
      constructs : constructs
    };
  }
  
  public static function forAnon(en:AnonType):Either<GenError, Type>
  {
    return Left(GEInvalidType);
    /*
    var constructs = en.constructs;
    
    var constructCases = constructs.keys()
      .map(function (key) {
        var elem = constructs.get(key);
        trace(elem.type);
        
        return key;
        
      });
      */
  }
  
  
  #end
  
}