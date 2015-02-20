package scuts.ht.syntax;
import scuts.ht.classes.Category;

class Categorys
{
  public static function id <A, Cat>(a:A, cat:Category<Cat>):Cat<A, A> return cat.id(a);

  public static function next <A,B,C, Cat>(f:Cat<A, B>, g:Cat<B, C>, cat:Category<Cat>):Cat<A, C> return cat.next(f,g);

  public static function dot <A,B,C, Cat>(g:Cat<B, C>, f:Cat<A, B>, cat:Category<Cat>):Cat<A, C> return cat.dot(g,f);

  public static function back <A,B,C, Cat>(g:Cat<B, C>, f:Cat<A, B>, cat:Category<Cat>):Cat<A, C> return cat.back(g,f);

}