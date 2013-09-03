package scuts.ht.macros.implicits;

#if macro

import haxe.macro.Expr;

typedef ScopeExpr = { scope : Scope, expr : Expr }

typedef NamedExpr = { name: String, expr:Expr }

/**
 * Scopes provides access for implicit objects from different scopes.
 */
typedef Scopes = 
{
  locals : Array<Expr>,
  members : Array<NamedExpr>,
  statics : Array<NamedExpr>
}
/**
 * A Scope represents different contexts for implicit resolution
 */
enum Scope 
{
  Static; // Static Context
  Member; // Member Context
  Local; // Local Context
  Using; // Using Context
}

/**
 * An Error for Ambigious implicit Objects, only statics and members can be checked.
 */
enum AmbiguityError 
{
  MembersAmbiguous(arr:Array<NamedExpr>);
  StaticsAmbiguous(arr:Array<NamedExpr>);
}

#end