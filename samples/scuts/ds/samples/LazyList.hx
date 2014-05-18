package scuts.ds.samples;

import haxe.Timer;

import scuts.core.Options;

import scuts.ds.LazyLists;


using scuts.ds.LazyLists;


private typedef LL = LazyLists;


class LazyList 
{
  
  
  public static function main() 
  {
    var a = LL.mkEmpty();
    var b = a.appendElem(5).appendElem(7).appendElem(9);
    var c = b.appendElem(2).filter(function (x) return x >= 7).drop(1).cons(1);
    for (i in b) {
      trace(i);
    }
    
    for (i in c) {
      trace(i);
    }
    
  }
  
}