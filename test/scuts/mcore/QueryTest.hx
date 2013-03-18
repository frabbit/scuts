package scuts.mcore;
import haxe.macro.Context;
import scuts.macro.Query;

using scuts.core.Map;
using scuts.macro.Query;
import scuts.core.macros.F;

using scuts.core.Objects;
class QueryTest 
{

  public function new() 
  {
    
  }
  /*
  public function test() 
  {
    
    var expr = Context.parse('
      { 
        if (a > 5) {
          if (b > 3) {
            a = 10;
          } else {
            a = 2;
          }
        } else {
          a = 5;
        }
      }
    ', Context.currentPos());
    
    var query = Query.createQuery(expr);
    var res = query.selectAllChildrenAsNodes()
    
        .filter(F.n(Check.isEBinop(_)))
        .select(Select.selectEBinopLeftExpr)
        .filter(F.n(Check.isConstIdent(_, "a")))
        .parent().parent()
        .values().map(function (n) return Print.expr(n.current, 0, "  "))
        ;
    trace(res);
    
    
   
    
    
     
    
  }
  */
}