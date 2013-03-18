
package scuts.ht.classes;

import scuts.ht.core.Of;

interface Cobind<W> extends Functor<W>{

	public function cobind <A,B>(x:Of<W,A>, f: Of<W,A> -> B): Of<W,B>;

}