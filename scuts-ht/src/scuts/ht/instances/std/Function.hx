package scuts.ht.instances.std;

@:callable abstract Function<A,B> (A->B) {
	inline public function new (x:A->B) this = x;
	inline public function run ():A->B return this;
}