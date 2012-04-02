package scuts.core.extensions;

/**
 * ...
 * @author 
 */

class HashExt 
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
  
}