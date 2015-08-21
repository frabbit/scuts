package scuts.core;

/**
 * ...
 * @author
 */

class Dates
{

  public static function fullDays (d:Date):Date
  {
    return new Date(d.getFullYear(), d.getMonth(), d.getDate(), 0, 0, 0);
  }

  public static function diffFullDays (d1:Date, d2:Date):Int
  {
    return Math.floor((fullDays(d1).getTime() - fullDays(d2).getTime()) / 24 / 60 / 60 / 1000);
  }

  public static function addHours (d:Date, hours:Int):Date
  {
    return Date.fromTime(d.getTime() + hours * 60 * 60 * 1000);
  }



  public static function addDate (d:Date, span:Date):Date
  {
    return Date.fromTime(d.getTime() + span.getTime());
  }

  public static function addMinutes (d:Date, minutes:Int):Date
  {
    return Date.fromTime(d.getTime() + minutes * 60 * 1000);
  }

  public static function addSeconds (d:Date, seconds:Int):Date
  {
    return Date.fromTime(d.getTime() + seconds * 1000);
  }

  public static function addDays (d:Date, days:Int):Date
  {
    return Date.fromTime(d.getTime() + days * 24 * 60 * 60 * 1000);
  }

  public static function addYears (d:Date, years:Int):Date
  {
    return new Date(d.getFullYear()+years, d.getMonth(), d.getDate(), d.getHours(), d.getMinutes(), d.getSeconds());
  }

  public static function stripMilliseconds (d:Date):Date
  {
    return Date.fromTime( Math.floor(d.getTime() / 1000)*1000);
  }

  public static inline function eq (d1:Date, d2:Date):Bool
  {
  	return compare(d1, d2) == 0;
  }

  public static function compare (d1:Date, d2:Date):Int
  {
    var diff = d1.getTime() - d2.getTime();
    return diff < 0 ? -1 : (diff > 0 ? 1 : 0);
  }

  public static inline function less (d1:Date, d2:Date):Bool {
    return compare(d1, d2) < 0;
  }

  public static inline function greater (d1:Date, d2:Date):Bool {
    return compare(d1, d2) > 0;
  }

  public static inline function lessOrEq (d1:Date, d2:Date):Bool {
    return compare(d1, d2) <= 0;
  }

  public static inline function greaterOrEq (d1:Date, d2:Date):Bool {
    return compare(d1, d2) >= 0;
  }

  public static inline function isBefore (d:Date, other:Date):Bool
  {
    return less(d, other);
  }

  public static inline function isAfter (d:Date, other:Date):Bool
  {
    return greater(d, other);
  }

  public static inline function isInBetween (d:Date, begin:Date, end:Date):Bool
  {
    return greaterOrEq(d, begin) && lessOrEq(d, end);
  }

}