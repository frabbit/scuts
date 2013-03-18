package scuts.ht.macros.implicits;

#if macro
// unwanted dependecies

import scuts.mcore.ast.Exprs;
import scuts.mcore.ast.Types;
import scuts.mcore.Print;
import scuts.core.debug.Assert;
import scuts.Scuts;
import haxe.CallStack;

import haxe.Log;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.PosInfos;
import scuts.ht.macros.implicits.Data;

import scuts.core.Tuples;

import scuts.ht.macros.implicits.Data;

using scuts.core.Arrays;
using scuts.core.Strings;
using scuts.core.Validations;
using scuts.core.Options;
using scuts.core.Functions;

class Tools 
{
  /**
   * Returns true if the expression e can be typed and it's type is not unknown, which
   * is called an untyped monomorph in the AST.
   */
  public static function exprTypeableAndTypeIsMono (e:Expr) return switch (getType(e)) 
  {
    case Some(t): typeIsMono(t);
    case None:    false;
  }
  
  /**
   * Returns true if the type t is unknown, which
   * is called an untyped monomorph in the AST.
   */
  public static function typeIsMono (t:Type) return switch (t) 
  {
    case TMono(_): true;
    default:       false;
  }
  
  public static function getTypeOfRequired (required:Expr) 
  {
    return Context.typeof(required);
  }
  
  /**
   * Prints a pretty representation of the type of expression e.
   */
  public static function printTypeOfExpr (e:Expr, ?msg:String, ?pos:PosInfos) 
  {
    if (msg == null) msg = "";
    switch (getType(e)) 
    {
      case Some(x): Log.trace(msg + ":" + prettyType(x), pos);
      case None: Log.trace("cannot type the expression " + prettyExpr(e), pos);
    }
  }
  
  /**
   * Prints a pretty representation of all types of the expressions in exprs.
   */
  public static function printTypeOfExprs (exprs:Array<Expr>, ?msg:String, ?pos:PosInfos) 
  {
    if (msg == null) msg = "";
    var res = exprs.map(function (x) return prettyTypeOfExpr(x));
    trace(msg + ":" + res.join(","), pos);
  }
  
  /**
   * Returns a pretty String representation of expression e.
   */
  public static function prettyExpr (x:Expr) 
  {
    var first = Print.expr(x);
    return first.split("scuts.ht.macros.Implicits.ImplicitsHelper.").join("_").split("scuts.ht.syntax.").join("scuts.ht.ext.");
  }
  
  /**
   * Prints a pretty representation of the expression e.
   */
  public static function printExpr (x:Expr, ?msg:String, ?pos:PosInfos) 
  {
    if (msg == null) msg = "";
    trace(msg + ":" + prettyExpr(x), pos);
  }

  /**
   * Returns a pretty string representation of all expressions in exprs.
   */
  public static function printExprs (x:Array<Expr>, ?msg:String, ?pos:PosInfos) 
  {
    if (msg == null) msg = "";
    trace(msg + ":" + Arrays.map(x, function (r) return prettyExpr(r)).join(","), pos);
  }

  /**
   * Returns a pretty String representation of type of expression e.
   */
  public static function prettyTypeOfExpr (e:Expr) return switch (getType(e)) 
  {
    case Some(x): prettyType(x);
    case None: "(Cannot Type Expression)";
  }

  /**
   * Prints a pretty representation of the type t.
   */
  public static function printType (t:Type, ?msg:String, ?pos:PosInfos) 
  {
    if (msg == null) msg = "";
    trace(msg + ":" + prettyType(t), pos);
  }
  
  /**
   * Returns a pretty String representation of the type t.
   */
  public static function prettyType (t:Type) 
  {
    var first = Print.type(t, true);
    var pretty = first
      .split("scuts.ht.core.Of").join("Of")
      .split("scuts.ht.core.In").join("In")
      .split("StdTypes.").join("")
      .split(Print.UNKNOWN_T_MONO).join("Unknown");
    
    return "( " + pretty + " )";
  }
  
  /**
   * Checks if the expression e is typeable by the compiler.
   */
  public static function isTypeable (e:Expr) 
  {
    return try { Context.typeof(e); true; } catch (e:Error) false;
  }
  
  /**
   * Checks if the type of expression e is compatible to the type of to.
   */
  public static function isCompatible (e:Expr, to:Expr) 
  {
    var helper = Resolver.helper;
    return try { Context.typeof(macro $helper.typeAsParam($to)($e)); true; } catch (e:Error) false;
  }
  
  /**
   * Returns the type of expression e as an Option. 
   * Some if e is typeable, None otherwise.
   */
  public static function getType (e:Expr):Option<Type> 
  {
    return try Some(Context.typeof(e)) catch (e:Error)  None;
  }
}

#end