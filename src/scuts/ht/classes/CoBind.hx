
package scuts.ht.classes;

interface CoBind<F> {

	public function coBind <A,B>(x:Of<F,A>, f: Of<F,A> -> B): Of<F,B>;

}