package com.tricedesigns.model
{
	import air.net.URLMonitor;
	
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import spark.formatters.DateTimeFormatter;

	[Bindable]
	public class URLEntry
	{
		public var url:String;
		private var monitor : URLMonitor;
		private var request : URLRequest;
		public var online : Boolean = false;
		public var lastUpdate : String = "";
		
		private static const pollInterval : Number = 10000;
		private static var updateTimer : Timer;
		private static var dateFormatter : DateTimeFormatter;
		
		public function URLEntry(url:String)
		{
			this.url = url;
			request = new URLRequest( url );
			monitor = new URLMonitor( request );
			monitor.pollInterval = pollInterval;
			monitor.addEventListener( StatusEvent.STATUS, onStatusEvent );
			monitor.start();
			
			if ( updateTimer == null )
			{
				updateTimer = new Timer(pollInterval/2);
				updateTimer.start();
			}
			if ( dateFormatter == null ) 
			{
				dateFormatter = new DateTimeFormatter();
				dateFormatter.dateTimePattern = "h:mm:ss a";
			}
			
			updateDateString();
			updateTimer.addEventListener(TimerEvent.TIMER, onTimerEvent);
		}
		
		private function onStatusEvent( event : StatusEvent ) : void
		{
			online = monitor.available;
			updateDateString();
		}
		
		private function onTimerEvent( event : TimerEvent ) : void
		{
			updateDateString();
		}
		
		private function updateDateString() : void
		{
			lastUpdate = "Updated: " + dateFormatter.format( monitor.lastStatusUpdate );
		}
		
		public function dispose() : void
		{
			monitor.stop();
			monitor.removeEventListener( StatusEvent.STATUS, onStatusEvent );
			updateTimer.removeEventListener( TimerEvent.TIMER, onTimerEvent );
			request = null;
			monitor = null;
		}
		
		public function pause() : void
		{
			monitor.stop();
		}
		
		public function resume() : void
		{
			monitor.start();	
		}
	}
}