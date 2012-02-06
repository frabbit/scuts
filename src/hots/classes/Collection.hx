package hots.classes;
import hots.TC;
import hots.wrapper.Monadic;
import hots.wrapper.Mark;
import hots.wrapper.MVal;



using hots.extensions.Monadics;

interface Collection<M>, implements TC
{
  public function first <A>(a:MVal<M,A>):A;
  public function forEach <A>(a:MVal<M,A>, f:A->Void):Void;
}



class CollectionArray implements Collection<MarkArray>
{

  public function new () {}
  
  public function first <A>(a:MValArray<A>):A {
    var a = a.unbox();
    return a[0];
  }
  
  public function forEach <A>(a:MValArray<A>, f:A->Void):Void {
    for (e in a.unbox()) {
      f(e);
    }
  }
  
}