package scuts.ht.macros.implicits;

#if macro

// unwanted dependecies

import scuts.ht.macros.implicits.Data;
import scuts.mcore.Make;

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


import scuts.core.Tuples;
import scuts.core.Validations;
import scuts.core.Options;

using scuts.core.Arrays;


class Manager 
{
  static var uniqueLocalId = 0;
  
  /**
   * Creates a unique variable name.
   */
  static function createUniqueVarName () return "__implicit__" + (uniqueLocalId++);
  
  /**
   * Registry for local implicit objects.
   */
  static var localImplicits : Map<String, Array<{e:Expr, pos:{min:Int, max:Int, file:String}}>> = new Map();

  
  /**
   * Registers one or more local expressions as implicits for later used implicit resolution algorithms.
   */
  public static function registerLocals (exprs:Array<Expr>) 
  {
    var id = getLocalContextId();
    
    // the local implicits for this method
    var arr = localImplicits.get(id);
    // nothing stored currently
    if (arr == null) arr = [];
    
    // Stores the returning variable expressions
    var vars = [];
    
    for (e in exprs) 
    {
      var id = createUniqueVarName();
      // create expression out of variable name
      var idExpr = Make.constIdent(id);
      // store local var
      arr.push({ e: idExpr, pos: Context.getPosInfos(e.pos)});
      
      vars.push( { name : id, expr : e, type : null } );
    }
    // store the modified local variables
    localImplicits.set(id, arr);
    // returns something like var __implicit__1 = expr1, __implicit2 = expr2;
    return Make.vars(vars);
    
  }

  /**
   * Returns all local implicits for the given contextId.
   */
  public static function getLocalImplicits (localContextId:String) 
  {
    var all = localImplicits.get(localContextId);
    if (all == null) return [];
    
    var curPos = Context.getPosInfos(Context.currentPos());
    var filtered = [];
    
    for (a in all) 
    {
      if (a.pos.max < curPos.min) filtered.push(a.e);
    }
    
    return filtered.reversed();
  }
  
  /**
   * Extracts all implicit class fields from fields. The parameter baseExpr is usually 
   * an Expression representing this or the full qualified class. It is used to create 
   * an unambigous Expression to avoid Conflicts with local variables.
   * 
   * Examples for baseExpr: this, my.full.qualified.ClassA
   */
  public static function getImplicitsFromMeta (fields:Array<ClassField>, baseExpr:Expr):Array<NamedExpr> 
  {
    var res = [];
    for (f in fields) 
    {
      switch (f.kind) 
      {
        case FieldKind.FVar(_,_):
          if ( f.meta.has(":implicit")) 
          {
            var expr = Make.field(baseExpr, f.name);
            res.push( { name : f.name, expr: expr } );
          }
        default:
      }
    }
    return res;
  }
  
  /**
   * Returns all static implicits for the given class.
   */
  public static function getStaticImplicits (cl:ClassType):Array<NamedExpr> 
  {
    var clName = cl.name;
    var clExpr = { expr : EConst(CIdent(clName)), pos : Context.currentPos() };
    return getImplicitsFromMeta(cl.statics.get(), clExpr);
  }
  
  /**
   * Returns all member implicits for the given class.
   */
  public static function getMemberImplicits (cl:ClassType):Array<NamedExpr> 
  {
    return getImplicitsFromMeta(cl.fields.get(), macro this);
  }
  
  /**
   * Creates an id for the current context, based on current full qualified class and current method.
   */
  public static function getLocalContextId () 
  {
    var m = Std.string(Context.getLocalMethod());
    
    var cl = Context.getLocalClass().get();
    
    return cl.pack.join(".") + "." + cl.name + "." + m;
  }
  
  /**
   * Returns all implicits (locals, statics, members) for the current context.
   */
  public static function getImplicitsFromScope ():Scopes
  {
    var cl = Context.getLocalClass().get();

    var scopes = {
      locals  : getLocalImplicits(getLocalContextId()),
      statics : getStaticImplicits(cl),
      members : getMemberImplicits(cl)
    }
    return scopes;
  }
}

#end