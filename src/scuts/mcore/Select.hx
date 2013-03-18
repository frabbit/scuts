package scuts.mcore;

#if macro

import haxe.macro.Expr;
import scuts.core.Pair;

import scuts.core.Tuples;
using scuts.core.Options;
using scuts.core.Arrays;
using scuts.core.Dynamics;


class Select 
{
  
  // Constant selectors
  
  public static function selectCFloatValue (c:Constant):Option<Float> return switch (c) 
  {
    case CFloat(i): Std.parseFloat(i).toOption();
    case _ : None;
  }
    

  public static function selectCIntValue (c:Constant):Option<Int> return switch (c) 
  {
    case CInt(i): Std.parseInt(i).toOption();
    case _ : None;
  }
  
  public static function selectCStringValue (c:Constant):Option<String> return switch (c) 
  {
    case CString(s): s.toOption();
    case _ : None;
  }
    
  public static function selectCIdentValue (c:Constant):Option<String> return switch (c) 
  {
    case CIdent(s): s.toOption();
    case _ : None;
  }
  
  // EConst

  public static function selectEConstConstant (e:Expr):Option<Constant> return switch (e.expr) 
  {
    case EConst(c): c.toOption();
    case _ : None;
  }
  
  public static function selectEConstCStringValue (e:Expr):Option<String> 
  {
    return selectEConstConstant(e).flatMap(selectCStringValue);
  }
  
  public static function selectEConstCIdentValue (e:Expr):Option<String> 
  {
    return selectEConstConstant(e).flatMap(selectCIdentValue);
  }
  
   public static function selectEConstCIntValue (e:Expr):Option<Int> 
   {
    return selectEConstConstant(e).flatMap(selectCIntValue);
  }
  
  
  
  // EBlock
  
  
  public static function selectEBlockExprAt (e:Expr, i:Int):Option<Expr> return switch (e.expr) 
  {
    case EBlock(exprs) if (i >= 0 || i < exprs.length): exprs[i].toOption();
    case _ : None;
  }
  
  
  public static function selectEBlockExprs (e:Expr):Array<Expr> return switch (e.expr) 
  {
    case EBlock(exprs): exprs;
    case _ : [];
  }

  
  
  
  
  
  // EArray( e1 : Expr, e2 : Expr );
  
 
  public static function selectEArrayExprLeft (e:Expr):Option<Expr> 
  {
    return selectEArrayExpr(e, 0);
  }
  
  public static function selectEArrayExprRight (e:Expr, i:Int):Option<Expr> 
  {
    return selectEArrayExpr(e, 1);
  }
  
  public static function selectEArrayExprs (e:Expr):Option<Pair<Expr, Expr>> return switch (e.expr) 
  {
    case EArray(e1, e2): Pair.create(e1,e2).toOption();
    case _: None;
  }


  
  static function selectEArrayExpr (e:Expr, i:Int):Option<Expr> return switch (e.expr) 
  {
    case EArray(e, _) if (i == 0): e.toOption();
    case EArray(_, e) if (i == 1): e.toOption();
    case _: None;
  }

  
  // EBinop( op : Binop, e1 : Expr, e2 : Expr );
  
  public static function selectEBinopWithOpFilter (e:Expr, f:Binop -> Bool):Option<Expr> return switch (e.expr) 
  {
    case EBinop(op, _, _) if (f(op)): e.toOption();
    case _: None;
  }

  
  public static function selectEBinopExprsWithOpFilter (e:Expr, f:Binop -> Bool):Option<Tup2<Expr,Expr>> return switch (e.expr) 
  {
    case EBinop(op, e1, e2) if (f(op)): Tup2.create(e1, e2).toOption();
    case _ : None;
  }


  
  public static function selectEBinopLeftExpr (e:Expr):Option<Expr> 
  {
    var val = selectEBinopExprs(e);
    return val.isSome() ? val.extract()._1.toOption() : None;
  }
  public static function selectEBinopRightExpr (e:Expr):Option<Expr> 
  {
    var val = selectEBinopExprs(e);
    return val.isSome() ? val.extract()._2.toOption() : None;
  }
  

  public static function selectEBinopExprs (e:Expr):Option<Tup2<Expr,Expr>> return switch (e.expr) 
  {
    case EBinop(_, e1, e2): Tup2.create(e1, e2).toOption();
    case _ : None;
  }


  
  // EField( e : Expr, field : String );
  
  
  public static function selectEFieldExpr (e:Expr):Option<Expr> return switch (e.expr) 
  {
    case EField(e, _): e.toOption();
    case _: None;
  }
  
  public static function selectEFieldName (e:Expr):Option<String> return switch (e.expr) 
  {
    case EField(_, n): n.toOption();
    case _ : None;
  }
  
  
  public static function selectEFieldWhenFieldEquals (e:Expr, fieldName:String):Option<Expr> return switch (e.expr) 
  {
    case EField(_, f) if (f == fieldName): e.toOption();
    case _ : None;
  }


  
  // EType( e : Expr, field : String );
 
 
  

  // EParenthesis( e : Expr );
  
  
  // EObjectDecl( fields : Array<{ field : String, expr : Expr }> );
  
  
  public static function selectEObjectDeclFieldExpr (e:Expr, field:String):Option<Expr> return switch (e.expr) 
  {
    case EObjectDecl(fields):
      var res = None;
      for (f in fields) {
        if (f.field == field) res = f.expr.toOption();
        break;
      }
      res;
    case _ :
      None;
  }

  
  public static function selectEObjectDeclFieldExprs (e:Expr):Array<Expr> return switch (e.expr) 
  {
    case EObjectDecl(fields): [for (f in fields) f.expr];
    case _ : [];
  }

  
  //EArrayDecl( values : Array<Expr> );
  
 
  
  public static function selectEArrayDeclValueExprAt (e:Expr, i:Int):Option<Expr> return switch (e.expr) 
  {
    case EArrayDecl(values) if (i >= 0 || i < values.length): values[i].toOption();
    case _ : None;
  }

  
  public static function selectEArrayDeclValues (e:Expr):Option<Array<Expr>> return switch (e.expr) 
  {
    case EArrayDecl(values): Some(values);
    case _ : None;
  }


  
	//ECall( e : Expr, params : Array<Expr> );
  
  
  public static function selectECallExpr (e:Expr):Option<Expr> return switch (e.expr) 
  {
    case ECall(e,_): e.toOption();
    case _ : None;
  }


  
  public static function selectECallParamAt (e:Expr, i:Int):Option<Expr> return switch (e.expr) 
  {
    case ECall(_, params) if (i >= 0 || i < params.length): params[i].toOption();
    case _ : None;
  }


  
  public static function selectECallParams (e:Expr):Option<Array<Expr>> return switch (e.expr) 
  {
    case ECall(_, params): params.toOption();
    case _ : None;
  }

  
  public static function selectECall (e:Expr):Option<Tup2<Expr, Array<Expr>>> return switch (e.expr) 
  {
    case ECall(call , params): Tup2.create(call, params).toOption();
    case _ : None;
  }

  
	//ENew( t : TypePath, params : Array<Expr> );
  
  
  public static function selectENewParamAt (e:Expr, i:Int):Option<Expr> return switch (e.expr) 
  {
    case ENew(_, params) if (i >= 0 || i < params.length): params[i].toOption();
    case _ : None;
  }


  
  public static function selectENewParams (e:Expr):Array<Expr> return switch (e.expr) 
  {
    case ENew(_, params): params;
    case _ : [];
  }
  
  public static function selectENewTypePath (e:Expr):Option<TypePath> return switch (e.expr) 
  {
    case ENew(tp, _): tp.toOption();
    case _ : None;
  }
  
	//EUnop( op : Unop, postFix : Bool, e : Expr );
  
  
  public static function selectEUnopExpr (e:Expr):Option<Expr> return switch (e.expr) 
  {
    case EUnop(_, _, e1): e1.toOption();
    case _ : None;
  }
  
 
  
  //EVars( vars : Array<{ name : String, type : Null<ComplexType>, expr : Null<Expr> }> );
  public static function selectEVarsVars (e:Expr):Array<{ name : String, type : Null<ComplexType>, expr : Null<Expr> }> 
    return switch (e.expr) 
    {
      case EVars(vars): vars;
      case _ : [];
    }
  
  public static function selectEVarsVarAt (e:Expr, at:Int):Option<{ name : String, type : Null<ComplexType>, expr : Null<Expr> }> 
    return switch (e.expr) 
    {
      case EVars(vars): if (vars.length <= at) None else Some(vars[at]);
      case _ : None;
    }
  
  
  
  
  
	//EFunction( name : Null<String>, f : Function );
	
  public static function selectEFunctionNamedFunction (e:Expr):Option<Tup2<String, Function>> return switch (e.expr) 
  {
    case EFunction(name, f) if (name != null): Tup2.create(name, f).toOption();
    case _ : None;
  }
  
  public static function selectEFunctionName (e:Expr):Option<String> return switch (e.expr) 
  {
    case EFunction(name, _): name.nullToOption();
    case _ : None;
  }
  
  public static function selectEFunctionFunction (e:Expr):Option<Function> return switch (e.expr) 
  {
    case EFunction(_, f): f.toOption();
    case _ : None;
  }
  
  
	//EFor( it : Expr, expr : Expr );
  

  public static function selectEForIterator (e:Expr):Option<Expr> return switch (e.expr) 
  {
    case EFor(it, _): it.toOption();
    case _ : None;
  }
  
  public static function selectEForExpr (e:Expr):Option<Expr> return switch (e.expr) 
  {
    case EFor(_, expr): expr.toOption();
    case _ : None;
  }
  
	//EIn( e1 : Expr, e2 : Expr );
  
  
  public static function selectEInLeftExpr (e:Expr):Option<Expr> return switch (e.expr) 
  {
    case EIn(e1, _): e1.toOption();
    case _ : None;
  }
  
  public static function selectEInRightExpr (e:Expr):Option<Expr> return switch (e.expr) 
  {
    case EIn(_, e2): e2.toOption();
    case _ : None;
  }
	//EIf( econd : Expr, eif : Expr, eelse : Null<Expr> );

  
  public static function selectEIfCondition (e:Expr):Option<Expr> return switch (e.expr) 
  {
    case EIf(econd, _,_): econd.toOption();
    case _ : None;
  }
  
  public static function selectEIfIf (e:Expr):Option<Expr> return switch (e.expr) 
  {
    case EIf(_, eif,_): eif.toOption();
    case _ : None;
  }
  
  public static function selectEIfElse (e:Expr):Option<Expr> return switch (e.expr) 
  {
    case EIf(_, _,eelse): eelse.toOption();
    case _ : None;
  }
  
  
  
	//EWhile( econd : Expr, e : Expr, normalWhile : Bool );
  
  
  public static function selectEWhileCondition (e:Expr):Option<Expr> return switch (e.expr) 
  {
    case EWhile(econd, _,_): econd.toOption();
    case _ : None;
  }
  
  public static function selectEWhileBody (e:Expr):Option<Expr> return switch (e.expr) 
  {
    case EWhile(_, e,_): e.toOption();
    case _ : None;
  }
  
  public static function selectEReturn (e:Expr):Option<Expr> return switch (e.expr) 
  {
    case EReturn(e): e.toOption();
    case _ : None;
  }
  
}

#end