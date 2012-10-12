/*
 HaXe library written by John A. De Goes <john@socialmedia.com>

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the
 distribution.

 THIS SOFTWARE IS PROVIDED BY SOCIAL MEDIA NETWORKS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SOCIAL MEDIA NETWORKS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package scuts.core.reactive;

import scuts.core.reactive.Reactive;

using scuts.core.reactive.Behaviours;

private typedef Beh<T> = Behaviour<T>;

class BehavioursInt {
    private function new() { }
    
    public static function plus(b: Beh<Int>, value: Int): Beh<Int> {
        return plusB(b, Behaviours.constant(value));
    }
    
    public static function plusB(b1: Beh<Int>, b2: Beh<Int>): Beh<Int> {
        return b1.zip(b2).map(function(t) { return t._1 + t._2; });
    }
    
    public static function minusB(b1: Beh<Int>, b2: Beh<Int>): Beh<Int> {
        return b1.zip(b2).map(function(t) { return t._1 - t._2; });
    }
    
    public static function minus(b: Beh<Int>, value: Int): Beh<Int> {
        return minusB(b, Behaviours.constant(value));
    }
    
    public static function timesB(b1: Beh<Int>, b2: Beh<Int>): Beh<Int> {
        return b1.zip(b2).map(function(t) { return t._1 * t._2; });
    }
    
    public static function times(b: Beh<Int>, value: Int): Beh<Int> {
        return timesB(b, Behaviours.constant(value));
    }
    
    public static function modB(b1: Beh<Int>, b2: Beh<Int>): Beh<Int> {
        return b1.zip(b2).map(function(t) { return t._1 % t._2; });
    }
    
    public static function mod(b: Beh<Int>, value: Int): Beh<Int> {
        return modB(b, Behaviours.constant(value));
    }
    
    public static function dividedByB(b1: Beh<Int>, b2: Beh<Int>): Beh<Int> {
        return b1.zip(b2).map(function(t) { return Std.int(t._1 / t._2); });
    }
    
    public static function dividedBy(b: Beh<Int>, value: Int): Beh<Int> {
        return dividedByB(b, Behaviours.constant(value));
    }
    
    public static function abs(b: Beh<Int>): Beh<Int> {
        return b.map(function(e) { return Std.int(Math.abs(e)); });
    }
    
    public static function negate(b: Beh<Int>): Beh<Int> {
        return b.map(function(e) { return -e; });
    }
    
    public static function toFloat(b: Beh<Int>): Beh<Float> {
        return b.map(function(e): Float { return e; });
    }
}