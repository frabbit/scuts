package ;
private typedef HxList<T> = List<T>;
private typedef StaxList<T> = haxe.data.collections.List<T>;
import haxe.FastList;
import haxe.Timer;
import hots.instances.IntShow;
import scuts.ds.List;

private typedef L = scuts.ds.Lists;
private typedef LL = scuts.ds.LazyLists;

using scuts.ds.Lists;
using scuts.ds.LazyLists;

class ListSample 
{
  public static function main() 
  {
    
    var la = L.mkOne(17);
    
    var lb = L.fromArray([1,2,3,4]);
    
    trace(L.concat( lb, la).toString(IntShow.get().show));
    
    trace(la);
    
    testA1();
    testA2();
    testA3();
    testA4();
    testA5();
    
    trace("-----------");
    testB1();
    testB2();
    testB3();
    testB4();
  }
  
  static public function testA1() 
  {
    var time = Timer.stamp();
    var myList = L.mkEmpty();
    for (i in 0...1000000) {
      myList = myList.cons(i);
    }
    
    var endTime = Timer.stamp() - time;
    trace(myList.size());
    trace("Time testA1 List: " + endTime);
  }
  
  static public function testA2() 
  {
    var time = Timer.stamp();
    var myList = new HxList();
    for (i in 0...1000000) {
      myList.push(i);
    }
    
    var endTime = Timer.stamp() - time;
    trace(myList.length);
    trace("Time testA2 HxList: " + endTime);
  }
  
  static public function testA3() 
  {
    var time = Timer.stamp();
    var myList = new FastList<Int>();
    for (i in 0...1000000) {
      myList.add(i);
    }
    
    var endTime = Timer.stamp() - time;
    trace("Time testA3 FastList: " + endTime);
  }
  
  static public function testA4() 
  {
    var time = Timer.stamp();
    var myList = LL.mkEmpty();
    for (i in 0...1000000) {
      myList = myList.cons(i);
    }
    
    var endTime = Timer.stamp() - time;
    trace(myList.size());
    trace("Time testA4 LazyList: " + endTime);
  }
  
  static public function testA5() 
  {
    var time = Timer.stamp();
    var myList = StaxList.create();
    for (i in 0...1000000) {
      myList = myList.cons(i);
    }
    
    
    var endTime = Timer.stamp() - time;
    trace(myList.size());
    trace("Time testA5 Stax: " + endTime);
  }
  
  static public function testB1() 
  {
    var myList = L.mkEmpty();
    for (i in 0...100000) {
      myList = myList.cons(i);
    }
    var time = Timer.stamp();
    myList.filter(function (i) return i % 2 == 0);
    var endTime = Timer.stamp() - time;
    trace("Time testB1 List: " + endTime);
  }
  
  static public function testB2() 
  {
    var myList = new HxList();
    for (i in 0...100000) {
      myList.push(i);
    }
    var time = Timer.stamp();
    myList.filter(function (i) return i % 2 == 0);
    
    var endTime = Timer.stamp() - time;
    trace("Time testB2 HxList: " + endTime);
  }
  
  static public function testB3() 
  {
    var myList = LL.mkEmpty();
    for (i in 0...100000) {
      myList = myList.cons(i);
    }
    var time = Timer.stamp();
    var filtered = myList.filter(function (i) return i % 2 == 0).take(100).filter(function (i) return i % 3 == 0);
    trace(filtered.toString(IntShow.get().show));
    var endTime = Timer.stamp() - time;
    trace("Time testB3 Lazy: " + endTime);
  }
  
  static public function testB4() 
  {
    var myList = StaxList.create();
    for (i in 0...100000) {
      myList = myList.cons(i);
    }
    var time = Timer.stamp();
    myList.filter(function (i) return i % 2 == 0);
    var endTime = Timer.stamp() - time;
    trace("Time testB4 Stax: " + endTime);
  }
  
  
  
}