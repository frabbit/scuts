package scuts.ht.samples;

#if !excludeHtSamples

import scuts.core.Tuples.*;
import scuts.core.Options;
import scuts.ht.syntax.OrdBuilder;
import scuts.ht.syntax.ShowBuilder;

using scuts.ht.Context;

typedef Person = {
  name : String,
  age : Int
}

class Sort
{
  public static function sort <A> (list:Array<A>, ord:Ord<A>) 
  {
    var res = list.copy();
    res.sort(ord.compareInt);
    return res;
  }
  
  public static function main() 
  {
    
    var tuples = [tup2(4, 2.2), tup2(1, 2.0), tup2(1, 2.2), tup2(0, 10.0)];
    var ints = [1,4,5,6,2];
    var floats = [4.0,1.4,1.5,1.6,1.2];
    var strings = ["paul", "bettina", "jerome", "kirstin"];
    var arrayOfArrays = [[Some(4)], [Some(2)], [Some(1)]];
    var complexArrays = [[[[Some(4)]]], [[[Some(2)]]], [[[Some(1)]]]];
    
    
    strings.show_();
    
    sort._(strings).show_();
    
    
    trace(strings.show_() + " -> " + sort._(strings).show_());
    
    trace(floats.show_() + " -> " + sort._(floats).show_());
    
    trace(ints.show_() + " -> " + sort._(ints).show_());
    trace(arrayOfArrays.show_() + " -> " + sort._(arrayOfArrays).show_());
    trace(tuples.show_() + " -> " + sort._(tuples).show_());
    trace(complexArrays.show_() + " -> " + sort._(complexArrays).show_());
    

    var persons = [{ name : "jimmy", age : 17}, { name : "alf", age : 27}];
    var personsComplex = [Some(tup2("x", { name : "jimmy", age : 17})), Some(tup2("x", { name : "alf", age : 27}))];
    

    Hots.implicit(ShowBuilder.create(function (p1:Person) return '{ name : ${p1.name}, age : ${p1.age}}'));

    var byNameDesc = OrdBuilder.createByIntCompare(function (p1:Person, p2:Person) return p1.name.compareInt._(p2.name));
    Hots.implicit(byNameDesc);

    trace("persons by name: " + persons.show_() + " -> " + sort._(persons).show_());
    
    trace("personsComplex by name: " + personsComplex.show_() + " -> " + sort._(personsComplex).show_());


     
    var byAgeDesc = OrdBuilder.createByIntCompare(function (p1:Person, p2:Person) return p1.age.compareInt._(p2.age));
    Hots.implicit(byAgeDesc);

    trace("persons by age: " + persons.show_() + " -> " + sort._(persons).show_());

    trace("personsComplex by age: " + personsComplex.show_() + " -> " + sort._(personsComplex).show_());
  
  }
}

#end