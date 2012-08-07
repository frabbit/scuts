package hots.instances;

using scuts.core.extensions.Functions;
import hots.classes.SemigroupAbstract;

class EndoSemigroup<T> extends SemigroupAbstract<T->T>
{
  public function new () {}
  
  override public function append (a:T->T, b:T->T):T->T 
  {
    return a.compose(b);
  }
  
}
