package scuts.core;

import haxe.ds.IntMap;
import haxe.ds.StringMap;
import scuts.core.Tuples;

using scuts.core.Options;
using scuts.core.Dynamics;


class StringMaps {

  public static function mapElems<A,B>(h:StringMap<A>, f : A -> B):StringMap<B>
  {
    return Maps.mapElems(h, f, function () return new StringMap());
  }

  public static function mapElemsWithKeys<A,B>(h:StringMap<A>, f : String -> A -> B):StringMap<B>
  {
    return Maps.mapElemsWithKeys(h, f, function () return new StringMap());
  }
}

class IntMaps {

  public static function mapElems<A,B>(h:IntMap<A>, f : A -> B):IntMap<B>
  {
    return Maps.mapElems(h, f, function () return new IntMap());
  }
  public static function mapElemsWithKeys<A,B>(h:IntMap<A>, f : Int -> A -> B):IntMap<B>
  {
    return Maps.mapElemsWithKeys(h, f, function () return new IntMap());
  }
}

class Maps 
{

  public static function each<A,B>(m:Map<A, B>, f : A -> B, f:A->B->Void):Void
  {
    for (k in m.keys()) {
      var val = m.get(k);
      f(k, val);
    }
  }

  public static function mapKeys<A,B,C>(h:Map<A, B>, f : A -> C, createMap:Void->Map<C,B>):Map<C,B>
  {
    var res = createMap();
    for (k in h.keys()) {
      var val = h.get(k);
      res.set(f(k), val); 
    }
    return res;
  }

  @:noUsing public static function mapElems<A,B,C>(h:Map<A, B>, f : B -> C, createMap:Void->Map<A,C>):Map<A,C>
  {
    var res = createMap();
    for (k in h.keys()) {
      var val = h.get(k);
      res.set(k, f(val)); 
    }
    return res;
  }

  @:noUsing public static function mapElemsWithKeys<A,B,C>(h:Map<A, B>, f : A -> B -> C, createMap:Void->Map<A,C>):Map<A,C>
  {
    var res = createMap();
    for (k in h.keys()) {
      var val = h.get(k);
      res.set(k, f(k, val)); 
    }
    return res;
  }

  @:noUsing public static function map<A,B,C,D>(h:Map<A, B>, f : A -> B -> Tup2<C,D>, createMap:Void->Map<C,D>):Map<C,D>
  {
    var res = createMap();
    for (k in h.keys()) {
      var val = h.get(k);
      var r = f(k, val);
      res.set(r._1, r._2); 
    }
    return res;
  }

  public static function foldElems<A,B,C>(m:Map<A, B>, init:C, f : C -> B -> C):C
  {
    return fold(m, init, function (c,_,b) return f(c,b));
  }

  public static function foldKeys<A,B,C>(m:Map<A, B>, init:C, f : C -> A -> C):C
  {
    return fold(m, init, function (c,a,_) return f(c,a));
  }

  public static function fold<A,B,C>(m:Map<A, B>, init:C, f : C -> A -> B -> C):C
  {
    for (k in m.keys()) {
      var v = m.get(k);
      init = f(init, k, v);
    }
    return init;
  }

  public static function mapToArray<A,B,C>(h:Map<A, B>, f : A -> B -> C):Array<C>
  {
    var res = [];
    for (k in h.keys()) 
    {
      var val = h.get(k);
      res.push(f(k, val));
    }
    return res;
  }
  
  public static function toArray<A,B>(h:Map<A, B>):Array<Tup2<A, B>>
  {
    var res = [];
    for (k in h.keys()) 
    {
      var val = h.get(k);
      res.push(Tup2.create(k, val));
    }
    return res;
  }
  
  public static function getOption<A>(h:Map<String, A>, key:String):Option<A>
  {
    return h.get(key).nullToOption();
  }
  
  public static function getOrElseConst<A>(h:Map<String, A>, key:String, elseValue:A):A
  {
    return h.get(key).nullGetOrElseConst(elseValue);
  }
  
}