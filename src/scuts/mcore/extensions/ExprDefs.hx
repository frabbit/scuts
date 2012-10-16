package scuts.mcore.extensions;

#if macro

import haxe.macro.Expr;
import scuts.core.Arrays;
import scuts.core.Bools;
import scuts.core.Strings;
import scuts.mcore.Make;

using scuts.core.Functions;

import scuts.mcore.extensions.Exprs;



class ExprDefs 
{
  public static inline function toExpr (def:ExprDef, ?pos:Position) return Make.expr(def, pos)
  
  public static inline function at (def:ExprDef, ?pos:Position) return toExpr(def, pos)
  
  public static function eq (a:ExprDef, b:ExprDef):Bool 
  {
    
    var eqStr = Strings.eq;
    var eeq = Exprs.eq;
    var eqComplex = ComplexTypes.eq;
    var eqTypePath = TypePaths.eq;
    var eqArrExpr = Arrays.eq.partial3(Exprs.eq);
    var eqBool = Bools.eq;
    var eqObjFields = Arrays.eq.partial3(AnonFields.eq);
    
    return switch (a) 
    {
      case EConst(c1):                       switch (b) { case EConst(c2):                       Constants.eq(c1, c2);     default: false; };   
      case EArray(e1a, e2a):                 switch (b) { case EArray(e1b, e2b):                 eeq(e1a, e1b) && eeq(e2a, e2b);     default: false; };
      case EBinop(op1, e1a, e2a):            switch (b) { case EBinop(op2, e1b, e2b):            Binops.eq(op1, op2) && eeq(e1a, e1b) && eeq(e2a, e2b); default: false; };
      case EField(e1, field1):               switch (b) { case EField(e2, field2):               eeq(e1,e2) && eqStr(field1, field2);     default: false; };
      case EType(e1, field1):                switch (b) { case EType(e2, field2):                eeq(e1,e2) && eqStr(field1, field2);     default: false; };
      case EParenthesis(e1):                 switch (b) { case EParenthesis(e2):                 eeq(e1,e2);     default: false; };
      case EObjectDecl(fields1):             switch (b) { case EObjectDecl(fields2):             eqObjFields(fields1, fields2); default: false; };
      case EArrayDecl(values1):              switch (b) { case EArrayDecl(values2):              eqArrExpr(values1, values2);  default: false; };
      case ECall(e1, params1):               switch (b) { case ECall(e2, params2):               eeq(e1,e2) && eqArrExpr(params1, params2);     default: false; };
      case ENew(t1, params1):                switch (b) { case ENew(t2, params2):                eqTypePath(t1,t2) && eqArrExpr(params1, params2);     default: false; };
      case EUnop(op1, postFix1, e1):         switch (b) { case EUnop(op2, postFix2, e2):         Unops.eq(op1, op2) && eqBool(postFix1,postFix2) && eeq(e1, e2);     default: false; };
      case EVars(vars1):                     switch (b) { case EVars(vars2):                     true;     default: false; };
      case EFunction(name1, f1):             switch (b) { case EFunction(name2, f2):             true;     default: false; };
      case EBlock(exprs1):                   switch (b) { case EBlock(exprs2):                   true;     default: false; };
      case EFor(it1, expr1):                 switch (b) { case EFor(it2, expr2):                 true;     default: false; };
      case EIn(e1a, e2a):                    switch (b) { case EIn(e1b, e2b):                    true;     default: false; };
      case EIf(econd1, eif1, eelse1):        switch (b) { case EIf(econd2, eif2, eelse2):        true;     default: false; };
      case EWhile(econd1, e1, normalWhile1): switch (b) { case EWhile(econd2, e2, normalWhile2): true;     default: false; }; 
      case ESwitch(e1, cases1, edef1):       switch (b) { case ESwitch(e2, cases2, edef2):       true;     default: false; }; 
      case ETry(e1, catches1):               switch (b) { case ETry(e2, catches2):               true;     default: false; }; 
      case EReturn(e1):                      switch (b) { case EReturn(e2):                      eeq(e1,e2);     default: false; }; 
      case EBreak:                           switch (b) { case EBreak:                           true;     default: false; }; 
      case EContinue:                        switch (b) { case EContinue:                        true;     default: false; }; 
      case EUntyped(e1):                     switch (b) { case EUntyped(e2):                     eeq(e1,e2);     default: false; }; 
      case EThrow(e1):                       switch (b) { case EThrow(e2):                       eeq(e1,e2);     default: false; }; 
      case ECast(e1, t1):                    switch (b) { case ECast(e2, t2):                    true;     default: false; }; 
      case EDisplayNew(t1):                  switch (b) { case EDisplayNew(t2):                  eqTypePath(t1,t2);     default: false; }; 
      case EDisplay(e1, isCall1):            switch (b) { case EDisplay(e2, isCall2):            true;     default: false; }; 
      case ETernary(econd1, eif1, eelse1):   switch (b) { case ETernary(econd2, eif2, eelse2):   true;     default: false; }; 
      case ECheckType(e1, t1):                 switch (b) { case ECheckType(e2, t2):             true;     default: false; };
    }
    
    
  }
  
}
#end