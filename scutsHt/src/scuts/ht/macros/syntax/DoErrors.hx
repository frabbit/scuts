
package scuts.ht.macros.syntax;

#if macro

import haxe.macro.Expr.Position;
import haxe.PosInfos;
import scuts.Scuts;
import scuts.ht.macros.syntax.DoData;

class DoGenErrors 
{
  /**
   * Converts a generator error into a more helpful String.
   */
  public static function toString (err:DoGenError) return switch (err) 
  {
    case FilterOnlyAvailableForMonadZeros:
      "Filter can only be used if a MonadZero is in Scope";
    case FilterNotAllowedAtThisPosition:
      "It's not allowed to use filter here";
    case PureNotAllowedAtThisPosition:
      "It's not allowed to use pure here";
  }

  /**
   * Throws an Error with an appropriate message for the generator error.
   */
  public static function handleError <T>(err:DoGenError, ?position:Position, ?infos:PosInfos):T 
  {
    return Scuts.macroError(toString(err), position, infos);
  }
}

class DoParseErrors 
{
  /**
   * Converts a parser error into a String.
   */
  public static function toString (err:DoParseError) return switch (err) 
  {
    case LeftSideOfFlatMapMustBeConstIdent: 
      "The left side of the flatmap '<=' operation must be a constant identifier";
  }

  /**
   * Throws an Error with an appropriate message for the parser error.
   */
  public static function handleError <T>(err:DoParseError, ?position:Position, ?infos:PosInfos):T 
  {
    return Scuts.macroError(toString(err), position, infos);
  }
}

#end