package com.tricedesigns.event
{
	import flash.events.Event;
	
	public class URLMonitorEvent extends Event
	{
		public static const URL_MONITOR_ADD_SUCCESS : String = "URL_MONITOR_ADD_SUCCESS";
		public static const URL_MONITOR_ADD_FAIL : String = "URL_MONITOR_ADD_FAIL";
		
		public var detail : String;
		
		public function URLMonitorEvent(type:String, detail : String = null)
		{
			super(type);
			this.detail = detail;
		}
	}
}