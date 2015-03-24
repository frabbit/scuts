package scuts.ht.classes;


interface Collection<M>
{
  public function each <A>(of:M<A>, f:A->Void):Void;

  public function size <A>(of:M<A>):Int;

  public function insert <A>(of:M<A>, val:A):M<A>;

  public function append <A>(of:M<A>, val:A):M<A>;

  public function remove <A>(of:M<A>, f:A->Bool):M<A>;

  public function removeElem <A>(of:M<A>, elem:A, equals:Eq<A>):M<A>;
}


