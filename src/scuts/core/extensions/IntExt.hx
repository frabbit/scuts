package scuts.core.extensions;

class IntExt 
{

  public static inline function eq(a:Int, b:Int):Bool
  {
    return a == b;
  }
  
  public static function max(a:Int, b:Int) 
  {
    return a > b ? a : b;
  }
  
  public static function min(a:Int, b:Int) 
  {
    return a < b ? a : b;
  }
  
  public static function toInfiniteIterator (start:Int) {
    var cur = start;
    return {
      hasNext : function () {
        return true;
      },
      next : function () {
        return cur++;
      }
    }
  }
  
  public static function toLazyInfiniteIterator (start:Int) {
    return function () {
      return toInfiniteIterator(start);
    }
  }
  
  public static function toLazyIteratorTo (start:Int, end:Int) {
    var nextF = if (start > end) function (x) return x-1 else function (x) return x+1;
    end = if (start > end) end-1 else end+1;
    
    return function () {
      var s = start;
      var e = end;
      
      var cur = s;
      return {
        hasNext : function () {
          return cur != end;
        },
        next : function () {
          var v = cur;
          cur = nextF(cur);
          return v;
        }
      }
    }
  }
  
  
}