package scuts.core;
import haxe.PosInfos;


class PosInfosTools
{

  public static function toString(p:PosInfos) 
  {
    return p.fileName + "(line " + p.lineNumber + ") - " + p.className + "." + p.methodName;
  }
  
}