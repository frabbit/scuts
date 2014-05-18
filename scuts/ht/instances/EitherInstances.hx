
package scuts.ht.instances;

using scuts.core.Eithers;

import scuts.ht.classes.*;



class EitherInstances {

	@:implicit @:noUsing
	public static function monad<L>():Monad<Either<L,In>> return new EitherMonad();

	@:implicit @:noUsing
	public static function show<L,R>(showL:Show<L>, showR:Show<R>):Show<Either<L,R>> return new EitherShow(showL, showR);
}


class EitherFunctor<L> implements Functor<Either<L,In>>
{
	public function new () {}

	public function map<R,RR>(of:Either<L,R>, f:R->RR):Either<L,RR>
	{
		return Eithers.mapRight(of, f);
	}
}

class EitherMonad<L> extends EitherFunctor<L> implements Monad<Either<L,In>>
{

	public function flatMap<R,RR>(x:Either<L,R>, f: R->Either<L,RR>):Either<L,RR>
	{
		return Eithers.flatMapRight(x, f);
	}

	public function flatten<R>(x:Either<L,Either<L,R>>):Either<L,R>
	{
		return Eithers.flattenRight(x);
	}

	public function pure<A>(x:A):Either<L,A>
	{
		return Right(x);
	}
}

class EitherEq<A,B> extends EqAbstract<Either<A,B>>
{

	var eqA:Eq<A>;
	var eqB:Eq<B>;

	public function new (eqA:Eq<A>, eqB:Eq<B>)
	{
		this.eqA = eqA;
		this.eqB = eqB;
	}

	override public function eq (a:Either<A,B>, b:Either<A,B>):Bool
	{
		return Eithers.eq(a, b, eqA.eq, eqB.eq);
	}
}

class EitherSemigroup<L,R> implements Semigroup<Either<L,R>>
{
	private var semiL:Semigroup<L>;
	private var semiR:Semigroup<R>;

	public function new (semiL:Semigroup<L>, semiR:Semigroup<R>)
	{
		this.semiL = semiL;
		this.semiR = semiR;
	}

	public function append(a1:Either<L,R>, a2:Either<L,R>):Either<L,R>
	{
		return Eithers.append(a1, a2, semiL.append, semiR.append);
	}

}

class EitherShow<L,R> implements Show<Either<L,R>> {
	var showL:Show<L>;
	var showR:Show<R>;
	public function new (showL,showR) {
		this.showL = showL;
		this.showR = showR;
	}
	public function show (e:Either<L,R>) {
		return switch (e) {
			case Left(l): "Left(" + showL.show(l) + ")";
			case Right(r): "Right(" + showR.show(r) + ")";
		}
	}
}