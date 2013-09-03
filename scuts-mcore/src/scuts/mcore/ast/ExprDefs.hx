package scuts.mcore.ast;

#if macro

import haxe.macro.Expr;
import scuts.core.Arrays;
import scuts.core.Bools;
import scuts.core.Strings;
import scuts.mcore.Make;

using scuts.core.Functions;

import scuts.mcore.ast.Exprs;



class ExprDefs 
{
  public static inline function toExpr (def:ExprDef, ?pos:Position) return Make.expr(def, pos);
  
  public static inline function at (def:ExprDef, ?pos:Position) return toExpr(def, pos);
  
  public static function eq (a:ExprDef, b:ExprDef, eqPos:Bool = true):Bool 
  {
    
    var eqStr = Strings.eq;
    var eeq = Exprs.eq.bind(_,_, eqPos);
    var eqComplex = ComplexTypes.eq;
    var eqTypePath = TypePaths.eq;
    var eqArrExpr = Arrays.eq.bind(_,_,eeq);
    var eqBool = Bools.eq;
    var eqObjFields = Arrays.eq.bind(_,_,AnonFields.eq.bind(_,_, eqPos));
    
    return switch [a,b] 
    {
      case [EMeta(_,c1),EMeta(_,c2)]:                             eeq(c1, c2);        
      case [EConst(c1),EConst(c2)]:                               Constants.eq(c1, c2);        
      case [EArray(e1a, e2a),EArray(e1b, e2b)]:                   eeq(e1a, e1b) && eeq(e2a, e2b);     
      case [EBinop(op1, e1a, e2a),EBinop(op2, e1b, e2b)]:         Binops.eq(op1, op2) && eeq(e1a, e1b) && eeq(e2a, e2b); 
      case [EField(e1, field1),EField(e2, field2)]:               eeq(e1,e2) && eqStr(field1, field2);     
      case [EParenthesis(e1), EParenthesis(e2)]:                  eeq(e1,e2);     
      case [EObjectDecl(fields1), EObjectDecl(fields2)]:          eqObjFields(fields1, fields2); 
      case [EArrayDecl(values1), EArrayDecl(values2)]:            eqArrExpr(values1, values2);  
      case [ECall(e1, params1), ECall(e2, params2)]:              eeq(e1,e2) && eqArrExpr(params1, params2);     
      case [ENew(t1, params1), ENew(t2, params2)]:                eqTypePath(t1,t2) && eqArrExpr(params1, params2);     
      case [EUnop(op1, postFix1, e1), EUnop(op2, postFix2, e2)]:  Unops.eq(op1, op2) && eqBool(postFix1,postFix2) && eeq(e1, e2);     
      case [EVars(_),EVars(_)]:                                   true;     
      case [EFunction(_,_),EFunction(_, _)]:                      true;     
      case [EBlock(_),EBlock(_)]:                                 true;     
      case [EFor(_, _),EFor(_, _)]:                               true;     
      case [EIn(_, _),EIn(_, _)]:                                 true;     
      case [EIf(_, _, _), EIf(_, _, _)]:                          true;     
      case [EWhile(_, _, _), EWhile(_, _, _)]:                    true;      
      case [ESwitch(_, _, _),ESwitch(_, _, _)]:                   true;      
      case [ETry(_, _),ETry(_, _)]:                               true;      
      case [EReturn(e1),EReturn(e2)]:                             eeq(e1,e2);      
      case [EBreak,EBreak]:                                       true;      
      case [EContinue,EContinue]:                                 true;      
      case [EUntyped(e1),EUntyped(e2)]:                           eeq(e1,e2);      
      case [EThrow(e1),EThrow(e2)]:                               eeq(e1,e2);      
      case [ECast(_, _),ECast(_, _)]:                             true;      
      case [EDisplayNew(t1),EDisplayNew(t2)]:                     eqTypePath(t1,t2);      
      case [EDisplay(_, _),EDisplay(_, _)]:                       true;      
      case [ETernary(_, _, _),ETernary(_, _, _)]:                 true;      
      case [ECheckType(_, _),ECheckType(_, _)]:                   true;     
      case _ : false;
    }
    
    
  }
  
}
#end