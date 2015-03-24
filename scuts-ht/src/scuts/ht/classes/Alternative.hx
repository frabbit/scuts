package scuts.ht.classes;



interface AlternativeArray<F> extends Applicative<F>
{
  /* one or more */
  public function some <A>(v:F<A>):F<Array<A>>;
  /* zero or more */
  public function many <A>(v:F<A>):F<Array<A>>;

  public function empty <A>():F<A>;

  public function append <A>():F<A>;

}