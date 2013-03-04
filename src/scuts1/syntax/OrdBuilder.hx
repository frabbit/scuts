package scuts1.syntax;
import scuts1.classes.Ord;
import scuts1.classes.OrdAbstract;
import scuts.core.Ordering;


class OrdBuilder
{

  /**
   * Helper Function to create various Ord instances from a function.
   */
  public static function create <T>(f:T->T->Ordering):Ord<T> return new OrdByFunc(f);

}


private class OrdByFunc<T> extends OrdAbstract<T>
{
  var f : T->T->Ordering;
  
  public function new (f:T->T->Ordering) 
  {
    super(Eqs.create(function (a,b) return f(a,b) == EQ));
    this.f = f;
  }
  
  override public inline function compare (a:T, b:T) return f(a,b);
}