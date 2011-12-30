package com.jccrosby.dmsdownloader.vo
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class DMSFile
	{
		public var imageURL:String
		public var created:String;
		public var file:File;
		public var byteData:ByteArray;
		
		public function dispose():void
		{
			byteData = null;
			file = null;
		}
	}
}