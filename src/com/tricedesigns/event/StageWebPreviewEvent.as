package com.tricedesigns.event
{
	import flash.events.Event;
	
	public class StageWebPreviewEvent extends Event
	{
		public static const NAVIGATE : String = "NAVIGATE";
		public var url : String;
		
		public function StageWebPreviewEvent(url : String=null)
		{
			super(NAVIGATE);
			this.url = url;
		}
	}
}