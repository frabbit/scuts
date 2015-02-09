package scuts.core;

/**
 * ...
 * @author
 */

class Lists
{

  public static inline function map < A, B > (list:List<A>, f:A->B):List<B>
  {
    return Iterables.mapToList(list, f);
  }

  public static inline function mapWithIndex < A, B > (list:List<A>, f:A->Int->B):List<B>
  {
    return Iterables.mapToListWithIndex(list, f);
  }

  public static inline function toArray < A > (list:List<A>):Array<A>
  {
    return [for (e in list) e];
  }

}