package scuts.core;

/**
 * ...
 * @author 
 */

class Dates 
{

  public static function fullDays (d:Date):Date {
    return new Date(d.getFullYear(), d.getMonth(), d.getDate(), 0, 0, 0);
  }
  
  public static function diffFullDays (d1:Date, d2:Date):Int {
    return Math.floor((fullDays(d1).getTime() - fullDays(d2).getTime()) / 24 / 60 / 60 / 1000);
  }
  
}