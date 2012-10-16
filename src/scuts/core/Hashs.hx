package scuts.core;
import scuts.core.Option;
import scuts.core.Tup2;

using scuts.core.Options;
using scuts.core.Dynamics;


class Hashs 
{

  public static function mapToArray<A,B>(h:Hash<A>, f : String -> A -> B):Array<B>
  {
    var res = [];
    for (k in h.keys()) 
    {
      var val = h.get(k);
      res.push(f(k, val));
    }
    return res;
  }
  
  public static function toArray<A>(h:Hash<A>):Array<Tup2<String, A>>
  {
    var res = [];
    for (k in h.keys()) 
    {
      var val = h.get(k);
      res.push(Tup2.create(k, val));
    }
    return res;
  }
  
  public static function getOption<A>(h:Hash<A>, key:String):Option<A>
  {
    return h.get(key).nullToOption();
  }
  
  public static function getOrElseConst<A>(h:Hash<A>, key:String, elseValue:A):A
  {
    return h.get(key).nullGetOrElseConst(elseValue);
  }
  
}