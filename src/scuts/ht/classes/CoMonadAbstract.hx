package scuts.ht.classes;
import scuts.ht.classes.Cobind;
import scuts.ht.classes.Cojoin;
import scuts.ht.classes.Copure;
import scuts.ht.core.Of;
import scuts.Scuts;

using scuts.core.Functions;



 //class Comonad w where 
 // (=>>) :: w a -> (w a -> b) -> w b haskell extract :: w a -> a 
 
/*
 extend f  = fmap f . duplicate
  duplicate = extend id
 
  */
class ComonadAbstract<W> implements Comonad<W> 
{
  var _cojoin:Cojoin<W>;
  var _cobind:Cobind<W>;
  var _copure:Copure<W>;
  
  public function new (copure:Copure<W>, cojoin:Cojoin<W>, cobind:Cobind<W>) 
  {
    this._cojoin = cojoin;
    this._cobind = cobind;
    this._copure = copure;
  }

  public function cojoin <A>(f:Of<W,A>):Of<W, Of<W, A>> return _cojoin.cojoin(f);


  public function cobind <A,B>(x:Of<W,A>, f: Of<W,A> -> B): Of<W,B> return _cobind.cobind(x, f);
  
  
  
  // delegation of CoPointed
  
  public inline function copure <A>(v:A):Of<W,A> return _copure.copure(v);
  
  // delegation of Functor
  
  public inline function map<A,B>(val:Of<W,A>, f:A->B):Of<W,B> return _cojoin.map(val, f);
}