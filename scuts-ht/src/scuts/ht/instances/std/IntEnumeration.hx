
package scuts.ht.instances.std;

import scuts.ht.classes.Enumeration;

using scuts.ds.LazyLists;

class IntEnumeration implements Enumeration<Int> {

  public function new () {}

  public inline function toEnum (i:Int):Int return i;
  
  public inline function fromEnum (i:Int):Int return i;
  
  public inline function pred (a:Int):Int return a-1;
  
  public inline function succ (a:Int):Int return a+1;
  
  public function enumFrom (a:Int):LazyList<Int>
  {
    return LazyLists.infinitePlusOne(a).map(toEnum);
  }
  
  public function enumFromTo (a:Int, b:Int):LazyList<Int> 
  {
    return LazyLists.interval(a, b).map(toEnum);
  }
  
  public function enumFromThenTo (a:Int, b:Int, c:Int):LazyList<Int> 
  {
    return LazyLists.interval(b, c)
      .cons(a)
      .map(toEnum);
  }
	

}