package scuts.ht.macros.generators;

#if false

#if macro
import scuts.ht.macros.generators.GenError;
import haxe.macro.Expr;
import haxe.macro.Type;
import neko.FileSystem;
import neko.io.File;
import scuts.core.Tup2;
import scuts.mcore.Context;
import scuts.mcore.ast.Exprs;
import scuts.mcore.ast.Types;
import scuts.mcore.Make;
import scuts.mcore.MContext;
import scuts.mcore.MType;
import scuts.mcore.Print;
import scuts.Scuts;

import scuts.core.Option;
import scuts.core.Either;

using scuts.core.Arrays;
using scuts.core.Iterators;
using scuts.core.Options;
using scuts.core.Eithers;
using scuts.mcore.ast.Exprs;
using scuts.core.Hashs;

#end

private typedef ClassData = {
  type : Type,
  enumType : EnumType,
  dependencies : Array<Type>,
  constructs: Array<ConstructorData>
}



private enum ConstructorData {
  Simple(name:String, index:Int);
  Complex(name:String, index:Int, params:Array<{t:Type, opt:Bool}>);
}

class GenEqEnum 
{

  // generates a Eq class for an Enum
  public static function build(t:Type, en:EnumType, params:Array<Type>):Either<GenError, Type>
  {
    
    var data = getClassData(t, en, params);
    
    var classData = buildClass(data);
    
    var folder = MContext.getCacheFolder();
    
    var output = File.write(folder + "/" + classData._1 + ".hx", false);
    output.writeString(classData._2);
    output.close();
    
    
    
    return MContext.getType(classData._1)
    .toRightConst(ClassGenerationError);
  }
  
  static private function buildClass(data:ClassData):Tup2<String, String>
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
      .map(function (x) return "\tvar eq" + x + ":" + "scuts.ht.classes.Eq<" + x + ">;");
      
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
      .map(function (x) return "eq" + x + ": scuts.ht.classes.Eq<" + x + ">")
      .join(",");
    
    var instType = instName + classParamsStr;
    var extendsType = "scuts.ht.classes.EqAbstract<" + instType +  ">";
    
    
    
    var constuctor = 
      "public function new (" + constructArgsStr + ") {\n\t\t" 
      + memberAssigns.join(";\n\t\t") + (memberAssigns.length > 0 ? ";" : "") + "\n\t}";
    
    var funcSignature = "override public function eq (x1:" + instType + ", x2: " + instType + "):Bool\n\t{\n\t\t";
    
    
    
    var equalsSwitch = "return switch (x1) {\n\t\t\t";
    
    function createCases (x:ConstructorData) 
    {
      return switch (x) {
        case Simple(name, _): "case " + name + ": switch (x2) { case " + name + ": true; default: false; }";
        case Complex(name, _, params): 
          var varStart = "a".charCodeAt(0);
          var args1 = params.mapWithIndex(function (x, i) return String.fromCharCode(varStart + i) + "1");
          var args2 = params.mapWithIndex(function (x, i) return String.fromCharCode(varStart + i) + "2");
          
          function createExpr (x:{t:Type, opt:Bool}, i:Int) {
            var type = x.t;
            var arg1 = String.fromCharCode(varStart + i) + "1";
            var arg2 = String.fromCharCode(varStart + i) + "2";
            return "scuts.ht.macros.Resolver.tc(" + arg1 + ", scuts.ht.classes.Eq, [" + memberArgs.join(",") + "]).eq(" + arg1 + "," + arg2 + ")";
          }
          
          var comps = params.mapWithIndex(createExpr);
          var res = "case " + name + "(" + args1.join(",") + "): switch (x2)"
          + " { case " + name + "(" + args2.join(",") + "): " + comps.join(" && ") + "; default: false;}";
          
          res;
        
        //return "";
      }
    }
    
    var cases = data.constructs.map(createCases);
    var cl = "class " + classNameValid + classParamsStr + " extends " + extendsType + " {\n\n" 
      + members.join("\n") + "\n\n\t" + constuctor + "\n\n\t" 
      + funcSignature + equalsSwitch + cases.join("\n\t\t\t") + "\n\t\t}\n\t}\n}";
    
    
    return Tup2.create(classNameValid, cl);
    
  }
  
  
  
  static function getClassData (t:Type, en:EnumType, params:Array<Type>):ClassData
  {
    function toConstructorData (key, elem) return switch (elem.type) 
    {
      case TFun(args,_): 
        Complex(elem.name, elem.index, args.map(function (a) return { t:a.t, opt:a.opt}));
      case TEnum(_, _): 
        Simple(elem.name, elem.index);
      default: Scuts.unexpected();
    }
    
    var constructs = en.constructs.mapToArray(toConstructorData);
    
    return {
      type : t,
      enumType : en,
      dependencies : params,
      constructs : constructs
    };
  }
  
}

#end