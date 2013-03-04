package scuts1.classes;
import scuts1.core.Of;


interface Collection<M>
{
  public function each <A>(of:Of<M,A>, f:A->Void):Void;
  
  public function size <A>(of:Of<M,A>):Int;
  
  public function insert <A>(of:Of<M,A>, val:A):Of<M,A>;
  
  public function append <A>(of:Of<M,A>, val:A):Of<M,A>;
    
  public function remove <A>(of:Of<M,A>, f:A->Bool):Of<M,A>;
  
  public function removeElem <A>(of:Of<M,A>, elem:A, equals:Eq<A>):Of<M,A>;
}


