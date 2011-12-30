package com.jccrosby.dmsdownloader.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class DMSModel extends EventDispatcher
	{
		public var dmsImages:ArrayCollection;
		
		public function DMSModel()
		{
			super( this );
			
			dmsImages = new ArrayCollection();
		}
	}
}