
package scuts.ht.classes;


interface ContraVariant<F> {

	public function contraMap <A,B>(x : F<A>, f:B->A):F<B>;

}