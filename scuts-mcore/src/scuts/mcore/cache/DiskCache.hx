package scuts.mcore.cache;

#if macro


import haxe.macro.Context;
import sys.FileSystem;
import scuts.core.Options;

import sys.io.File;

class DiskCache 
{

  static var folder = "_scuts_disk_cache";
  
  public static function store (signature:String, val:String) {
    if (Context.defined("scuts_cache")) {
      if (!FileSystem.exists(folder)) {
        FileSystem.createDirectory(folder);
      }
      
      var out = File.write(folder + "/" + signature, false);
      out.writeString(val);
      out.close();
    }
  }
  
  public static function get (signature:String):Option<String> {
    
    var file = folder + "/" + signature;
    return if (Context.defined("scuts_cache") && FileSystem.exists(file)) {
      Some(File.getContent(file));
    } else {
      None;
    }
  }
  
}

#end