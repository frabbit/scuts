
package scuts.core.tools;

#if macro

class FileLog {

	public static var date = Date.now().toString().split(" ").join("_").split(":").join("_");

	public static function log (x:Dynamic) {
		if (!sys.FileSystem.exists("log")) sys.FileSystem.createDirectory("log");
		var fileName = "log-" + date + ".txt";
		if (!sys.FileSystem.exists(fileName)) {
			var out = sys.io.File.write(fileName);
			out.writeString(x + "\n");
			out.close();
		} else {
			var out = sys.io.File.append(fileName);
			out.writeString(x + "\n");
			out.close();
		}
	}

}

#end