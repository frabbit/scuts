package scuts.core;

import haxe.ds.IntMap;
import haxe.ds.StringMap;
import haxe.ds.ObjectMap;
import haxe.ds.EnumValueMap;

import Map.IMap;
import scuts.core.Iterators;
import scuts.core.Tuples;

using scuts.core.Options;
using scuts.core.Nulls;


class Maps
{
  public static function concat <A,B,X:IMap<A,B>>(m1:X, m2:X, create:Void->X):X
  {
    var res = create();
    for (k in m1.keys())
    {
      res.set(k, m1.get(k));
    }
    for (k in m2.keys())
    {
      res.set(k, m2.get(k));
    }
    return res;
  }


}

class ObjectMaps
{

  @:noUsing public static function create <A:{},B>():ObjectMap<A,B>
  {
    return new ObjectMap();
  }


  public static function keyValueIter <A:{},B>(m:ObjectMap<A,B>):Iterator<{ key : A, value : B}>
  {
    return Iterators.map(m.keys(), function (k) return { key : k, value : m.get(k) });
  }

  /**
   * immutable Set operation, returns a new Map and doesn't change the given Map m.
   */
  @:generic public static function imSet <A:{},B>(m:ObjectMap<A,B>, key:A, v:B):ObjectMap<A,B>
  {
    var newMap = create();

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


  public static function each<A:{},B>(m:ObjectMap<A, B>, f : A -> B, f:A->B->Void):Void
  {
    for (k in m.keys()) {
      var val = m.get(k);
      f(k, val);
    }
  }

  public static function mapKeys<A:{},B,C:{}>(h:ObjectMap<A, B>, f : A -> C):ObjectMap<C,B>
  {
    var res = create();
    for (k in h.keys()) {
      var val = h.get(k);
      res.set(f(k), val);
    }
    return res;
  }

  @:noUsing public static function mapElems<A:{},B,C>(h:ObjectMap<A, B>, f : B -> C):ObjectMap<A,C>
  {
    var res = create();
    for (k in h.keys()) {
      var val = h.get(k);
      res.set(k, f(val));
    }
    return res;
  }

  @:noUsing public static function mapElemsWithKeys<A:{},B,C>(h:ObjectMap<A, B>, f : A -> B -> C):ObjectMap<A,C>
  {
    var res = create();
    for (k in h.keys()) {
      var val = h.get(k);
      res.set(k, f(k, val));
    }
    return res;
  }

  @:noUsing public static function map<A:{},B,C:{},D>(h:ObjectMap<A, B>, f : A -> B -> Tup2<C,D>):ObjectMap<C,D>
  {
    var res = create();
    for (k in h.keys()) {
      var val = h.get(k);
      var r = f(k, val);
      res.set(r._1, r._2);
    }
    return res;
  }

  public static function foldElems<A:{},B,C>(m:ObjectMap<A, B>, init:C, f : C -> B -> C):C
  {
    return fold(m, init, function (c,_,b) return f(c,b));
  }

  public static function foldKeys<A:{},B,C>(m:ObjectMap<A, B>, init:C, f : C -> A -> C):C
  {
    return fold(m, init, function (c,a,_) return f(c,a));
  }

  public static function fold<A:{},B,C>(m:ObjectMap<A, B>, init:C, f : C -> A -> B -> C):C
  {
    for (k in m.keys()) {
      var v = m.get(k);
      init = f(init, k, v);
    }
    return init;
  }

  public static function mapToArray<A:{},B,C>(h:ObjectMap<A, B>, f : A -> B -> C):Array<C>
  {
    var res = [];
    for (k in h.keys())
    {
      var val = h.get(k);
      res.push(f(k, val));
    }
    return res;
  }

  public static function toArray<A:{},B>(h:ObjectMap<A, B>):Array<Tup2<A, B>>
  {
    var res = [];
    for (k in h.keys())
    {
      var val = h.get(k);
      res.push(Tup2.create(k, val));
    }
    return res;
  }

  public static function getOption<K:{},A>(h:ObjectMap<K, A>, key:K):Option<A>
  {
    return h.get(key).nullToOption();
  }

  public static function getOrElseConst<K:{},A>(h:ObjectMap<K, A>, key:K, elseValue:A):A
  {
    return h.get(key).nullGetOrElseConst(elseValue);
  }


}




class EnumValueMaps {

  @:noUsing public static function create <A:EnumValue, T>():EnumValueMap<A, T> {
    return new EnumValueMap();
  }

  public static function mapElems<K:EnumValue, A,B>(h:EnumValueMap<K,A>, f : A -> B):EnumValueMap<K,B>
  {
    var res = create();
    for (k in h.keys()) {
      var val = h.get(k);
      res.set(k, f(val));
    }
    return res;
  }
  public static function mapElemsWithKeys<K:EnumValue,A,B>(h:EnumValueMap<K,A>, f : K -> A -> B):EnumValueMap<K,B>
  {
    var res = create();
    for (k in h.keys()) {
      var val = h.get(k);
      res.set(k, f(k, val));
    }
    return res;
  }

  public static function keyValueIter <K:EnumValue,B>(m:EnumValueMap<K,B>):Iterator<{ key : K, value : B}>
  {
    return Iterators.map(m.keys(), function (k) {  return { key : k, value : (m.get(k):B) } });
  }
  public static function toArray<A:EnumValue,B>(h:EnumValueMap<A, B>):Array<Tup2<A, B>>
  {
    return Helper.toArray(h);
  }

}

class StringMaps {

  @:noUsing public static function create <T>():StringMap<T> {
    return new StringMap();
  }



  public static function imSet <B>(m:StringMap<B>, key:String, v:B):StringMap<B>
  {
    var newMap = create();

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

  public static function mapElems<A,B>(h:StringMap<A>, f : A -> B):StringMap<B>
  {
    var res =create();
    for (k in h.keys()) {
      var val = h.get(k);
      res.set(k, f(val));
    }
    return res;
  }

  public static function mapElemsWithKeys<A,B>(h:StringMap<A>, f : String -> A -> B):StringMap<B>
  {
    var res = create();
    for (k in h.keys()) {
      var val = h.get(k);
      res.set(k, f(k, val));
    }
    return res;
  }

  public static function getOption<A>(h:StringMap<A>, key:String):Option<A>
  {
    return h.get(key).nullToOption();
  }

  public static function getOrInsert <A>(h:StringMap<A>, key:String, def:Void->A):A
  {
    var r = h.get(key);
    return if (r == null) {
      var x = def();
      h.set(key, x);
      x;
    } else r;
  }

  public static function keyValueIter <B>(m:StringMap<B>):Iterator<{ key : String, value : B}>
  {
    return Iterators.map(m.keys(), function (k) return { key : k, value : m.get(k) });
  }

  public static function foldElems<B,C>(m:StringMap<B>, init:C, f : C -> B -> C):C
  {
    return fold(m, init, function (c,_,b) return f(c,b));
  }

  public static function foldKeys<B,C>(m:StringMap<B>, init:C, f : C -> String -> C):C
  {
    return fold(m, init, function (c,a,_) return f(c,a));
  }

  public static function fold<B,C>(m:StringMap<B>, init:C, f : C -> String -> B -> C):C
  {
    for (k in m.keys()) {
      var v = m.get(k);
      init = f(init, k, v);
    }
    return init;
  }


}

class IntMaps {

  @:noUsing public static function create <T>():IntMap<T> {
    return new IntMap();
  }

  public static function mapElems<A,B>(h:IntMap<A>, f : A -> B):IntMap<B>
  {
    var res = create();
    for (k in h.keys()) {
      var val = h.get(k);
      res.set(k, f(val));
    }
    return res;
  }
  public static function mapElemsWithKeys<A,B>(h:IntMap<A>, f : Int -> A -> B):IntMap<B>
  {
    var res = create();
    for (k in h.keys()) {
      var val = h.get(k);
      res.set(k, f(k, val));
    }
    return res;
  }

  public static function keyValueIter <B>(m:IntMap<B>):Iterator<{ key : Int, value : B}>
  {
    return Iterators.map(m.keys(), function (k) return { key : k, value : m.get(k) });
  }


}


private class Helper
{
  public static function imSet <A,B>(m:IMap<A,B>, key:A, v:B, create:Void->IMap<A,B>):IMap<A,B>
  {
    var newMap = create();

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

  public static function toArray<A,B>(h:IMap<A, B>):Array<Tup2<A, B>>
  {
    var res = [];
    for (k in h.keys())
    {
      var val = h.get(k);
      res.push(Tup2.create(k, val));
    }
    return res;
  }

}