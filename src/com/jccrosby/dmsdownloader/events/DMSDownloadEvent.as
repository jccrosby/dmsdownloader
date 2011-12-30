package com.jccrosby.dmsdownloader.events
{
	import com.jccrosby.dmsdownloader.model.DMSModel;
	import com.jccrosby.dmsdownloader.vo.DMSFile;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class DMSDownloadEvent extends Event
	{
		static public const	SERVICE_DOWNLOAD_COMPLETE:String = "serviceDownloadComplete";
		static public const	ALL_IMAGES_DOWNLOADED:String = "allImagesDownloaded";
		static public const	DOWNLOADING_IMAGE:String = "downloadingImage";
		static public const	IMAGE_SAVED:String = "imageSaved";
		static public const	IMAGE_ERROR:String = "imageError";
		
		public var dmsModel:DMSModel;
		public var dmsFile:DMSFile;
		
		public function DMSDownloadEvent( type:String, dmsModel:DMSModel=null, dmsFile:DMSFile=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.dmsModel = dmsModel;
			this.dmsFile = dmsFile;
		}
	}
}