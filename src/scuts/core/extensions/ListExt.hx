package scuts.core.extensions;

/**
 * ...
 * @author 
 */

class ListExt 
{

  public static function map < A, B > (list:List<A>, f:A->B):List<B> 
	{
		return IterableExt.mapToList(list, f);
	}
	
	public static function mapWithIndex < A, B > (list:List<A>, f:A->Int->B):List<B> 
	{
		return IterableExt.mapToListWithIndex(list, f);
	}
  
}