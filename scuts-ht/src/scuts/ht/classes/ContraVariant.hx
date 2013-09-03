
package scuts.ht.classes;

import scuts.ht.core.Of;

interface ContraVariant<F> {

	public function contraMap <A,B>(x : Of<F,A>, f:B->A):Of<F,B>;

}