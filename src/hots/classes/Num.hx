package hots.classes;
import hots.classes.Eq;
import hots.classes.Show;



interface Num<A> implements Eq<A>, implements Show<A>
{
  // functions
  public function plus (a:A, b:A):A;
  public function mul (a:A, b:A):A;
  
  public function minus (a:A, b:A):A;
  public function negate (a:A):A;
  public function abs (a:A):A;
  public function signum (a:A):A;
  public function fromInt (a:Int):A;
  
}
