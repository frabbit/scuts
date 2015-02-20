package scuts.ht.instances.std;


@:callable abstract Kleisli<M,A,B>(A->M<B>) {

	public function new (x) this = x;

	public inline function run ():A->M<B> return this;

}
