package scuts.ht.instances.std;

import scuts.ht.core.Of;
import scuts.ht.core.In;
import scuts.core.Conts;
abstract ContOf<A,R>(Cont<A,R>) from Cont<A,R> to Cont<A,R> 
{

	private function new (c:Cont<A,R>) this = c;

	@:from static function fromOf(x:Of<Cont<In, R>, A>):ContOf<A,R> return new ContOf(cast x);
	
	@:to function toOf<A,R>():Of<Cont<In, R>, A> return new Of(cast this);	

	

	




}