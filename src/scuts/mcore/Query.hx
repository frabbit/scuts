package scuts.mcore;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif ((display || macro))
#if false

import haxe.macro.Expr;
import scuts.core.extensions.DynamicExt;
import scuts.core.extensions.OptionExt;
import scuts.CoreTypes;

//using scuts.core.extensions.ArrayOptions;
using scuts.core.extensions.ArrayExt;
using scuts.core.extensions.IterableExt;
using scuts.core.extensions.DynamicExt;
using scuts.core.extensions.OptionExt;
//using scuts.core.extensions.;

typedef QSelection<U> = Array<Option<U>>;

using scuts.mcore.Query;

//using scuts.core.lifting.ArrayLifting;



typedef Node<T> = {
  current:T,
  parent:Option<Node<T>>
}

class ExprNodes {
  public static function getParent <T>(n:Node<T>) {
    return switch (n.parent) {
      case Some(v): return v;
      case None: throw "Expr has no parent";
    }
  }
  public static function hasParent <T>(n:Node<T>) {
    return n.parent.isSome();
  }
  
  public static function getRoot <T>(n:Node<T>) {
    return if (hasParent(n)) getRoot(getParent(n)) else n;
  }
}

class QueryNode {
  
  public static function parent <T>(w:QSelection<Node<T>>):QSelection<Node<T>> {
    return w.flatMap(function (e) return [e.parent]);
  }
  
  public static function select <T>(w:QSelection<Node<T>>, f:T->Option<T>):QSelection<Node<T>> {
    // lifting of f
    var lifted = function ( node:Node<T> ) {
      var res = f(node.current);
      return switch (res) {
        case Some(v): { parent:Some(node), current: v }.toArrayOption();
        case None: [];
      }
    }
    
    return w.flatMap(lifted);
  }
  
  
  
  public static function selectMultiple <T>(w:QSelection<Node<T>>, f:T->Array<T>):QSelection<Node<T>> {
    // lifting of f
    var lifted = function ( node:Node<T> ) {
      var res = f(node.current);
      return res.map(function (e) return if(e == null) None else Some({ parent:Some(node), current: e }));
    }
    return w.flatMap(lifted);
  }
  
  public static function filter <T>(w:QSelection<Node<T>>, f:T->Bool):QSelection<Node<T>> {
    return w.flatMap( function (node:Node<T>) {
      return if (f(node.current)) node.toArrayOption() else [];
    });
  }
  
  
}

class QueryArray {
  public static inline function createQuery <T>(c:Array<T>):QSelection<T> {
    return c.map(OptionExt.toOption);
  }
}

class Query {
  public static inline function createQuery <T>(c:T):QSelection<T> {
    return c.toArrayOption();
  }
  
  public static inline function createNodeQuery <T>(c:T):QSelection<Node<T>> {
    return if (c == null) [] 
    else { parent:None, current: c }.toArrayOption();
  }
  
  public static function firstValue <T>(w:QSelection<T>):Option<T> {
    return if (w.length > 0) w[0] else None;
  }
  
  public static function values <T>(w:QSelection<T>):Array<T> {
    var res = [];
    for (i in w) {
      switch (i) {
        case Some(v): res.push(v);
        case None:
      }
    }
    return res;
  }
  
  public static function filter <S>(w:QSelection<S>, f:S->Bool):QSelection<S> {
    return flatMap( w, (function (e:S) {
      return if (f(e)) e.toArrayOption() else [];
    }));
  }
  
  
  
  
  
  public static function select <S, T>(w:QSelection<S>, f:S->Option<T>):QSelection<T> {
    return w.flatMap(
      function (e) return switch (f(e)) 
      { 
        case Some(v): [Some(v)]; 
        case None: [];
      }
    );
  }
  
  public static function selectMultiple <S, T>(w:QSelection<S>, f:S->Array<T>):QSelection<T> {
    return w.flatMap(function (e) {
      var a = f(e);
      return a.filter(function (e) return e != null).map(function (e) return Some(e));
    });
  }
  
  public static function map < S, T > (w:QSelection<S>, f:S->T):QSelection<T>
  {
    return w.map(f);
  }
  
  public static function flatMap < S, T > (w:QSelection<S>, f:S->QSelection<T>):QSelection<T>
  {
    return w.flatMap(f);
  }
}



class QueryExpr
{
  static function createQuery (e:Expr):QSelection<Expr> {
    return Query.createQuery(e);
  }
  
  public static function position (w:QSelection<Expr>):QSelection<Position> 
  {
    return Query.select( w, (function (e:Expr) {
      return e.pos.toOption();
    }));
  }

  /**
   * Important, the function f should modify the original selected expressions. Thus it
   * modifies the whole expression tree as a whole. Take care when using this function.
   */
  public static function modify (w:QSelection<Expr>, f:Expr->Void):QSelection<Expr> {
    return w.flatMap( (function (e:Expr) {
      f(e);
      return e.toArrayOption();
    }));
  }
  
  public static function modifyWithIndex (w:QSelection<Expr>, f:Expr->Int->Void):QSelection<Expr> {
    return w.flatMapWithIndex ( (function (e:Expr, index:Int) {
      f(e,index);
      return e.toArrayOption();
    }));
  }
  
  
  public static function selectAllChildrenAsNodes (w:QSelection<Expr>):QSelection<Node<Expr>> {
    return Query.flatMap(w, function (eCurrent:Expr):QSelection<Node<Expr>> {
        
        var res1 = [eCurrent];
        var res2 = [];
        
        var childs = function (e:Expr) {
          res2 = res2.concat(e.toArrayOption().selectAllChildrenAsNodes().values());
        }
        
        switch (eCurrent.expr) {
          case EConst( c  ):
          case EArray( e1 , e2 ):
            childs(e1);
            childs(e2);
          case EBinop( op , e1 , e2 ):
            childs(e1);
            childs(e2);
          case EField( e , field ):
            childs(e);
          case EType( e , field ):
            childs(e);
          case EParenthesis( e ):
            childs(e);
          case EObjectDecl( fields ):
            for (f in fields) {
              childs(f.expr);
            }
          case EArrayDecl( values ):
            for (v in values) {
              childs(v);
            }
          case ECall( e , params ):
            childs(e);
          case ENew( t , params  ):
            for (p in params) {
              childs(p);
            }
          case EUnop( op , postFix , e ):
            childs(e);
          case EVars( vars ):
          case EFunction( name , f ):
            childs(f.expr);
            for (a in f.args) {
              childs(a.value);
            }

          case EBlock( exprs  ):
            for (e in exprs) {
              childs(e);
            }
            
           
          case EFor( it , expr ):
            childs(it);
            childs(expr);
            
          case EIn( e1 , e2 ):
            childs(e1);
            childs(e2);
          case EIf( econd , eif , eelse  ):
            childs(econd);
            childs(eif);
            childs(eelse);
          case EWhile( econd , e , normalWhile ):
            childs(econd);
            childs(e);
            
          case ESwitch( e , cases , edef ):
            childs(e);
            childs(edef);
            for (c in cases) {
              childs(c.expr);
            }
          case ETry( e , catches  ):
            childs(e);
            for (c in catches) {
              childs(c.expr);
            }
          case EReturn( e ):
            childs(e);
          case EBreak:
          case EContinue:
          case EUntyped( e ):
            childs(e);
          case EThrow( e ):
            childs(e);
          case ECast( e , t ):
            childs(e);
            
          case EDisplay( e , isCall ):
            childs(e);
          case EDisplayNew( t ):
          case ETernary( econd , eif , eelse ):
            childs(econd);
            childs(eif);
            childs(eelse);
          case ECheckType(e, t):
            childs(e);
        }
        // leafs
        var resA = res1.map(function (e) return Some( { parent : None, current: e } ));
        
        
        var resB = res2.map(function (node)
          {
            var val = switch (node.parent) {
              case None: { parent: Some({current:eCurrent, parent:None}), current:node.current };
              case Some(parent): node;
            }
            return Some(val);
          }
        );
        
        return resA.concat(resB);
        
    });
  }
    public static function selectAllChildren (w:QSelection<Expr>):QSelection<Expr> {
    return Query.flatMap(w, function (eCurrent:Expr):QSelection<Expr> {
        
        var res1 = [eCurrent];
        var res2 = [];
        
        var childs = function (e:Expr) {
          res2 = res2.concat(e.toArrayOption().selectAllChildren().values());
        }
        
        switch (eCurrent.expr) {
          case EConst( c  ):
          case EArray( e1 , e2 ):
            childs(e1);
            childs(e2);
          case EBinop( op , e1 , e2 ):
            childs(e1);
            childs(e2);
          case EField( e , field ):
            childs(e);
          case EType( e , field ):
            childs(e);
          case EParenthesis( e ):
            childs(e);
          case EObjectDecl( fields ):
            for (f in fields) {
              childs(f.expr);
            }
          case EArrayDecl( values ):
            for (v in values) {
              childs(v);
            }
          case ECall( e , params ):
            childs(e);
          case ENew( t , params  ):
            for (p in params) {
              childs(p);
            }
          case EUnop( op , postFix , e ):
            childs(e);
          case EVars( vars ):
          case EFunction( name , f ):
            childs(f.expr);
            for (a in f.args) {
              childs(a.value);
            }

          case EBlock( exprs  ):
            for (e in exprs) {
              childs(e);
            }
          case EFor( it , expr ):
            childs(it);
            childs(expr);
            
          case EIn( e1 , e2 ):
            childs(e1);
            childs(e2);
          case EIf( econd , eif , eelse  ):
            childs(econd);
            childs(eif);
            childs(eelse);
          case EWhile( econd , e , normalWhile ):
            childs(econd);
            childs(e);
            
          case ESwitch( e , cases , edef ):
            childs(e);
            childs(edef);
            for (c in cases) {
              childs(c.expr);
            }
          case ETry( e , catches  ):
            childs(e);
            for (c in catches) {
              childs(c.expr);
            }
          case EReturn( e ):
            childs(e);
          case EBreak:
          case EContinue:
          case EUntyped( e ):
            childs(e);
          case EThrow( e ):
            childs(e);
          case ECast( e , t ):
            childs(e);
            
          case EDisplay( e , isCall ):
            childs(e);
          case EDisplayNew( t ):
          case ETernary( econd , eif , eelse ):
            childs(econd);
            childs(eif);
            childs(eelse);
          case ECheckType(e, t):
            childs(e);
        }
        // leafs
        var resA = res1.map(function (e) return Some( e ));
        
        var resB = res2.map(function (e) return Some(e));
        
        return resA.concat(resB);
        
    });
    
  }
}

#end
#end