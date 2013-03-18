package scuts.ht.syntax;
import scuts.ht.classes.Ord;
import scuts.ht.classes.OrdAbstract;
import scuts.core.Ordering;
import scuts.ht.syntax.EqBuilder;


class OrdBuilder
{

  /**
   * Helper Function to create various Ord instances from a function.
   */
  public static function create <T>(f:T->T->Ordering):Ord<T> return new OrdByFunc(f);
  public static function createByIntCompare <T>(f:T->T->Int):Ord<T> return new OrdByIntCompare(f);

}


private class OrdByFunc<T> extends OrdAbstract<T>
{
  var f : T->T->Ordering;
  
  public function new (f:T->T->Ordering) 
  {
    super(EqBuilder.create(function (a,b) return f(a,b) == EQ));
    this.f = f;
  }
  
  override public inline function compare (a:T, b:T) return f(a,b);
}

private class OrdByIntCompare<T> extends OrdAbstract<T>
{
  var f : T->T->Int;
  
  public function new (f:T->T->Int) 
  {
    super(EqBuilder.create(function (a,b) return f(a,b) == 0));
    this.f = f;
  }
  
  override public inline function compareInt (a:T, b:T) return f(a,b);
}