/**
 * @Author Heinz HÃ¶lzer
 */

package scuts.mcore.builder;

typedef T = Type;

import haxe.macro.Expr.Position;
import scuts.mcore.Print;

import scuts.mcore.Make;
import scuts.time.StopWatch;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.Timer;


using scuts.core.Arrays;


private typedef EH = Make;

private typedef VarAndInput = 
  {
    varName : String,
    iterable : Expr,
    isIntIter : Bool,
    range: { min: Expr, max:Expr}
  }

private typedef VarsAndInputs = 
  {
    predicate: Expr,
    varsAndInputs: Array<VarAndInput>,
  }

class Comprehension
  {
    public static function flatMapWithTransformAi < T, S, U > (it:Iterable<T>, t:T->Iterable<S>, m:Int->Int->S->U):Array<U>
      {
        var res = [];
        var z1 = 0;
        for (i in it) 
          {
            var z2 = 0;
            for (j in t(i)) 
              {
                res.push(m(z1, z2, j));
                z2++;
              }
            z1++;
          }
        return res;
      }
    
    public static function makeLazy(compExprs:Array<Expr>):Expr
      {
        var output = compExprs.shift();
        var p = Context.currentPos();
        
        compExprs.reverse();
        
        var generators = compExprs.map( function (c) return extractVarsAndInputs(c) );
        
        var itCalls = createIterCalls(generators, p);
    
        var nextFnAssign = 
          {
            // function declaration
            var nextFnExpr = 
              {
                // temp -> variable assignments
                var tempBackAssigns = flatMapWithTransformAi(generators, 
                    function (g) return g.varsAndInputs,
                    function (i, i2, vi) {
                        var v = vi.varName;
                        var suffix = if (vi.isIntIter) "_iter - 1" else "";
                        return EH.varExpr("var " + v + " = __" + v + suffix);
                      }
                  );
                
                // build the iterator.next function
                var nextRetExpr = EH.mkExpr(EReturn(output));
            
                var assertCheckExpr = Context.parse('if (!__isSet) throw "assert next not available"', p);
            
                // function expression
                var funBlock = EH.block([assertCheckExpr].concat(tempBackAssigns).concat([nextRetExpr]));
                // function declaration
                EH.mkExpr(EFunction(null,  { args : [], ret:null, expr: funBlock, params:[] } ));
              }
              
            // function assignment
            { type:null, name:"__next", expr: nextFnExpr };
          };
        
        var allDecls = flatMapWithTransformAi(
            generators,
            function (g) return g.varsAndInputs,
            function (i, i2, vi) 
              {
                var v = vi.varName;
                var intIt = vi.isIntIter;
                return [
                  {
                    type:null, 
                    name:"__" + v + "_iter", 
                    expr: 
                      if (i > 0) 
                        if (intIt) EH.constInt("0") 
                        else EH.identNull()
                      else 
                        if (intIt) vi.range.min 
                        else itCalls[i][i2] 
                  }, { 
                    type:null, 
                    name:"__" + v, 
                    expr: EH.const(if (intIt) CInt("0") else CIdent("null")) 
                  }, { 
                    type:null, 
                    name:v, 
                    expr: EH.const(if (intIt) CInt("0") else CIdent("null")) 
                  }, { 
                    type:null, 
                    name:"__hasNext" + i, 
                    expr: EH.identNull()
                  }
                ];
              }
          )
          .flatten()
          .concat( [ { type:null, name:"__isSet", expr: EH.identTrue() } ] )
          .concat([ { type:null, name:"__o", expr: Context.parse("{ next:null, hasNext:null}", p) } ])
          .concat( [nextFnAssign]);
        
        var allDeclsExpr = EH.mkExpr(EVars(allDecls));
        
        var lastBackAssigns = [];
        
        var allNextBodys = generators.mapWithIndex (
          function ( g, i) 
            {
              var hasInner = i < generators.length - 1;
              var hasOuter = i > 0;
              
              var whileCond = createWhileCondition(g.varsAndInputs, p);
              
              var intIterIncrements = g.varsAndInputs
                .filter(function (vi) return vi.isIntIter)
                .map(
                  function (vi) return Context.parse("++__" + vi.varName + "_iter", p)
                );
              
              var tempAssigns = g.varsAndInputs
                .filter(function (vi) return !vi.isIntIter)
                .map(
                  function (vi) return EH.varExpr("__" + vi.varName + " = __" + vi.varName + "_iter.next()")
                );
              
              var curIncrements = g.varsAndInputs
                  .filter(function (vi) return vi.isIntIter)
                  .map(
                    function (vi) return Context.parse("__" + vi.varName + "_iter++", p)
                  );

              var nextBackAssigns = g.varsAndInputs.map(
                  function (vi) 
                    {
                      var v = vi.varName;
                      var suffix = if (vi.isIntIter) "_iter-1" else "";
                      return Context.parse("" + v + " = __" + v + suffix, p);
                    }
                );
              
              var tempBackAssigns = g.varsAndInputs.mapWithIndex( 
                  function ( vi, i) 
                    return Context.parse("" + vi.varName + " = __" + vi.varName + (if (vi.isIntIter) "_iter" else ""), p)
                ).concat(lastBackAssigns);
              
              
              lastBackAssigns = nextBackAssigns.concat(lastBackAssigns);
              
              var ifBody = 
                if (hasInner) generators[i + 1].varsAndInputs.mapWithIndex(
                    function (vi, j) 
                      {
                        var expr = if (vi.isIntIter) vi.range.min else itCalls[i+1][j];
                        return EH.assign(EH.mkIdentConstExpr("__" + vi.varName + "_iter"), expr);
                      }
                  ).concat([
                    Context.parse("__o.hasNext = __hasNext" + (i + 1), p),
                    Context.parse("return __hasNext" + (i + 1) + "()", p)
                  ])
                else 
                  [
                    Context.parse("__isSet = true", p),
                    Context.parse("return true", p)
                  ];
              
              var ifExprBlock = 
                if (g.predicate != null) [EH.ifExpr(g.predicate, EH.block(ifBody))] 
                else ifBody;
            
              var whileBody = 
                EH.block(
                  tempAssigns
                  .concat(tempBackAssigns)
                  .concat(curIncrements)
                  .concat(ifExprBlock)
                );
              
              var whileExpr = EH.mkExpr(EWhile(whileCond, whileBody, true));
              
              var allExprs = 
                if (i == 0) 
                  [
                    whileExpr, 
                    Context.parse("__isSet = false", p),
                    Context.parse("return false", p)
                  ]
                else 
                  [
                    whileExpr, 
                    Context.parse("__o.hasNext = __hasNext" + (i - 1), p),
                    Context.parse("return __hasNext" + (i - 1) + "()", p)
                  ];
              
              return 
                EH.mkExpr(EBinop(
                  OpAssign, 
                  EH.mkExpr(EConst(CIdent("__hasNext" + i))), 
                  EH.mkExpr(EFunction(null, {  args:[], ret:null, expr:EH.block(allExprs), params:[] } ))
                ));
            }
          );
        
        var allExprs = []
          .concat([allDeclsExpr])
          .concat(allNextBodys)
          .concat([
            Context.parse("__o.hasNext = __hasNext0", p),
            Context.parse("__o.next = __next",p),
            Context.parse("__o", p)
          ]);
          
        var res = EH.block(allExprs);
        //trace(Print.expr(res));
        return res;
      }
    
    /*
     * Generates the following Expression (with optimizations for Int-Intervals)
     *   {
        var __res = [];
        var __iter1 = input.iterator() || input;
        ...
        var __iterN = input.iterator() || input;
        
        while (__iter1.hasNext() && ... && __iterN.hasNext) {
          var var1 = __iter1.next();
          ...
          var varN = __iterN.next();
          var __var1 = var1;
          ...
          var __varN = varN;
          if (predicate) {
            var1 = __var1;
            ...
            varN = __varN;
            __res.push(output);
          }
        }
        __res;
      }
     */
    public static function make(compExprs:Array<Expr>,
                  newContainerGenerator:String->Expr, 
                  addElementGenerator:String->Expr->Expr):Expr
      {
        var output = compExprs.shift();
        
        compExprs.reverse();
        var generators = compExprs.map(
            function (c) return extractVarsAndInputs(c)
          );
        
        var p = Context.currentPos();
        
        
        var itCalls = createIterCalls(generators, p);
        
        var resultDeclExpr = newContainerGenerator("__res");
        
        var innerExprs = createInnerExprs(generators, addElementGenerator, output, [], 0, itCalls, []);
        
        var returnExpr = Context.parse("__res", p);
        
        return EH.mkExpr(EBlock([resultDeclExpr].concat(innerExprs).concat([returnExpr])));
      }
    
    static private function createInnerExprs (generators:Array<VarsAndInputs>, addElementGenerator:String->Expr->Expr, 
              output:Expr, assigns:Array<Expr>, depth:Int, itCalls:Array<Array<Expr>>, lastBackAssigns:Array<Expr>):Array<Expr> 
      {
        if (generators.length == 0 || itCalls.length == 0) throw "assert";
        
        var p = Context.currentPos();
        
        var t = generators.shift();
        
        var varsAndInputs = t.varsAndInputs;
        var predicate = t.predicate;
        
        var localItCalls = itCalls.shift();
        
        
        //var itDeclExpr = EH.mkExpr(EVars([ { type:null, name:"__it", expr: itCall } ]));
        
        var itDecls = createIterDeclarations(varsAndInputs, localItCalls, p);
      
        var whileCond = createWhileCondition(varsAndInputs, p);
        
        var assigns = createElementAssigns(varsAndInputs).concat(lastBackAssigns);

        var tempAssigns:Array<Expr> = varsAndInputs.filter(
          function (vi) return !vi.isIntIter).mapWithIndex(
          function ( vi, i) return EH.varExpr("var __" + vi.varName + " = " + vi.varName));
        

        var tempBackAssigns:Array<Expr> = varsAndInputs.mapWithIndex(
            function (vi, i) 
              {
                var v = vi.varName;
                var suffix = if (vi.isIntIter) "_iter" else "";
                return EH.varExpr("var " + v + " = __" + v + suffix);
              }
          ).concat(lastBackAssigns);
        
        var intIterIncrements = varsAndInputs.filter(function (vi) return vi.isIntIter).mapWithIndex( 
            function (vi, i) return Context.parse("++__" + vi.varName + "_iter", p)
          );
        
        var pushExpr = addElementGenerator("__res", output);

        var isLast = generators.length == 0;
        var nestedExprs = 
          if (!isLast) 
            createInnerExprs(generators, addElementGenerator, output, [], depth + 1, itCalls, tempBackAssigns)
          else [pushExpr];

        var whileExpr = 
          if (predicate != null) 
            {
              var ifExpr = EH.mkExpr(EIf(predicate, EH.block(tempBackAssigns.concat(nestedExprs)), null));
              EH.mkExpr(EWhile(whileCond, EH.block(assigns.concat(tempAssigns).concat([ifExpr]).concat(intIterIncrements)), true));
            } 
          else if (!isLast) 
            EH.mkExpr(EWhile(whileCond, EH.block(assigns.concat(tempAssigns).concat(nestedExprs.concat(intIterIncrements))), true));
          else 
            EH.mkExpr(EWhile(whileCond, EH.block(assigns.concat(nestedExprs.concat(intIterIncrements))), true));
        
        return [itDecls, whileExpr];
      }
    
    static private function createElementAssigns(varsAndInputs:Array<VarAndInput>) 
      return varsAndInputs.mapWithIndex(
        function (vi, i) 
          {
            var suffix = if (vi.isIntIter) "" else ".next()";
            return EH.varExpr("var " + vi.varName + " = __" + vi.varName + "_iter" + suffix);
          }
        )
    
    public static function makeNewArrayExpr (containerName:String) 
      return EH.varExpr("var "+ containerName +" = []")
    
    public static function makeArrayAppendExpr (containerName:String, elementExpr:Expr) 
      return EH.mkExpr(ECall(EH.mkExpr(EField(EH.mkExpr(EConst(CIdent(containerName))), "push")), [elementExpr]))

    
    public static function makeNewListExpr (containerName:String) 
      return EH.varExpr("var "+ containerName +" = new List()")

    
    public static function makeListAppendExpr (containerName:String, elementExpr:Expr) 
      return EH.mkExpr(ECall(EH.mkExpr(EField(EH.mkExpr(EConst(CIdent(containerName))), "add")), [elementExpr]))
    
    static function createIterCalls (generators:Array<VarsAndInputs>, p:Position):Array<Array<Expr>> 
      {
        var varDeclExpr = [];
        var iterCalls = [];
        
        for (i in generators) 
          {
            var innerIterCalls = [];
            var decls = varDeclExpr.copy();
            var curDecl = EH.mkExpr(EVars(decls));
            
            for (j in i.varsAndInputs) 
              {
                var block = EH.mkExpr(EBlock([curDecl].concat([j.iterable])));
                
                var iterType = Context.typeof(block);
                
                // let's check if its an iterator, if not assume it's an iterable (compile error if not)
                var itCall = 
                  if (hasNoArgMethod(iterType, "next") && hasNoArgMethod(iterType, "hasNext"))
                    j.iterable // it is an iterator
                  else
                    EH.mkExpr(ECall( EH.field(j.iterable, "iterator"), []));
                
                
                var nextCall = EH.mkExpr(ECall( { expr:EField(itCall, "next"), pos:p }, []));
                
                varDeclExpr.push( { type:null, name: j.varName, expr: nextCall } );
                innerIterCalls.push(itCall);
              }
            iterCalls.push(innerIterCalls);
          }
        return iterCalls;
      }
    
    
    
    static function createIterDeclarations (varsAndInputs:Array<VarAndInput>, itCalls:Array<Expr>, p:Position) 
      return EH.mkExpr(EVars(varsAndInputs.mapWithIndex(
        function (vi, i)
          return 
            { 
              type : null, 
              name : "__" + vi.varName + "_iter", 
              expr : 
                if (vi.isIntIter) vi.range.min 
                else itCalls[i]
            }
      )))

    
    static function createWhileCondition (varsAndInputs:Array<VarAndInput>, p:Position) 
      {
        var expr = null;
        var j = 0;
        
        for (vi in varsAndInputs) 
          {
            var cur = 
              if (vi.isIntIter) 
                EH.mkExpr(EBinop(OpLt, EH.mkExpr(EConst(CIdent("__" + vi.varName + "_iter"))), vi.range.max));
              else 
                Context.parse("__" + vi.varName + "_iter.hasNext()", p);
            expr = 
              if (expr == null) cur;
              else EH.mkExpr(EBinop(OpBoolAnd, expr, cur));
            j++;
          }
        return expr;
      }
    
    static inline private function hasNoArgMethod (t:Type, methodName:String, ?isStatic:Bool = false) 
      return scuts.mcore.Type.hasNoArgMethod(t, methodName, isStatic)

    static private function extractVarsAndInputs(varsAndInputs:Expr):VarsAndInputs
      return switch (varsAndInputs.expr) 
        {
          case EBinop(op, e1, e2): switch (op) 
            {
              case OpBoolOr: 
                {
                  predicate: e2,
                  varsAndInputs: extractVarsAndInputs1(e1)
                };
              default: 
                {
                  predicate: null,
                  varsAndInputs: extractVarsAndInputs1(varsAndInputs)
                };
            }
          default: 
            {
              predicate: null,
              varsAndInputs: extractVarsAndInputs1(varsAndInputs)
            };
        }

    static private function extractVarsAndInputs1(varsAndInputs:Expr):Array<VarAndInput>
      return switch (varsAndInputs.expr) 
        {
          case EBinop(op, e1, e2): switch (op) 
            {
              case OpLte:
                var varName = switch(e1.expr) 
                  {
                    case EConst(c): switch(c) 
                      {
                        case CIdent(s): s;
                        default: throw "Unexpected";
                      };
                      
                    default: throw "Unexpected";
                  }
                var oIter = removeIterParenthesis(e2);
                var isIntIter = isInterval(oIter);
                [{
                  varName : varName,
                  iterable : oIter,
                  isIntIter : isIntIter,
                  range: if (isIntIter) getIntervalRange(oIter) else null
                }];
              case OpInterval: switch (e1.expr) 
                {
                  case EBinop(op2, ex1, ex2): switch (op2) 
                    {
                      case OpLte:
                        var def = EBinop(OpLte, ex1, EH.mkExpr(EBinop(OpInterval, ex2, e2)));
                        extractVarsAndInputs1(EH.mkExpr(def));
                      default: throw "Unexpected";
                    };
                  default: throw "unexpected";
                }
              case OpBoolAnd:
                extractVarsAndInputs1(e1).concat(extractVarsAndInputs1(e2));
                
              default:
                throw "Unexpected Operator " + Std.string(op) + " e1: " + e1 + " e2: " + e2;
            }
          default: throw "Unexpected";
        }

    
    static private function removeIterParenthesis(arg:Expr) 
      return switch (arg.expr) 
        {
          case EParenthesis(e): removeIterParenthesis(e);
          default:arg;
        }
    
    static private function isInterval (e:Expr) 
      return switch (e.expr) 
        {
          case EBinop(op,_,_): op == OpInterval;
          default: false;
        }
      
    static private function getIntervalRange (e:Expr) 
      return switch (e.expr) 
        {
          case EBinop(op, min, max):   
            if (op == OpInterval) { min: min, max:max } 
            else throw "assert";
          default: throw "assert";
        }
  }