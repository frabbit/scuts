package scuts1.classes;
import scuts1.core.Of;
import scuts.Scuts;



interface Plus<M>
{
  public function plus <A>(a:Of<M,A>, b:Of<M,A>):Of<M,A>;
}