package scuts.mcore.cache;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)

import neko.FileSystem;
import scuts.core.types.Option;

import neko.io.File;

class DiskCache 
{

  static var folder = "_scuts_disk_cache";
  
  public static function store (signature:String, val:String) {
    if (!FileSystem.exists(folder)) {
      FileSystem.createDirectory(folder);
    }
    
    var out = File.write(folder + "/" + signature, false);
    out.writeString(val);
    out.close();
  }
  
  public static function get (signature:String):Option<String> {
    
    var file = folder + "/" + signature;
    return if (FileSystem.exists(file)) {
      Some(File.getContent(file));
    } else {
      None;
    }
  }
  
}

#end