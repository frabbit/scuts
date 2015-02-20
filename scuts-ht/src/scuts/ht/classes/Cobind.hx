
package scuts.ht.classes;

import scuts.ht.core.Of;

interface Cobind<W> extends Functor<W>{

	public function cobind <A,B>(x:W<A>, f: W<A> -> B): W<B>;

}