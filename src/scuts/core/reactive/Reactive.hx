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

import haxe.Timer;
import scuts.core.reactive.Streams;


using scuts.core.extensions.Iterables;

typedef Timeout = Timer;

class External {
    public static var setTimeout: (Void -> Void) -> Int -> Timeout = function(f, time) { 
      #if (!cpp && !neko && !php)
      return haxe.Timer.delay(f, time); 
      #else
      return cast null;
      #end
    };
    
    public static var cancelTimeout: Timeout -> Void = function(timer) { 
      #if (!cpp && !neko && !php)
      timer.stop(); 
      #end
      
    }
    
    public static var now: Void -> Float = function() { return Date.now().getTime(); }
}

enum Propagation<T> {
  Propagate(value: Pulse<T>);
  NotPropagate;
}

class Pulse<T> {
    public var stamp (default, null): Int;
    public var value (default, null): T;
    
    public function new(stamp: Int, value: T) {
        this.stamp = stamp;
        this.value = value;
        
        var elements: Array<Dynamic> = [];
        
        elements.push(stamp); elements.push(value);
    }
    
    public function map<S>(f: T -> S): Pulse<S> {
        return withValue(f(value));
    }
    
    public function withValue<S>(newValue: S): Pulse<S> {
        return new Pulse<S>(stamp, newValue);
    }
}

class Stamp {
    private static var _stamp: Int = 1;
    
    public static function lastStamp(): Int {
        return _stamp;
    }
    
    public static function nextStamp(): Int {
        return ++_stamp;
    }
}

class Rank {
    private static var _rank: Int = 0;
    
    public static function lastRank(): Int {
        return _rank;
    }
    
    public static function nextRank(): Int {
        return ++_rank;
    }
}

typedef KeyValue<T> = { k: Int, v: T };

//@:allow(scuts.core.reactive)
class PriorityQueue<T> {
    var val: Array<KeyValue<T>>;
    
    public function new() {
        this.val = [];
    }
    
    public function length(): Int {
        return this.val.length;
    }
    
    public function insert(kv: KeyValue<T>) {
        this.val.push(kv);
        
        var kvpos = this.val.length - 1;
        
        while (kvpos > 0 && kv.k < this.val[Math.floor((kvpos-1)/2)].k) {
            var oldpos = kvpos;
            kvpos = Math.floor((kvpos-1)/2);
            
            this.val[oldpos] = this.val[kvpos];
            this.val[kvpos]  = kv;
        }
    }
    
    public function isEmpty(): Bool { 
        return this.val.length == 0; 
    }
    
    public function pop(): KeyValue<T> {
        if (this.val.length == 1) {
            return this.val.pop();
        }
        
        var ret = this.val.shift();
        
        this.val.unshift(this.val.pop());
        
        var kvpos = 0;
        var kv    = this.val[0];
        
        while (true) { 
            var leftChild  = (kvpos*2+1 < this.val.length ? this.val[kvpos*2+1].k : kv.k+1);
            var rightChild = (kvpos*2+2 < this.val.length ? this.val[kvpos*2+2].k : kv.k+1);
            
            if (leftChild > kv.k && rightChild > kv.k) {
                break;
            }
            else if (leftChild < rightChild) {
                this.val[kvpos] = this.val[kvpos*2+1];
                this.val[kvpos*2+1] = kv;
                kvpos = kvpos*2+1;
            }
            else {
                this.val[kvpos] = this.val[kvpos*2+2];
                this.val[kvpos*2+2] = kv;
                kvpos = kvpos*2+2;
            }
        }
        
        return ret;
    }
}





