package scuts.mcore.builder;


import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.Serializer;
import haxe.Unserializer;
import neko.FileSystem;
import neko.io.File;
import scuts.mcore.Check;
import scuts.mcore.Convert;
import scuts.mcore.MContext;
import scuts.mcore.ast.Functions;
import scuts.mcore.Extract;
import scuts.mcore.Print;
import scuts.mcore.Select;
import scuts.Scuts;
import scuts.core.Option;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Expr.Field;


typedef FuncHash = Hash<{field:Field, imports:Array<String>}>;

using scuts.core.ArrayOptions;
using scuts.core.Arrays;
using scuts.core.Iterables;
using scuts.core.Strings;
using scuts.mcore.ast.Fields;
using scuts.core.Options;
using scuts.mcore.ast.FieldTypes;
using scuts.mcore.ast.Functions;
using scuts.core.Dynamics;

enum Rule {
  RuleThis(at:Int);
  RuleSwitch(p1:Int, p2:Int);
}

enum ImportType {
  All(typeId:String, excludes:Hash<Bool>, pos:Position);
  Single(typeId:String, field:String, alias:Option<String>, rules:Array<Rule>, pos:Position);
  
}




class ProvideStaticsImpl
{

  static var registry: Hash<FuncHash> = new Hash();
  static var globalFunctions: Hash<{field:Field, imports:Array<String>}> = new Hash();
  
  @:macro public static function register ():Array<Field> {
    
    //#if !scutsStaticImports
    //return Context.getBuildFields();
    //#end
    
    var fields:Array<Field> = Context.getBuildFields();
    
    var type = Context.getLocalClass();
    

    var typePos = Context.getPosInfos(type.get().pos);
    
    var imports = MContext.getImports(typePos.file, typePos.min);
    
   
    
    var clName = type.get().name;
    var moduleName = type.get().module;
    
    var id = if (moduleName.endsWith("." + clName) || moduleName == clName) {
      moduleName;
    } else {
      moduleName + "." + clName;
    }
    
    
    
    
    var fHash = new Hash();
    
    registry.set(moduleName, fHash);
    
    for (f in fields) {
      if (f.isStatic() && f.isPublic() && f.isMethod()) {
        var globId = id + "." + f.name;
       
        var newField = f.flatCopy();
        
        var newMethod = f.getMethod().value().flatCopy();
        
        // we need fully qualified types, so convert argument types and return type to full qualified types
        //f.getMethod().map(function (f) { trace(Print.func(f)); return f;});
        
        
        newMethod.ret = if (newMethod.ret != null) {
          Convert.complexTypeToFullQualifiedComplexType(newMethod.ret);
        } else {
          null;
        }
        
        newMethod.args = newMethod.args.map(function (a) {
          return {
            name: a.name,
            opt: a.opt,
            type: Convert.complexTypeToFullQualifiedComplexType(a.type),
            value: a.value,
          }
          
        });
        
        
        var expr = "return " + globId + "(" + newMethod.args.map(function (a) return a.name).join(",") + ")";
        
        newMethod.expr = Context.parse(expr, newMethod.expr.pos);
        newField.kind = FFun(newMethod);  
        
        //newField.getMethod().map(function (f) { trace(Print.func(f)); return f;});
        
        
        fHash.set(newField.name, {field:newField, imports:imports});
        
        
        
        globalFunctions.set(globId, {field:newField, imports:imports});
      }
    }
    
    // don't return modified fields
    return Context.getBuildFields();
  }
  
  private static function extractRules(from:Expr):Array<Rule> 
  {
    var rules = [];
            
    function extractRules1 (start:Expr, rules:Array<Rule>) {
      var leftAndRight = Select.selectEBinopExprsWithOpFilter(start, function (op) return op == Binop.OpBoolAnd);
      if (leftAndRight.isSome()) {
        var t = leftAndRight.value();
        extractRules1(t._1, rules);
        extractRules1(t._2, rules);
      } else {
        // rule
        var leftAndRight = Select.selectEBinopExprsWithOpFilter(start, function (op) return op == Binop.OpGt);
        if (leftAndRight.isSome()) {
          var t = leftAndRight.value();
          var leftIdent = Select.selectEConstCIdentValue(t._1);
          var leftNum = Select.selectEConstCIntValue (t._1);
          var rightNum = Select.selectEConstCIntValue(t._2);
          
          if (leftIdent.isSome() && rightNum.isSome()) {
            rules.push(RuleThis(rightNum.value()));
          } else if (leftNum.isSome() && rightNum.isSome()) {
            rules.push(RuleSwitch(leftNum.value(), rightNum.value()));
          } else {
            scuts.mcoreError("Invalid");
          }
          
        } else {
          scuts.mcoreError("Invalid");
        }
       
      }
    }
    
    extractRules1(from, rules);
    
    return rules;
  }
  
  @:macro public static function importStatics (fieldsDef:Array<Expr>):Array<Field> {
    
    /*
    #if !scutsStaticImports
    #error "You need to add '-D scutsStaticImports' to use this feature"
    #end
    */
    var simpleFields = fieldsDef
      .filter(Check.isEField)
      .map(function (e) return {fullExpr:e, typeExpr:Select.selectEFieldExpr(e).value(), field:Select.selectEFieldName(e).value()})
      .map(function (v) {
        var typeId = exprToTypeId(v.typeExpr);
        return if (v.field == "_") All(typeId, new Hash(), v.fullExpr.pos) else Single(typeId, v.field, None, [], v.fullExpr.pos);
      });
    
    // all import expressions with guards like 
    // all methods with exclude filter: MyClass._ | [f1, f2] 
    // method as alias: MyClass.test | testAlias
    var guardedFields = fieldsDef
      .filter(function (e) return Check.isEBinopWithOpFilter(e, function (op) return op == Binop.OpOr))
      //.logMe("filtered1:")
      .map(function (e) return {left: Select.selectEBinopLeftExpr(e).value(), right: Select.selectEBinopRightExpr(e).value(), fullExpr:e})
      .filter(function (t) return Check.isEField(t.left))
      //.logMe("filtered2:")
      .map(function (t) {
        var typeExpr = Select.selectEFieldExpr(t.left).value();
        var field = Select.selectEFieldName(t.left).value();
        var typeId = exprToTypeId(typeExpr);
          
        return if (field == "_") {
          var excludes = Select.selectEArrayDeclValues(t.right)
            .map(function (a) return a.flatMap(function (e) return switch (Select.selectEConstCIdentValue(e)) { case Some(v): [v]; case None: [];}));
            //type(excludes);
            
            var h = new Hash();
            for (i in excludes.value()) {
              h.set(i, true);
            }
            All(typeId, h, t.fullExpr.pos);
        } else {
          var alias = Select.selectEConstCIdentValue(t.right);
          var aliasWithRules = Select.selectEArrayExprs(t.right);
          var onlyRules = Select.selectEArrayDeclValueExprAt(t.right, 0);
          
          if (alias.isSome()) {
            Single(typeId, field, alias, [], t.fullExpr.pos);
          } 
          else if (aliasWithRules.isSome()) {
            var tup = aliasWithRules.value();
            var alias = Select.selectEConstCIdentValue(tup._1);
            var rules = extractRules(tup._2);
            
            Single(typeId, field, alias, rules, t.fullExpr.pos);
          } 
          else if (onlyRules.isSome()) {
            var res = onlyRules
              .value();
              
            
            var rules = extractRules(res);
            
            
            Single(typeId, field, alias, rules, t.fullExpr.pos);
          }
          else {
            scuts.mcoreError("You have to provide an alias Name", t.right.pos);
          }
          
          
          
          
          //if (alias == 
        }
        
        
        
      });
    
    
    
    
    var fields = simpleFields.concat(guardedFields);
    
    var curFields:Array<Field> = Context.getBuildFields();
    var curFieldHash = { 
      var h = new Hash();
      curFields.forEach(function (f) {
        h.set(f.name, f);
      });
      h;
    }
    
    for (e in fields) {
      
      
      
      switch (e) {
        case All(typeId, excludes, pos):
          if (!registry.exists(typeId)) {
            scuts.mcoreError("Type " + typeId + " does not exist", pos);
          }
          var origFields = registry.get(typeId);
          
          for (o in origFields) {
            // skip excluded methods
            if (!excludes.exists(o.field.name)) { 
              addField(curFieldHash, curFields, typeId, o.field.name, None, [], pos);
            }
          }
        case Single(typeId, field, alias, rules, pos):
          addField(curFieldHash, curFields, typeId, field, alias, rules, pos);
        
      }
      
    }
    
    return curFields;
  }
  
  public static function exprToTypeId (e:Expr):String {
    var t = MContext.typeof(e);
    if (t.isNone()) scuts.mcoreError("Cannot determine the type of " + Print.expr(e) + "", e.pos);
    var typeId = switch (t.value()) {
      case TType(t, p): 
        var module = t.get().module;
        var name = { var n = t.get().name; if (n.startsWith("#")) n.substr(1) else n;};
        var id = if (module.endsWith("." + name) || module == name) module else module + "." + name;
        id;
      default: scuts.mcoreError("Type " + t + " is not supported", e.pos);
    }
    return typeId;
  }
  
  public static function addField (curFieldHash:Hash<Field>, fields:Array<Field>, typeId:String, field:String, alias:Option<String>, rules:Array<Rule>, pos:Position) {
    //trace(rules);
    
    if (curFieldHash.exists(field)) {
      var curType = Context.getLocalClass().get().name;
      scuts.mcoreError("Field '" + field + "' already exists on Type " + curType + " and cannot be imported", pos);
    }
    var id = typeId + "." + field;
    if (!globalFunctions.exists(id)) {
      scuts.mcoreError("Method " + id + " does not exist or is not registered via ProvideStatics", pos);
    }
    
    var f = globalFunctions.get(id).field;
    var imports = globalFunctions.get(id).imports;
    
    
    
      
    var newField = f.flatCopy();
    
    var funcCopy = newField.getMethod().map(Functions.flatCopy).value();
    
    newField.name = alias.isSome() ? alias.value() : field;
    
    newField.kind = FFun(funcCopy);
    
    newField;
      
    // apply rules
    var args = funcCopy.args;
    
    var argIds:Array<String> = args.map(function (a) return a.name);
    
    
    for (r in rules) {
      switch (r) {
        case RuleThis(i):
          
          
          var i = i -1;
          // remove static
          if (argIds.length <= i) scuts.mcoreError("Invalid argument position " + (i+1) + " for This Rule, function has only " + argIds.length + " args");
          
          // check if the type of 'this' is compatible to the argument
          var thisComplexType =  Convert.typeToComplexType(Context.getLocalType());
          var expectedType = args[i].type;
          //type(thisComplexType);
          //type(args[i].type);
          
          if (!scuts.mcore.Type.isSubtypeOf(thisComplexType, expectedType)) {
            scuts.mcoreError("Cannot apply this as " + (i+1) + " argument for " + typeId + "." + field + " because actual type " + Print.complexType(thisComplexType) + " is incompatible to expected type " + Print.complexType(expectedType), pos);
          }
          
          
          
          
          newField.access = newField.access.filter(function (x) return x != Access.AStatic);
          argIds = argIds.mapWithIndex(function (e,index) return if (index == i) "this" else e);
          args = args.removeElemAt(i);
          var expr:String = "return " + typeId + "." + field + "(" + argIds.join(",") + ")";
          //trace(expr);
          funcCopy.expr = Context.parse(expr, pos);
          
          
          
        case RuleSwitch(p1, p2):
      }
    }
    
   
    funcCopy.args = args; //.map(function (a) return { name:a.name, opt:a.opt, type:null, value:a.value});
    
    //trace("add field " + typeId + "." + field + " to " + Context.getLocalClass().get().name + "." + newField.name);
    
    
    //newField.getMethod().map(function (f) { trace(Print.func(f)); return f;});
    curFieldHash.set(newField.name, newField);
    fields.push(newField);
    
    
  }
  
  public static function addMeta (className:String) {
    Compiler.addMetadata("@:build(scuts.mcore.builder.ProvideStaticsImpl.register())", className);
  }
  
}

