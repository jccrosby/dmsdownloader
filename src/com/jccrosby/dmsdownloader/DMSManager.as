package com.jccrosby.dmsdownloader
{
	import com.jccrosby.dmsdownloader.events.DMSDownloadEvent;
	import com.jccrosby.dmsdownloader.model.DMSModel;
	import com.jccrosby.dmsdownloader.vo.DMSFile;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class DMSManager extends EventDispatcher
	{
		private var _loader:URLLoader;
		private var _dmsModel:DMSModel;
		
		protected var servicePath:String = "";
		
		public function DMSManager( servicePath:String )
		{
			super( this );
			
			this.servicePath = servicePath;
			
			_loader = new URLLoader();
			
			_loader.addEventListener( Event.COMPLETE, onLoaderComplete );
			_loader.addEventListener( ProgressEvent.PROGRESS, onProgress );
		}
		
		public function downloadImages( userID:String ):void
		{
			var request:URLRequest = new URLRequest();
			request.url = servicePath + userID;
			
			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			_loader.load( request );
		}
		
		public function onLoaderComplete( event:Event ):void
		{
			//dispatchEvent( new DMSDownloadEvent( DMSDownloadEvent.DOWNLOAD_COMPLETE, _loader.data ) );
			// Parse the RSS into a model and then start downloading images
			_dmsModel = new DMSModel();
			var dmsXML:XML = new XML( _loader.data );
			for each( var pic:XML in dmsXML..pic )
			{
				var newDMSFile:DMSFile = new DMSFile();
				newDMSFile.created = pic.created;
				newDMSFile.imageURL = pic["image_url"];
				_dmsModel.dmsImages.addItem( newDMSFile );
			}
			
			dispatchEvent( new DMSDownloadEvent( DMSDownloadEvent.SERVICE_DOWNLOAD_COMPLETE, _dmsModel ) );
		}
		
		public function onProgress( event:ProgressEvent ):void
		{
			dispatchEvent( event );
		}
	}
}