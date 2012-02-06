package hots.classes;



@:tcAbstract class EqAbstract<T> implements Eq<T>{
  public function eq (a:T, b:T):Bool {
    return !notEq(a, b);
  }
  
  public function notEq (a:T, b:T):Bool {
    return !eq(a, b);
  }
}


