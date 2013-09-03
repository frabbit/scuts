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
package scuts.reactive;

import scuts.reactive.Reactive;

using scuts.reactive.Behaviours;

private typedef Beh<T> = Behaviour<T>;

class BehavioursFloat 
{
  
    private function new() { }
    
    public static function plus(b: Beh<Float>, value: Float): Beh<Float> {
        return plusB(b, Behaviours.constant(value));
    }
    
    public static function plusB(b1: Beh<Float>, b2: Beh<Float>): Beh<Float> {
        return b1.zipWith(b2, function(t1, t2) { return t1 + t2; });
    }
    
    public static function minusB(b1: Beh<Float>, b2: Beh<Float>): Beh<Float> {
        return b1.zipWith(b2, function(t1, t2) { return t1 - t2; });
    }
    
    public static function minus(b: Beh<Float>, value: Float): Beh<Float> {
        return minusB(b, Behaviours.constant(value));
    }
    
    public static function timesB(b1: Beh<Float>, b2: Beh<Float>): Beh<Float> {
        return b1.zipWith(b2, function(t1, t2) { return t1 * t2; });
    }
    
    public static function times(b: Beh<Float>, value: Float): Beh<Float> {
        return timesB(b, Behaviours.constant(value));
    }
    
    public static function dividedByB(b1: Beh<Float>, b2: Beh<Float>): Beh<Float> {
        return b1.zipWith(b2, function(t1,t2) { return t1 / t2; });
    }
    
    public static function dividedBy(b: Beh<Float>, value: Float): Beh<Float> {
        return dividedByB(b, Behaviours.constant(value));
    }
    
    public static function abs(b: Beh<Float>): Beh<Float> {
        return b.map(function(e) { return Math.abs(e); });
    }
    
    public static function negate(b: Beh<Float>): Beh<Float> {
        return b.map(function(e) { return -e; });
    }
    
    public static function floor(b: Beh<Float>): Beh<Float> {
        return b.map(function(e): Float { return Math.floor(e); });
    }
    
    public static function ceil(b: Beh<Float>): Beh<Float> {
        return b.map(function(e): Float { return Math.ceil(e); });
    }
    
    public static function round(b: Beh<Float>): Beh<Float> {
        return b.map(function(e): Float { return Math.round(e); });
    }
    
    public static function acos(b: Beh<Float>): Beh<Float> {
        return b.map(function(e) { return Math.acos(e); });
    }
    
    public static function asin(b: Beh<Float>): Beh<Float> {
        return b.map(function(e) { return Math.asin(e); });
    }
    
    public static function atan(b: Beh<Float>): Beh<Float> {
        return b.map(function(e) { return Math.atan(e); });
    }
    
    public static function atan2B(b1: Beh<Float>, b2: Beh<Float>): Beh<Float> {
        return b1.zipWith(b2, function(t1,t2) { return Math.atan2(t1, t2); });
    }
    
    public static function atan2(b: Beh<Float>, value: Float): Beh<Float> {
        return atan2B(b, Behaviours.constant(value));
    }
    
    public static function cos(b: Beh<Float>): Beh<Float> {
        return b.map(function(e) { return Math.cos(e); });
    }
    
    public static function exp(b: Beh<Float>): Beh<Float> {
        return b.map(function(e) { return Math.exp(e); });
    }
    
    public static function log(b: Beh<Float>): Beh<Float> {
        return b.map(function(e) { return Math.log(e); });
    }
    
    public static function maxB(b1: Beh<Float>, b2: Beh<Float>): Beh<Float> {
        return b1.zip(b2).map(function(t) { return Math.max(t._1, t._2); });
    }
    
    public static function max(b: Beh<Float>, value: Float): Beh<Float> {
        return maxB(b, Behaviours.constant(value));
    }
    
    public static function minB(b1: Beh<Float>, b2: Beh<Float>): Beh<Float> {
        return b1.zip(b2).map(function(t) { return Math.min(t._1, t._2); });
    }
    
    public static function min(b: Beh<Float>, value: Float): Beh<Float> {
        return minB(b, Behaviours.constant(value));
    }
    
    public static function powB(b1: Beh<Float>, b2: Beh<Float>): Beh<Float> {
        return b1.zip(b2).map(function(t) { return Math.pow(t._1, t._2); });
    }
    
    public static function pow(b: Beh<Float>, value: Float): Beh<Float> {
        return powB(b, Behaviours.constant(value));
    }
    
    public static function sin(b: Beh<Float>): Beh<Float> {
        return b.map(function(e) { return Math.sin(e); });
    }
    
    public static function sqrt(b: Beh<Float>): Beh<Float> {
        return b.map(function(e) { return Math.sqrt(e); });
    }
    
    public static function tan(b: Beh<Float>): Beh<Float> {
        return b.map(function(e) { return Math.tan(e); });
    }
}