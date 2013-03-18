/**
 * @Author Heinz Hölzer
 */



package scuts.mcore.builder;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Position;
import scuts.Scuts;

import scuts.mcore.Check;
import scuts.mcore.Convert;
import scuts.mcore.Extract;
import scuts.mcore.Make;
import scuts.mcore.Modify;
import scuts.mcore.Print;
import scuts.mcore.Select;


typedef ED = ExprDef;
#end
/*
typedef Function = {
  var name : Null<String>;
  var args : Array<FunctionArg>;
  var ret : Null<ComplexType>;
  var expr : Expr;
}

typedef FunctionArg = {
  var name : String;
  var opt : Bool;
  var type : Null<ComplexType>;
  var value : Null<Expr>;
}
*/
using scuts.mcore.Query;
using scuts.Log;
using scuts.core.Arrays;
using scuts.core.Iterables;
using scuts.core.Iterators;
using scuts.core.Options;
using scuts.core.Predicate1Ext;
using scuts.core.Strings;
using scuts.core.Dynamics;
using scuts.core.Strings;


import scuts.CoreTypes;



class ShortLambda 
{

  public static function isPlaceHolder (e:Expr, reg:EReg):Bool{
    return Select
      .selectEConstCIdentValue(e)
      .filter(function (s) return reg.match(s))
      .isSome();
  
  }
  public static function isPlaceHolderWithType (e:Expr, reg:EReg):Bool{
    return Select
      .selectEConstCStringValue(e)
      .filter(function (s) return reg.match(s))
      .isSome();
  }
  
  static function placeHolderPattern () return ~/^[_]$/
  static function placeHolderWithTypePattern () return ~/^[_]:[A-Z][0-9a-zA-Z_<>]*$/
  static function numericPlaceHolderPattern () return ~/^[_][1-9]$/
  static function numericPlaceHolderWithTypePattern () return ~/^[_][1-9][:][A-Z][0-9a-zA-Z_<>]*$/
  
  
  
  //type(isPlaceHolder);
  public static function isSimplePlaceHolder  (x:Expr) { 
    return 
      (function (x) return isPlaceHolder(x, placeHolderPattern()))
      .or(function (x) return isPlaceHolderWithType(x, placeHolderWithTypePattern()))(x);
  }
  public static function isNumericPlaceHolder (x:Expr) { 
    return 
      (function (x) return isPlaceHolder(x, numericPlaceHolderPattern()))
      .or(function (x) return isPlaceHolderWithType(x, numericPlaceHolderWithTypePattern()))(x);
  }
  public static function modifySimplePlaceHolder (e:Expr, i:Int) {
    Modify.modifyEConstCIdentValue(e, function (_) return EConst(CIdent("_" + i)));
  }
  public static function modifySimplePlaceHolderWithType (e:Expr, i:Int) {
    Modify.modifyEConstCStringValue(e, function (s) {
      if (~/[_]:[A-Z][0-9a-zA-Z_<>]*/.match(s)) {
        return EConst(CIdent("_" + i));
      } else {
        return EConst(CString(s));
      }
    });
  }
  public static function modifyNumericPlaceHolderWithType (e:Expr, i:Int) {
    Modify.modifyEConstCStringValue(e, function (s) {
      var ereg = ~/[_]([1-9]):[A-Z][0-9a-zA-Z_<>]*/;
      return if (ereg.match(s)) {
        EConst(CIdent("_" + ereg.matched(1)));
      } else {
        EConst(CString(s));
      }
        
    });
  }
  
    
  public static function idToFunctionArg (s) {
    var parts = s.split(":");
    return { 
      name: parts[0],
      opt: false,
      type:parts.length > 1 ? Convert.stringToComplexType(parts[1]) : null,
      value:null
    }
  }
  
  public static function extractStringId (e:Expr):Option<String> {
    return switch (e.expr) {
      case EConst(c): switch (c) {
        case CIdent(i): Some(i);
        case CString(s):Some(s);
        default: None;
      }
      default: None;
    }
  }
  
  public static function getPlaceHolderIds (simplePlaceHolderExprs:Array<Option<Expr>>, numericPlaceHolderExprs:Array<Option<Expr>>) 
  {
    return if (simplePlaceHolderExprs.traced().size() > 0 && numericPlaceHolderExprs.traced().size() > 0) {
        Scuts.error("You can only use simple _ placeHolders or numeric ones like _1, _2... etc, but not both");
      } else if (simplePlaceHolderExprs.size() > 0) {
        // only simple underscore placeholders 
        simplePlaceHolderExprs
          .modifyWithIndex(modifySimplePlaceHolder)
          .modifyWithIndex(modifySimplePlaceHolderWithType); // modifies underscores to numeric underscores
        simplePlaceHolderExprs.select(Select.selectEConstConstant).select(Select.selectCIdentValue).values();
      } else {
        
        
          
        var placeHolderKeyGen = function (s:String) {
          var e = ~/^[_]([1-9])(:[A-Z][0-9a-zA-Z_<>]*)?$/;
          var m = e.match(s);
          
          return if (m) e.matched(1).toInt() else scuts.Scuts.error("Assert");
        }
        
        var placeHoldersWithType = numericPlaceHolderExprs
          .select(Select.selectEConstConstant).traced()
          .select(Select.selectCIdentValue).values();
          
          
        var placeHoldersWithoutType = numericPlaceHolderExprs
          .select(Select.selectEConstConstant)
          .select(Select.selectCStringValue).values();
        
        var allPlaceHolders = placeHoldersWithType.concat(placeHoldersWithoutType);
        var placeHoldersHash = allPlaceHolders.toIntHash(placeHolderKeyGen);
          
        trace(placeHoldersHash);
        // only numeric placeholders _1,_2 sorted
        var last = allPlaceHolders.maximumByOption(Strings.compare);
        
        // last contains _4 f.e.
        //var last = ordered.lastOption();
        var lastNum = last.flatMap(function (s) return Std.parseInt(s.charAt(1)).toOption());
        
        
        // fill the gaps between 0 and lastNum
        var res = switch (lastNum) {
          case Some(i): 
            (1...i+1).mapToArray(function (i:Int) return placeHoldersHash.exists(i) ? placeHoldersHash.get(i) : ("_" + i));
          case None: 
            [];
        }
        numericPlaceHolderExprs
          .modifyWithIndex(modifyNumericPlaceHolderWithType);
        trace(res);
        res;
      }
  }
  
  public static function make2 (arr:Array<Expr>) 
  {

    return if (Check.isEBinopAssign(arr[arr.length-1])) 
    {
      var lastExpr = arr.last();
      // split last expr at =
      var binopExprs = lastExpr.createQuery().filter(Check.isEBinopAssign).select(Select.selectEBinopExprs).values().firstOption();
        
      var leftAndRight = if (binopExprs.isSome()) binopExprs.value() else scuts.Scuts.error("Assign Operator expected");
      
      var allExprs = leftAndRight._2.createQuery().selectAllChildren();
        
      var simplePlaceHolderExprs = allExprs.filter(isSimplePlaceHolder);
      
      var numericPlaceHolderExprs = allExprs.filter(isNumericPlaceHolder);
        
      var placeHolderIds = getPlaceHolderIds(simplePlaceHolderExprs, numericPlaceHolderExprs);

      var args = arr
        .take(arr.size()-1)
        .createQuery()
          .select(Select.selectEConstCIdentValue)
          .values()
        .concat([extractStringId(leftAndRight._1).value()])
        .concat(placeHolderIds).map(idToFunctionArg);

      
      var res = {
        expr:EFunction(null, {
          args: args,
          ret: null,
          expr:{ expr:EReturn(leftAndRight._2), pos:leftAndRight._2.pos},
          params: []
        }), 
        pos: arr[0].pos
      }
      res;

    } else {
      var allExprs = arr[0].createQuery().selectAllChildren();
        
      var simplePlaceHolderExprs = allExprs.filter(isSimplePlaceHolder).traced();
      
      var numericPlaceHolderExprs = allExprs.filter(isNumericPlaceHolder).traced();
      
      var placeHolderIds = getPlaceHolderIds(simplePlaceHolderExprs, numericPlaceHolderExprs);
        
      var args = placeHolderIds.map(idToFunctionArg);
      {
        expr:EFunction(null, {
          args: args,
          ret: null,
          expr:{ expr:EReturn(arr[0]), pos:arr[0].pos},
          params: []
        }), 
        pos: arr[0].pos
      }
    }
  }
  
  private static function fillPlaceHolders (placeHolders:Array<String>) {
    
  }
  
  public static function make(arr:Array<Expr>):Expr 
  {
    return 
      if (arr.length == 1) {
        
        makeOneArgument(arr[0], []);
      }
      else makeMultiArguments(arr);
  }
  
  public static function makeMultiArguments(arr:Array<Expr>):Expr {
    var args = [];
    
    for (i in 0...arr.length - 1) {
      var a = arr[i];
      switch (a.expr) {
        case ED.EConst(c): switch (c) {
          case CIdent(s):
            args.push( { name: s, opt:false, type:null, value:null } );
          case CString(s):
            var variable = varFromString(s, a.pos);
            args.push( { name: variable.name, opt:false, type:variable.type, value:null });
          default: throw "Unexpected";
        }
        
                
        default: throw "Unexpected";
      }
    }
    return makeOneArgument(arr[arr.length-1], args);
  }
  
  
  
  public static function makeOneArgument(expr:Expr, otherArgs:Array<FunctionArg>) {
    
    var p = expr.pos,
      shortCutLambda = function (expr) {
        var args = [{ name: "_", opt:false, type:null, value:null }],
          fun = { ret:null, expr: { expr:makeFunctionBody(expr), pos:p }, args:args, params:[] };
        return ED.EFunction(null, fun);
      },
      def = switch (expr.expr) 
      {
        case ED.EBinop(op, e1, e2):
          
          if (op == OpAssign) switch (e1.expr) 
            {
            case ED.EConst(c): switch (c) 
              {
              case CIdent(s):
                var args = otherArgs.concat([{ name: s, opt:false, type:null, value:null }]),
                  fun = { ret:null, expr: { expr:makeFunctionBody(e2), pos:p }, args:args, params:[] };
                ED.EFunction(null, fun);
              case CString(s):
                var variable = varFromString(s, e1.pos),
                  args = otherArgs.concat([{ name: variable.name , opt:false, type: variable.type, value:null }]),
                  fun = { ret:null, expr: { expr:makeFunctionBody(e2), pos:p }, args:args, params:[] };
                ED.EFunction(null, fun);
              default: throw "Ident Expected for " + e1;
              }
            case ED.EBinop(op, varName, varType):
              if (op == OpBoolOr) switch (varName.expr) 
              {
                case ED.EConst(c): switch (c) 
                {
                  case CIdent(s):
                    switch (varType.expr) {
                      case ED.EConst(c):
                        switch (c) {
                          case CIdent(u):
                          default: throw "Unexpected";
                        }
                      default: throw "Unexpected";
                      
                    }
                    var args = otherArgs.concat([{ name: s, opt:false, type:null, value:null }]),
                      fun = { ret:null, expr: { expr:makeFunctionBody(e2), pos:p }, args:args, params:[] };
                    ED.EFunction(null, fun);
                  default: throw "Ident Expected for " + e1;
                }
                default: throw "Ident Expected for " + varName;
            
              } else throw "Ident Expected for " + e1;
              
            default: throw "Ident Expected for " + e1;
            };
          else 
            shortCutLambda(expr);
        
        default: 
          shortCutLambda(expr);
          
      };
    
    return { expr:def, pos: p };
  }
  
  static public function varFromString(varDef:String, pos:Position) 
  {
    if (varDef.indexOf(":") == -1) throw "Unexpected";
    var parts = varDef.split(":");
    return {
      name : parts[0],
      type : switch (Context.parse("{var test:" + parts[1] + ";}", pos).expr) {
        case EBlock(exprs):
          switch(exprs[0].expr) {
            case EVars(vars): vars[0].type;
            default: null;
          }
        default: null;
      }
    }
  }
  
  public static function makeFunctionBody (e:Expr) {
    return switch (e.expr) {
      case ED.EBlock(_): e.expr;
      default: EReturn(e);
    }
  }
  
  
}