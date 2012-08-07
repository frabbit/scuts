package ;
import haxe.macro.Expr;

class Helper 
{
  @:macro public static function run (o:ExprOf<Dynamic>):Expr {
    
    
    return o;
  }
}

#if !macro

class Test 
{
  public static function main() 
  {
    var y = 0;
    Helper.run(var x = 0);
    trace(x);
  }
}

#end