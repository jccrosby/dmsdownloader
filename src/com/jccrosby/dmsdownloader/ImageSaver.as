package com.jccrosby.dmsdownloader
{
	import air.update.events.DownloadErrorEvent;
	
	import com.jccrosby.dmsdownloader.events.DMSDownloadEvent;
	import com.jccrosby.dmsdownloader.model.DMSModel;
	import com.jccrosby.dmsdownloader.vo.DMSFile;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.JPEGEncoder;
	
	public class ImageSaver extends EventDispatcher
	{
		
		private var _imageLoader:URLLoader;
		private var _dmsModel:DMSModel;
		private var _currentDMSFile:DMSFile;

		public var saveDirectory:File;
		
		public function ImageSaver()
		{
			super( this );
			
			saveDirectory = saveDirectory;
			
			_imageLoader = new URLLoader();
			_imageLoader.dataFormat = URLLoaderDataFormat.BINARY;
			
			_imageLoader.addEventListener( Event.COMPLETE, onLoaderComplete );
			_imageLoader.addEventListener( ProgressEvent.PROGRESS, onProgress );
			_imageLoader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
		}
		
		private function _queueImage():void
		{
			if( _dmsModel.dmsImages.length )
			{
				_currentDMSFile = _dmsModel.dmsImages.removeItemAt( 0 ) as DMSFile;
				downloadAndSaveFile( _currentDMSFile );
			}
			else
			{
				dispatchEvent( new DMSDownloadEvent( DMSDownloadEvent.ALL_IMAGES_DOWNLOADED ) );
			}
		}
		
		public function downloadAndSaveFile( dmsFile:DMSFile ):void
		{
			_currentDMSFile = dmsFile;
			
			var imageRequest:URLRequest = new URLRequest();
			imageRequest.url = _currentDMSFile.imageURL;
			
			_imageLoader.load( imageRequest );
			dispatchEvent( new DMSDownloadEvent( DMSDownloadEvent.DOWNLOADING_IMAGE, null, _currentDMSFile ) );
		}
		
		public function downloadImages( dmsModel:DMSModel ):void
		{
			_dmsModel = dmsModel;
			_queueImage();
		}
		
		public function onLoaderComplete( event:Event ):void
		{
			// TODO: Write file
			_currentDMSFile.file = new File().resolvePath( saveDirectory.nativePath + "/" + _currentDMSFile.created + ".jpg" ); 
			
			if( _currentDMSFile.file.exists )
				_currentDMSFile.file = new File().resolvePath( saveDirectory.nativePath + "/" + _currentDMSFile.created + "_" + _createGUID() + ".jpg" );
			
			_currentDMSFile.byteData = _imageLoader.data as ByteArray; 
			/*var encoder:JPEGEncoder = new JPEGEncoder( 100 );
			encoder.encode( _imageLoader.data as BitmapData );*/
			
			var fs:FileStream = new FileStream();
			fs.open( _currentDMSFile.file, FileMode.WRITE );
			fs.writeBytes( _currentDMSFile.byteData, 0, _currentDMSFile.byteData.bytesAvailable );
			fs.close();
			
			dispatchEvent( new DMSDownloadEvent( DMSDownloadEvent.IMAGE_SAVED, null, _currentDMSFile ) );
			_queueImage();
		}
		
		public function onProgress( event:ProgressEvent ):void
		{
			dispatchEvent( event );
		}
		
		public function onIOError( event:IOErrorEvent ):void
		{
			var fs:FileStream;
			var logFile:File = saveDirectory.resolvePath( "error_log.log" );
			if( !logFile.exists )
			{
				fs = new FileStream();
				fs.open( logFile, FileMode.WRITE );
				fs.writeUTF( "Error Log: DMSDownloader\n" );
				fs.close();
			}
			fs = new FileStream();
			fs.open( logFile, FileMode.APPEND );
			fs.writeUTF( "////////////////// Error Loading Image \n" + event.errorID + "\n" + event.text + "\n" + String( _imageLoader.data ) + "\n//////////////////////////\n\n" );
			fs.close();
			
			event.stopPropagation();
			dispatchEvent( new DMSDownloadEvent( DMSDownloadEvent.IMAGE_ERROR, null, _currentDMSFile ) );
			_queueImage();
		}
		
		private function _createGUID( value:Array = null ):String 
		{
			
			var uid:Array = new Array();
			var chars:Array = new Array( 48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70 );
			var separator:uint = 45;
			var template:Array = value || new Array( 8,4,4,4,12 );
			
			for( var a:uint = 0; a < template.length; a++ ) 
			{
				for( var b:uint = 0; b < template[a]; b++ ) 
				{
					uid.push( chars[ Math.floor( Math.random() *  chars. length ) ] );
				} 
				if( a < template.length - 1 ) 
				{
					uid.push( separator );
				}
			}
			
			return String.fromCharCode.apply( null, uid );
		}
	}
}