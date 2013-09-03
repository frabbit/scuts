package scuts.core;

import haxe.ds.IntMap;
import haxe.ds.StringMap;
import scuts.core.Tuples;

using scuts.core.Options;
using scuts.core.Nulls;


class StringMaps {

  @:noUsing public static function create <T>():StringMap<T> {
    return new StringMap();
  }

  public static function mapElems<A,B>(h:StringMap<A>, f : A -> B):StringMap<B>
  {
    return Maps.mapElems(h, f, create);
  }

  public static function mapElemsWithKeys<A,B>(h:StringMap<A>, f : String -> A -> B):StringMap<B>
  {
    return Maps.mapElemsWithKeys(h, f, create);
  }

  public static function imSet <B>(m:StringMap<B>, key:String, v:B):StringMap<B>
  {
    return Maps.imSet(m, key, v, create);
  }

  public static function getOption<A>(h:StringMap<A>, key:String):Option<A>
  {
    return h.get(key).nullToOption();
    
  }


}

class IntMaps {

  @:noUsing public static function create <T>():IntMap<T> {
    return new IntMap();
  }

  public static function mapElems<A,B>(h:IntMap<A>, f : A -> B):IntMap<B>
  {
    return Maps.mapElems(h, f, create);
  }
  public static function mapElemsWithKeys<A,B>(h:IntMap<A>, f : Int -> A -> B):IntMap<B>
  {
    return Maps.mapElemsWithKeys(h, f, create);
  }


}

class Maps 
{

  /**
   * immutable Set operation, returns a new Map and doesn't change the given Map m.
   */
  public static function imSet <A,B>(m:Map<A,B>, key:A, v:B, createEmptyMap:Void->Map<A,B>):Map<A,B>
  {
    var newMap = createEmptyMap();
    
    var found = false;

    for (k in m.keys()) {
      
      if (key == k) 
      {
        newMap.set(k,v);
        found = true;
      } 
      else 
      {
        newMap.set(k,m.get(k));
      }
    }
    if (!found) {
      newMap.set(key, v);
    }
    return newMap;
  }
  

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
  
  public static function getOption<K,A>(h:Map<K, A>, key:K):Option<A>
  {
    return h.get(key).nullToOption();
  }
  
  public static function getOrElseConst<K,A>(h:Map<K, A>, key:K, elseValue:A):A
  {
    return h.get(key).nullGetOrElseConst(elseValue);
  }
  
}