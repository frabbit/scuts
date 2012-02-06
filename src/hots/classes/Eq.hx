package hots.classes;
import hots.TC;

//@:typeClass
interface Eq<T> implements TC {
  public function eq (a:T, b:T):Bool;
  
  public function notEq (a:T, b:T):Bool;
}

