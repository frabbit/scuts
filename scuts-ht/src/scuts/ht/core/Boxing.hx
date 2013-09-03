
package scuts.ht.core;

class FunctionBoxing {
	public static inline function runArrow <A,B>(f:Of<Of<In->In, A>, B>):A->B
	{
		return f;	
	}
}
