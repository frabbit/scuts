
package scuts.ht.classes;

import scuts.ht.core.Of;

interface ContraVariant<F> {

	public function contraMap <A,B>(x : F<A>, f:B->A):F<B>;

}